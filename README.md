These are scripts that I use to reorder mp3s I have extracted from Audio Book CDs that I borrow from the library. 

# Require tools
## Install taglib:

```
brew install taglib
```
Run bundler:
```
bundle install
```

# Reorder files
```
ruby bin/reorder-files.rb "~/Music/Audio Books/Men Who Lost America/100" "Men Who Lost America 100"
```

# Reorder file (new version)
```
ruby ./bin/ord2.rb ~/books/Agassi_Open -r -t "Agassi Open"
```
# Options

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
show track info
```
ffprobe 10.Track_10.mp3
```

