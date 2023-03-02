#!/bin/sh

FACTOR=''
TAG=''
INPUTFILE=''
IMAGE=''
I_FLAG='false'
BLUR_FLAG='false'

usage() {
    echo "Usage: ..."
}

if [ "$#" -eq 0 ]; then
    usage
    exit 1
fi

while getopts ':nsf:i:b' flag; do
    case "${flag}" in
        n) FACTOR='1.21'
           TAG='[NIGHTCORE]' ;;
        s) FACTOR='0.82'
           TAG='[slowed]' ;;
        f) INPUTFILE="${OPTARG}" ;;
        i) IMAGE="${OPTARG}" 
           I_FLAG="true" ;;
        b) BLUR_FLAG="true" ;;
        *) usage
           exit 1 ;;
    esac
done

OUTPUTFILE="$TAG $INPUTFILE"

echo "Modifying your audio..."

# perfect nightcore formula
ffmpeg -loglevel quiet -i "$INPUTFILE" -filter:a "\
    rubberband=pitch=$FACTOR\
    :tempo=$FACTOR\
    :pitchq=quality\
    " -vn  "$OUTPUTFILE" -stats ${progress}

if [ "$I_FLAG" = 'false' ]; then
    exit 1
fi

OUTPUT_VIDEO="${OUTPUTFILE%.*}"

echo "Rendering video..."

# i stole this from https://stackoverflow.com/questions/30789367/ffmpeg-how-to-convert-vertical-video-with-black-sides-to-video-169-with-blur

if [ "$BLUR_FLAG" = 'true' ]; then

    ffmpeg -loglevel quiet -loop 1 -i "$IMAGE" -i "$OUTPUTFILE" -acodec aac -vcodec libx264 -shortest -vf "split[original][copy];[copy]scale=ih*16/9:-1,crop=h=iw*9/16,gblur=sigma=20[blurred];[blurred][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2,scale=1920x1080" "${OUTPUT_VIDEO}.mp4" -stats ${progress}
    
    exit 1
fi

ffmpeg -loglevel quiet -loop 1 -i "$IMAGE" -i "$OUTPUTFILE" -acodec aac -vcodec libx264 -shortest -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2,scale=1920x1080" "${OUTPUT_VIDEO}.mp4" -stats ${progress}
