MP3 = (require "../").MP3
fs  = require "fs"

describe "MP3 Parser", ->
    describe "Stream Key Generation", ->
        testKey = (fmt,cb) ->
            mp3 = new MP3
            f = fs.createReadStream($file "mp3/#{fmt}.mp3")

            mp3.once "header", (parsed) ->
                expect(fmt).to.equal parsed.stream_key
                cb()

            f.pipe(mp3)

        for k in ["mp3-44100-128-s","mp3-44100-64-s","mp3-22050-128-s","mp3-22050-64-s","mp3-22050-64-s"]
            it "correctly identifies format information (#{k})", (done) ->
                testKey k, done

    it "emits end when the file is complete", (done) ->
        mp3 = new MP3

        ended = false

        f = $file "mp3/mp3-44100-128-s.mp3"

        fstats = fs.statSync(f)

        data_size = 0

        mp3.on "frame", (frame) ->
            throw new Error "Got frame after end." if ended

            data_size += frame.length

        mp3.once "end", ->
            ended = true

            # expect final data size to be within 200 bytes (headers, partial frames, etc)
            expect(data_size).to.be.within fstats.size-200, fstats.size

            done()

        fs.createReadStream(f).pipe mp3