#brew install unrar
if [ -f original.srt ]; then rm original.srt; fi
if [ -f converted.srt ]; then rm converted.srt; fi
if [ -f *.zip ]; then echo 'Extracting ZIP file...'; unzip -a *.zip; fi
if [ -f *.rar ]; then echo 'Extracting RAR file...'; 7z e *.rar; fi
mv *.srt original.srt
echo "Original file: "
file -bI original.srt
iconv -f iso-8859-1 -t utf-8 < original.srt > converted.srt
echo "Converted file: "
file -bI converted.srt
