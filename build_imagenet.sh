#!/bin/bash
echo 'unzipping now'
unzip /datasets/imagenet-object-localization-challenge.zip -d /datasets/imagenet/
tar -xf /datasets/imagenet/imagenet_object_localization_patched2019.tar.gz -C /datasets/imagenet/
echo 'processing validation data'

python3 process_imagenet_validation_data.py /datasets/imagenet/ILSVRC/Data/CLS-LOC/val /datasets/imagenet/ILSVRC/Data/CLS-LOC/val-proc imagenet_2012_validation_synset_labels.txt  imagenet_lsvrc_2015_synsets.txt JPEG
python3 process_imagenet_validation_data.py /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val-proc imagenet_2012_validation_synset_labels.txt imagenet_lsvrc_2015_synsets.txt xml

echo 'removing extra val files'
rm -rf /datasets/imagenet/imagenet_object_localization_patched2019.tar.gz
rm -rf /datasets/imagenet/ILSVRC/Data/CLS-LOC/val
rm -rf /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val
mv /datasets/imagenet/ILSVRC/Data/CLS-LOC/val-proc /datasets/imagenet/ILSVRC/Data/CLS-LOC/val
mv /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val-proc /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val

echo 'moving train and val images'
mv /datasets/imagenet/ILSVRC/Data/CLS-LOC/train /datasets/imagenet/train
mv /datasets/imagenet/ILSVRC/Data/CLS-LOC/val /datasets/imagenet/val

echo 'processing bounding boxes'
python3 process_bounding_boxes.py /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/train > /datasets/imagenet/train_bounding_boxes.csv
python3 process_bounding_boxes.py /datasets/imagenet/ILSVRC/Annotations/CLS-LOC/val > /datasets/imagenet/val_bounding_boxes.csv

echo 'building tf-records'
mkdir -p /datasets/imagenet/tf-records
python3 build_imagenet_data-tf2.py --train_directory /datasets/imagenet/train --validation_directory /datasets/imagenet/val --output_directory /datasets/imagenet/tf-records --train_bounding_box_file /datasets/imagenet/train_bounding_boxes.csv --val_bounding_box_file /datasets/imagenet/val_bounding_boxes.csv

echo 'making gaudi tf-records'
python3 convert_gaudi.py

echo 'done'