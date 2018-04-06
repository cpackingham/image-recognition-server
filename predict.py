#!/usr/bin/python3

import sys
from fastai.transforms import *
from fastai.conv_learner import *
from fastai.model import *
from fastai.dataset import *
import numpy as np
PATH='/home/paperspace/data/glowstick_or_not/'
IMPATH='/home/paperspace/glowstick/images/'
IMNAME=sys.argv[1]
sz=224
arch=resnet34
data = ImageClassifierData.from_paths(PATH, tfms=tfms_from_model(arch, sz))
learn = ConvLearner.pretrained(arch, data, precompute=False)
learn.load('224_lastlayer')
_, val_tfms = tfms_from_model(arch, sz)
im = val_tfms(open_image(IMPATH+IMNAME))
learn.predict()
preds = learn.predict_array(im[None])
prediction = np.argmax(preds)
returnValue = 'true' if prediction == 0 else 'false'
sys.stdout.write(returnValue)
sys.stdout.flush()
sys.exit(0)
