# Character encoding

In computing, a character encoding is used to represent a repertoire of characters by some kind of encoding system.

For more reference see the [wiki](https://en.wikipedia.org/wiki/Character_encoding) page.

## What is ASCII, ISO-8859-1 and UTF-8?

The three standards represent the computer effort to provide a coding system to represent the characters used in all languages. 
The first effort made was [ASCII](https://en.wikipedia.org/wiki/ASCII), a character encoding created for the English language (128 characters).  Due to its insufficiency to represent other characters for Latin-based languages, it was born [ISO-8859-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1) (also called LATIN-1 or ASCII extended) but since it could not represent characters from all languages (such as arabic, hebrew, chinese, japanese, etc.) appeared the UNICODE standard (of which [UTF-8](https://en.wikipedia.org/wiki/UTF-8) character encoding is part).

## Tools

If you want to determine what character encoding is used by a file ([MIME type](https://en.wikipedia.org/wiki/Media_type)).

        file -bI original.srt

For reference about **file** command see:
* [Linux](https://ss64.com/bash/file.html)
* [macOS](https://ss64.com/osx/file.html)

To convert from one encoding to another you use a tool, such as iconv. For example:

        iconv -f iso-8859-1 -t utf-8 < original.srt > converted.srt

For reference about **iconv** command see:
* [Linux](https://ss64.com/bash/iconv.html)
* [macOS](https://ss64.com/osx/iconv.html)

Then you can use diff to compare both file (original vs converted)

        diff --side-by-side --suppress-common-lines original.srt converted.srt

Also, grep is an alternative tool. For reference about **grep** command see:
* [Linux](https://ss64.com/bash/grep.html)
* [macOS](https://ss64.com/osx/grep.html)

See more examples [here](http://mindspill.net/computing/linux-notes/determine-and-change-file-character-encoding/).