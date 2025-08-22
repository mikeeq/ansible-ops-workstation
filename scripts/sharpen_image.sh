#!/bin/bash

# Input and output video filenames
input_video="test2.mp4"
output_video="output_sharpened.mp4"
frames_dir="frames"
WorkingDir=~/Videos/

cd $WorkingDir

# Create frames directory
mkdir -p $frames_dir

# Extract frames from video
ffmpeg -i $input_video -q:v 2 $frames_dir/frame_%04d.png

# Call Python script to sharpen frames
python3 <<EOF
import cv2
import numpy as np
import glob

frames_dir = "$frames_dir"
frame_files = sorted(glob.glob(frames_dir + "/frame_*.png"))

# Sharpening kernel
kernel = np.array([[0, -1, 0],
                   [-1, 5, -1],
                   [0, -1, 0]])

for f in frame_files:
    img = cv2.imread(f)
    if img is None:
        continue
    sharpened = cv2.filter2D(img, -1, kernel)
    cv2.imwrite(f, sharpened)
EOF

# Recompile sharpened frames into video (same frame rate as input)
fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "$input_video")
ffmpeg -framerate $(echo "$fps" | bc -l) -i $frames_dir/frame_%04d.png -c:v h264_v4l2m2m -pix_fmt yuv420p $output_video

# Clean up frames if desired
# rm -r $frames_dir

echo "Sharpened video saved as $output_video"
