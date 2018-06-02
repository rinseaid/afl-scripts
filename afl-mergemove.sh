#!/bin/bash

processpath="/mnt/data/Download/Process/AFL"
outputpath="/mnt/data/AFL"
#Location of log file
LOGFILE="/config/scripts/logs/afl-mergemove.log"

if ! [ -x "$(command -v ffmpeg)" ]; then
	apt-get update
	apt-get install -y ffmpeg
fi

{
IFS=$'\n';for file in $(find "$processpath" -name '*.mp4' -type f)
do

if [ -f "$file" ]; then
 echo -e "$(date) - Processing $file"
 filepath=`echo "$file" | rev | cut -c 9- | rev`
 filename=`basename "$filepath"`
 filegroup=`find "$processpath" -name "$filename*Pt*" | sort -n`
 year=`echo "$filename" | grep -oP '\d{4}'`

 if [ ! -z "$filegroup" ]; then
 	if [[ "$file" == *Pt1* ]]; then
		echo -e "$(date) - Matching basename of $filename:\n$filegroup"
		echo -e "$(date) - Merging into single file $filename.mp4"
		IFS=$'\n'
		concatstring="concat:"
		for i in $filegroup
		do
			ffmpeg -i "$i" -c copy -bsf:v h264_mp4toannexb -f mpegts "$i.ts"
			concatstring+="$i.ts|"
		done
		concatstring=${concatstring%?}
		ffmpeg -f mpegts -i "$concatstring" -c copy -bsf:a aac_adtstoasc "$processpath/$filename.mp4"
		rm $processpath/*.ts
		echo -e "$(date) - Deleting leftover split files"
		rm "$processpath/$filename"*Pt*.mp4
		echo -e "$(date) - Moving $processpath/$filename.mp4" to "$outputpath/$year/"
		mkdir -p "$outputpath/$year/"
		mv -v "$processpath/$filename.mp4" "$outputpath/$year/"
	else
		echo -e "$file is not first file, skipping..."
	fi
 else
	if [ ! -z "$year" ]; then
		echo -e "Moving single file $file to $outputpath/$year"
		mv -v "$file" "$outputpath/$year/"
	fi
 fi
fi

done
} >> "$LOGFILE"
