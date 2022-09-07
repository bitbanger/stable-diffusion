#!/usr/bin/bash

rm outputs/txt2img-samples/samples/* >/dev/null 2>/dev/null

r=$RANDOM

echo "making image (seed ${r})..."
python scripts/txt2img.py --prompt "${1}" --plms --ckpt sd-v1-4.ckpt --skip_grid --n_samples 1 --n_iter 1 --seed ${r} >/dev/null 2>/dev/null
echo "done"

cd outputs/txt2img-samples/samples
for i in $(ls pred*.png); do mv ${i} $(echo ${i} | awk '{split($0,a,"_"); print a[2];}'); done
echo "encoding video..."
# /home/lane/ffmpeg_sources/ffmpeg/ffmpeg -framerate 15 -pattern_type glob -i '*.png' -vcodec libx264 -qp 0 -pix_fmt yuv420p -vf tpad=stop_mode=clone:stop_duration=2 out.mp4 >/dev/null 2>/dev/null
/home/lane/ffmpeg_sources/ffmpeg/ffmpeg -framerate 5 -pattern_type glob -i '*.png' -vcodec libx264 -crf 0 -preset ultrafast -qp 0 -pix_fmt yuv420p -vf tpad=stop_mode=clone:stop_duration=4 out.mp4 >/dev/null 2>/dev/null
echo "done"
mv out.mp4 ../../../
cd ../../../
vlc --loop out.mp4 >/dev/null 2>/dev/null
