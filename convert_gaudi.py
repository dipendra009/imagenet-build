import os
import shutil

train_dir = '/datasets/imagenet/tf-records/img_train'
val_dir = '/datasets/imagenet/tf-records/img_val'

source_dir = '/datasets/imagenet/tf-records/'


os.makedirs(train_dir, exist_ok=True)
os.makedirs(val_dir, exist_ok=True)

for fp in os.listdir(source_dir):
    if 'train-0' in fp:
        shutil.copy(os.path.join(source_dir, fp), os.path.join(train_dir, 'img_%s'%fp))
    elif 'validation-0' in fp:
       fp1 = fp.replace('validation', 'val')
       shutil.copy(os.path.join(source_dir, fp), os.path.join(val_dir, 'img_%s'%fp1)) 
