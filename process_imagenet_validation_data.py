#!/usr/bin/python
# Copyright 2016 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
r"""Process the ImageNet Challenge bounding boxes for TensorFlow model training.

Associate the ImageNet 2012 Challenge validation data set with labels.

The raw ImageNet validation data set is expected to reside in JPEG files
located in the following directory structure.

 data_dir/ILSVRC2012_val_00000001.xml
 data_dir/ILSVRC2012_val_00000002.xml
 ...
 data_dir/ILSVRC2012_val_00050000.xml

This script moves the files into a directory structure like such:
 data_dir/n01440764/ILSVRC2012_val_00000293.xml
 data_dir/n01440764/ILSVRC2012_val_00000543.xml
 ...
where 'n01440764' is the unique synset label associated with
these images.

This directory reorganization requires a mapping from validation image
number (i.e. suffix of the original file) to the associated label. This
is provided in the ImageNet development kit via a Matlab file.

In order to make life easier and divorce ourselves from Matlab, we instead
supply a custom text file that provides this mapping for us.

Sample usage:
  ./preprocess_imagenet_validation_data.py ILSVRC2012_img_val \
  imagenet_2012_validation_synset_labels.txt
"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import sys

from six.moves import xrange  # pylint: disable=redefined-builtin


if __name__ == '__main__':
  if len(sys.argv) < 4:
    print('Invalid usage\n'
          'usage: preprocess_imagenet_validation_data.py '
          '<validation data dir> <validation output data dir> <validation labels file> <validation synsets to consider> <file extension>') # xml for annotation and JPEG for image
    sys.exit(-1)
  data_dir1 = sys.argv[1]
  data_dir2 = sys.argv[2]

  validation_labels_file = sys.argv[3]
  valid_synsets_file = sys.argv[4]
  file_ext = sys.argv[5]

  # Read in the 50000 synsets associated with the validation data set.
  labels = [l.strip() for l in open(validation_labels_file).readlines()]
  unique_labels = set(labels)
  valid_labels = [l.strip() for l in open(valid_synsets_file).readlines()]
  valid_labels = set(valid_labels)
  print(len(unique_labels), len(valid_labels))
  
  # Make all sub-directories in the validation data dir.
  for label in valid_labels:
    labeled_data_dir = os.path.join(data_dir2, label)
    print('making %s directory'%labeled_data_dir)
    if not os.path.exists(labeled_data_dir):
        os.makedirs(labeled_data_dir)

  # Move all of the image to the appropriate sub-directory.
  for i in xrange(len(labels)):
    if not labels[i] in valid_labels: continue
    basename = 'ILSVRC2012_val_000%.5d.%s' % (i + 1, file_ext)
    original_filename = os.path.join(data_dir1, basename)
    if not os.path.exists(original_filename):
      print('Failed to find: ', original_filename)
      sys.exit(-1)
    new_filename = os.path.join(data_dir2, labels[i], basename)
    print('moving from %s to %s'%(original_filename, new_filename))
    os.rename(original_filename, new_filename)