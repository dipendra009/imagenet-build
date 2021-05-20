#!/bin/bash

unzip /datasets/imagenet-object-localization-challenge.zip -d /datasets/imagenet/
tar -xf /datasets/imagenet/imagenet_object_localization_patched2019.tar.gz -C /datasets/imagenet/


python process_imagenet_validation_data.py /datasets/imagenet/ILSVRC/Data/CLS-LOC/val /datasets/imagenet/ILSVRC/Data/CLS-LOC/val-proc imagenet_2012_validation_synset_labels.txt  imagenet_lsvrc_2015_synsets.txt JPEG
python process_imagenet_validation_data.py /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val-proc imagenet_2012_validation_synset_labels.txt imagenet_lsvrc_2015_synsets.txt xml

rm -rf /datasets/imagenet/imagenet_object_localization_patched2019.tar.gz
rm -rf /datasets/imagenet/ILSVRC/Data/CLS-LOC/val
rm -rf /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val
mv /datasets/imagenet/ILSVRC/Data/CLS-LOC/val-proc /datasets/imagenet/ILSVRC/Data/CLS-LOC/val
mv /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val-proc /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val

ln -s /datasets/imagenet/ILSVRC/Data/CLS-LOC/train /datasets/imagenet/train
ln -s /datasets/imagenet/ILSVRC/Data/CLS-LOC/val /datasets/imagenet/val

python process_bounding_boxes.py /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/train > train_bounding_boxes.txt
python process_bounding_boxes.py /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val > val_bounding_boxes.txt

mkdir -p /datasets/imagenet/tf-records

python build_imagenet_data.py --train_directory /datasets/imagenet/ILSVRC/Data/CLS-LOC/train --validation_directory /datasets/imagenet/ILSVRC/Data/CLS-LOC/val --output_directory /datasets/imagenet/tf-records --train_bounding_box_file train_bounding_boxes.txt --val_bounding_box_file val_bounding_boxes.txt

