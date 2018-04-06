defmodule Glowstick.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  post "/api/glowstick" do
    base64 = get_body(conn)
    task = Task.async(fn -> process_base64(base64) end)
    case Task.await(task, 20000) do
      {:ok, result} -> send_resp(conn, 201, result)
      {:error, reason} -> send_resp(conn, 400, "Bad request!")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end 

  def get_body(conn, body \\ "") do
    case Plug.Conn.read_body(conn) do
      {:ok, binary, conn} ->
        body <> binary
      {:more, binary, conn} ->
        get_body(conn, body <> binary)
      {:done, conn} ->
        body
      _ -> 
        IO.puts("Problem parsing body!")
    end
  end

  def process_base64(base64) do
    image_name = UUID.uuid4() <> ".jpg"
    path =  Path.expand("./images/" <> image_name) |> Path.absname 
    base64Decoded = wrap_base64_decoding(base64)
    case File.write(path, base64Decoded) do
      :ok -> run_python(image_name)
      {:error, reason} ->
        IO.puts(reason)
        {:error, reason}
    end
  end

  def wrap_base64_decoding(base64) do
    case Base.decode64(base64) do
      {:ok, binary} -> binary
      :error -> :error
    end
  end

  def run_python(filename) do
    {result, status} = System.cmd("python", ["predict.py", filename])
    {:ok, result}
  end

end
