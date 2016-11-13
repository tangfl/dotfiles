#!/bin/sh
#
# backup photos by year/month/day dir structure
#

SOURCE="/Users/tangyuchen/Pictures"
#SOURCE="/Users/tangyuchen/Pictures/photos_2012/i909_2012/"

TARGET="/Volumes/niuniu/photo"
CMDSHELL="/Users/tangyuchen/bin/backupCmd.sh"


function getJPGDateTime() {
    local file="$1"
    dt=`echo "package require jpeg; set result [jpeg::getExif \"$file\" main]; dict with result { puts \\"\\$DateTime\\"}"|tclsh|sed "s/ /:/"`
    echo $dt
}

function getVideoDateTime() {
    local file="$1"
    dt=`mediainfo $file | grep "Encoded date" | head -n 1 | awk '{print $5 ":" $6}' | sed "s/-/:/g"`
    echo $dt
}

find $SOURCE -type f -iname "*.*" -print0 | while IFS= read -r -d '' file; do
    #echo "file is: $file"
    fileName=${file##*/}

    dateTime="2016:11:12:19:11:22"
    if [[ $fileName == *.jpg || $fileName == *.JPG ]]; then
        dateTime=$(getJPGDateTime "$file")
    fi
    if [[ $fileName == *.mov || $fileName == *.MOV || $fileName == *.mp4 || $fileName == *.MP4 ]]; then
        dateTime=$(getVideoDateTime "$file")
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

        #touch source file time
        touchTime="${year}${month}${day}${hour}${minute}"
        touchCmd="touch -c -a -m -t $touchTime \"$file\""
        echo "$touchCmd" >> $CMDSHELL

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
    else
        echo "$backupCmd" >> $CMDSHELL
    fi
    #sleep 2

done


