# ImageNet Build and Prepare Script

Contains files for preparing imagenet dataset for training using TensorFlow and PyTorch.

Includes following script:
- preprocessing validation images and annotations to move to folder with 'synset' as name.
- calculate the bounding boxes from the annotation files.
- conversion to TF records using TensorFlow 2.
- creating symlinks for training using PyTorch.

