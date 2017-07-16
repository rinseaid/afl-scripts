#!/bin/bash

#For deluge
#torrentid="$1"
#torrentname="$2"
#torrentpath="$3"

#For transmission
torrentid="$TR_TORRENT_ID"
torrentname="$TR_TORRENT_NAME"
torrentpath="$TR_TORRENT_DIR"

echo $torrentpath
echo $torrentname

if [ $torrentpath == "/mnt/data/Download/transmission/complete/aussierul.es" ]; then
   destpath="/mnt/data/Download/Process/AFL/Inbox"
   cp -lr "$torrentpath/$torrentname" $destpath
   /config/scripts/afl-rename.sh
   /config/scripts/afl-mergemove.sh
fi
