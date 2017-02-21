# Character encoding [wiki](https://en.wikipedia.org/wiki/Character_encoding)

In computing, a character encoding is used to represent a repertoire of characters by some kind of encoding system.

## What is ASCII, ISO-8859-1 and UTF-8?

The three standards represent the computer effort to provide a coding system to represent the characters used in all languages. The first effort was made by ASCII and it was for the English language (128 characters), then due to its insufficiency to represent other characters such as Latin for example, it was born ISO-8859-1 (also called LATIN-1 or ASCII extended) but since it could not represent characters from other languages appears the UNICODE standard (of which UTF-8 is part).

## Tools

To convert from one encoding to another you use a tool, such as iconv. For example:

        iconv -f iso-8859-1 -t utf-8 < original.txt > converted.txt

For reference about **iconv** see:
* [Linux](https://ss64.com/bash/iconv.html)
* [macOS](https://ss64.com/osx/iconv.html)

Then you can use grep to compare both file (original vs converted)

        grep -Fxvf original.txt converted.txt

For reference about **grep** see:
* [Linux](https://ss64.com/bash/grep.html)
* [macOS](https://ss64.com/osx/grep.html)