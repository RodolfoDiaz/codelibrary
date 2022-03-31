#brew install unrar
if [ "$1" == "" ]; then
  if [ -f original.srt ]; then rm original.srt; fi
  if [ -f converted.srt ]; then rm converted.srt; fi
  if [ -f *.zip ]; then echo 'Extracting ZIP file...'; unzip -a *.zip; fi
  if [ -f *.rar ]; then echo 'Extracting RAR file...'; 7z e *.rar; fi
  mv *.srt original.srt
  echo 'Original file: '
  file -bI original.srt
  iconv -f iso-8859-1 -t utf-8 < original.srt > converted.srt
  echo 'Converted file: '
  file -bI converted.srt
fi

if [ "$1" == "check" ]; then
  echo 'Cleanup "Backup" volume... '
  cd /Volumes/Backup/Media/
  find . -name '._*' -type f -delete
  find . -name '.DS_Store' -type f -delete
  echo 'Searching SRT files... '
  grep --include='*.srt' -rin 'yts.mx' .
  grep --include='*.srt' -rin 'yify' .
  grep --include='*.srt' -rin 'tamabin' .
  cd ~
fi