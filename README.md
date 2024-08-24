These are scripts that I use to reorder mp3s I have extracted from Audio Book CDs that I borrow from the library.

# TLDR
```
./bin/reorder-files.rb ~/Music/Audiobook/Book1 -s -t "Book1"

./bin/reorder-files.rb "/Volumes/music/Audiobooks/Non Fiction/Buddhism Audiobooks/Buddhism Without Beliefs.mp3" -s
```

# Required tools
## Install taglib:

```
brew install taglib
```
Run bundler:
```
bundle install
```
# Split and Reorder files in directory (use -s)
```
./bin/reorder-files.rb ~/Music/Audiobook/12\ Rules\ for\ Life -s -t "12 Rules for Life"
```

# Split and Reorder single mp3 file (use -s), will use original title
```
./bin/reorder-files.rb "/Volumes/music/Audiobooks/Non Fiction/Zen Buddhism Audiobooks/101 Zen Stories.mp3" -s
./bin/reorder-files.rb "/Volumes/music/Audiobooks/Non Fiction/Zen Buddhism Audiobooks/101 Zen Stories.mp3" -s -t "101-Zen-Stories"
```


# Reorder files only
```
./bin/reorder-files.rb ~/Music/Audiobook/12\ Rules\ for\ Life -t "12 Rules for Life"
```




# Reorder files (new version)
```
ruby ./bin/ord2.rb ~/books/Agassi_Open -r -t "Agassi Open"
```
## Options

| option    | purpose                                                                    |
|-----------|----------------------------------------------------------------------------|
| -r        | recursively parse a directory, ordering files by directory first then name |
| -t "Name" | id3 album and title tag for mp3s, if not provided will use directory name  |

# Other programs:

## Mp3split
Split files into 10 minute segments:
```
mp3splt -t 10.00 -d split *.mp3
```
Split file into 4 even segments:
```
mp3splt -S 4 -d split *.mp3
```
## convert to mp3 from mp4/m4a
```
ffmpeg -i input.mp4 output.mp3
ffmpeg -i input.m4a output.mp3
```

## find all mp3 files in directory:
find "My Book" -type f -name "*.mp3" -exec cp {} newfolder \;

## Show tracks on cd
```
cdparanoia -vsQ
```
Rip Tracks:
```
abcde -o mp3
```

show track info
```
ffprobe 10.Track_10.mp3
```

Extract audio from movie file:
```
ffmpeg -i Trolls.2016.mp4 -b:a 96K -vn trolls-2016.mp3
```
