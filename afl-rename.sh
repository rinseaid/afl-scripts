#!/bin/bash

inboxpath="/mnt/data/Download/Process/AFL/Inbox"
renamepath="/mnt/data/Download/Process/AFL/Rename"
processpath="/mnt/data/Download/Process/AFL"

#Location of log file
LOGFILE="/config/scripts/logs/afl-rename.log"

{
echo "$(date) - moving mp4 files within subdirectories to $renamepath"
mv -v "$inboxpath"/*/*.mp4 "$renamepath"
echo "$(date) - moving single mp4 files within $renamepath"
mv -v "$inboxpath"/*.mp4 "$renamepath"
cd "$inboxpath"
echo "$(date) - deleting empty subdirectories within $inboxpath"
find "." -type d -empty -delete -print

cd "$renamepath"
echo "$(date) - renaming mp4 files within $renamepath"
#Split-VB
rename -v 's/.*(2[\d]{3}).*Round\s([\d]{1,2})\W{1,3}(.*)\sv\s(.*?)\s(720|x264).*([1-9])[strdnh]{2}.*/$1.sprintf(" - Round ").sprintf("%02d - ",$2).$3.sprintf(" vs. ").$4.sprintf(" Pt").$5.sprintf(".mp4")/e' "$renamepath"/*.mp4
#Single-VB
rename -v 's/.*(2[\d]{3}).*Round\s([\d]{1,2})\W{1,3}(.*)\sv\s(.*?)\s(720|x264).*/$1.sprintf(" - Round ").sprintf("%02d - ",$2).$3.sprintf(" vs. ").$4.sprintf(".mp4")/e' "$renamepath"/*.mp4
#Split
rename -v 's/.*(2[\d]{3}).*Round\s([\d]{1,2})\W{1,3}(.*)\sV\s(.*?)\s(720|x264).*([1-9])[strdnh]{2}.*/$1.sprintf(" - Round ").sprintf("%02d - ",$2).$3.sprintf(" vs. ").$4.sprintf(" Pt").$5.sprintf(".mp4")/e' "$renamepath"/*.mp4
#Single
rename -v 's/.*(2[\d]{3}).*Round\s([\d]{1,2})\W{1,3}(.*)\sv\s(.*?)\s(720|x264).*/$1.sprintf(" - Round ").sprintf("%02d - ",$2).$3.sprintf(" vs. ").$4.sprintf(".mp4")/e' "$renamepath"/*.mp4
#Split-VB-Finals
rename -v 's/.*(2[\d]{3}).*([1-9].*Final).*\W{1,3}(.*)\sv\s(.*?)\s(720|x264).*([1-9])[strdnh]{2}.*/$1.sprintf(" - ").$2.sprintf(" - ").$3.sprintf(" vs. ").$4.sprintf(" Pt").$5.sprintf(".mp4")/e' "$renamepath"/*.mp4
#Single-VB-Finals
rename -v 's/.*(2[\d]{3}).*([1-9].*Final).*\W{1,3}(.*)\sv\s(.*?)\s(720|x264).*/$1.sprintf(" - ").$2.sprintf(" - ").$3.sprintf(" vs. ").$4.sprintf(".mp4")/e' "$renamepath"/*.mp4
#Split-Finals
rename -v 's/.*(2[\d]{3}).*([1-9].*Final)\W{1,3}(.*)\sV\s(.*?)\s(720|x264).*([1-9])[strdnh]{2}.*/$1.sprintf(" - ").$2.sprintf(" - ").$3.sprintf(" vs. ").$4.sprintf(" Pt").$5.sprintf(".mp4")/e' "$renamepath"/*.mp4
#Single-Finals
rename -v 's/.*(2[\d]{3}).*([1-9].*Final)\W{1,3}(.*)\sv\s(.*?)\s(720|x264).*/$1.sprintf(" - ").$2.sprintf(" - ").$3.sprintf(" vs. ").$4.sprintf(".mp4")/e' "$renamepath"/*.mp4

echo "$(date) - moving renamed files to $processpath"
mv -v *.mp4 "$processpath"
} >> "$LOGFILE"

