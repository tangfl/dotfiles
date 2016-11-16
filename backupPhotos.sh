#!/bin/bash
#
# backup photos by year/month/day dir structure
#
# mediainfo: https://mediaarea.net/zh-CN/MediaInfo/Download/Mac_OS
# exif: port install exif
#

SOURCE="${HOME}/Pictures/photos.photoslibrary/Masters"
RMSOURCE="false"

TARGET="${HOME}/Pictures/photo"
CMDSHELL="${HOME}/bin/cmd.sh"

function getJPGDateTime() {
    local file="$1"
    dt=`exif -m "$file" | grep "Date and Time" | grep -v "(" |  head -n 1 | awk '{print $4 ":" $5}' | sed "s/-/:/g"`
    echo $dt
}

function getVideoDateTime() {
    local file="$1"
    dt=`mediainfo -f "$file" | grep "Encoded date" | head -n 1 | awk '{print $5 ":" $6}' | sed "s/-/:/g"`
    echo $dt
}

find $SOURCE -type f -iname "*.*" -print0 | \
while IFS= read -r -d '' file; do
    #echo "file is: $file"
    fileName=${file##*/}

    dateTime="2016:11:12:19:11:22"
    if [[ $fileName == *.jpg || $fileName == *.JPG || $fileName == *.png || $fileName == *.PNG ]]; then
        dateTime=$(getJPGDateTime "$file")
    elif [[ $fileName == *.mov || $fileName == *.MOV || $fileName == *.mp4 || $fileName == *.MP4 \
    || $fileName == *.avi || $fileName == *.AVI ]]; then
        dateTime=$(getVideoDateTime "$file")
    else
        echo "# ignore file $file" >> $CMDSHELL
        continue
    fi

    #echo "$file : $dateTime"

    year=`echo $dateTime | awk -F':' '{print $1}'`
    month=`echo $dateTime | awk -F':' '{print $2}'`
    day=`echo $dateTime | awk -F':' '{print $3}'`
    hour=`echo $dateTime | awk -F':' '{print $4}'`
    minute=`echo $dateTime | awk -F':' '{print $5}'`

    targetDir="$TARGET/notime"
    if [[ $year == "20"* || $year == "19"* ]]; then
        targetDir="$TARGET/$year/$month/$day"
    else
        #echo "#$file has no date time metainfo" >> $CMDSHELL
        targetDir="$TARGET/notime"
    fi

    if [[ ! -d $targetDir ]]; then
        echo "creating target dir $targetDir"
        mkdir -p $targetDir
    fi

    filePrefix=""
    targetFileName=`echo $fileName | sed "s/ /_/" `
    if [[ $fileName == *IMG_* || $fileName == *MOV_* ]]; then
        if [[ $year == "20"* || $year == "19"* ]]; then
            filePrefix=`echo $dateTime | awk -F":" '{print $1 "-" $2 "-" $3 "_" $4 "." $5 "." $6 "-"}'`
        fi
    fi
    targetFile="${filePrefix}${targetFileName}"

    # -n means do not overwrite
    # -p means keep attributes like atime, mtime
    #cp -n -p \"$file\" \"$targetDir/$targetFile\"

    backupCmd="cp -n -p \"$file\" \"$targetDir/$targetFile\""

    if [[ -f "$targetDir/$targetFile" ]]; then
        echo "#$backupCmd" >> $CMDSHELL
        if [[ x$RMSOURCE == "xtrue" ]]; then
            rm -f "$file"
        fi
    else
        echo "$backupCmd" >> $CMDSHELL
        #touch source file time
        touchTime="${year}${month}${day}${hour}${minute}"
        if [[ "x"$touchTime != "x" ]]; then
            touchCmd="touch -c -t $touchTime \"$targetDir/$targetFile\""
            echo "$touchCmd" >> $CMDSHELL
        fi
    fi
    #sleep 2

done
