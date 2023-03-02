#!/bin/sh

FACTOR=''
TAG=''
INPUTFILE=''
IMAGE=''
I_FLAG='false'

usage() {
    echo "Usage: ..."
}

if [ "$#" -eq 0 ]; then
    usage
    exit 1
fi

while getopts ':nsf:i:' flag; do
    case "${flag}" in
        n) FACTOR='1.21'
           TAG='[NIGHTCORE]' ;;
        s) FACTOR='0.82'
           TAG='[slowed]' ;;
        f) INPUTFILE="${OPTARG}" ;;
        i) IMAGE="${OPTARG}" 
           I_FLAG="true" ;;
        *) usage
           exit 1 ;;
    esac
done

OUTPUTFILE="$TAG $INPUTFILE"

echo "Modifying your audio..."

# perfect nightcore formula
ffmpeg -loglevel quiet -y -i "$INPUTFILE" -filter:a "\
    rubberband=pitch=$FACTOR\
    :tempo=$FACTOR\
    :pitchq=quality\
    " -vn  "$OUTPUTFILE" -stats ${progress}

if [ "$I_FLAG" = 'false' ]; then
    exit 1
fi

OUTPUT_VIDEO="${OUTPUTFILE%.*}"

echo "Rendering video..."

ffmpeg -loglevel quiet -loop 1 -i "$IMAGE" -i "$OUTPUTFILE" -acodec aac -vcodec libx264 -shortest -vf scale=1920:1080 "${OUTPUT_VIDEO}.mp4" -stats ${progress}
