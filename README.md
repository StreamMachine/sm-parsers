# sm-parsers

This package provides frame parsers for MP3 and AAC audio. They are used in
[StreamMachine](https://github.com/StreamMachine/StreamMachine) for parsing
incoming audio sources.

## How to Use

Both parsers take an IO stream in and emit `frame` events for each audio frame.
Events are also emitted for `header`, `id3v1`, `id3v2` and `debug`.

Example:

```coffee
    fs = require "fs"
    Parser = (require "sm-parsers").MP3

    mp3 = fs.createReadStream("./mymp3.mp3")

    p = new Parser

    p.on "frame", (frame,header) ->
      # do something...

    mp3.pipe(p)
```