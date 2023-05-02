---
layout: post
title: "Download Part of a Twitch VOD with ffmpeg"
date: 2022-02-21 14:02:13 +0100
description: This is how to download a part of very long Twitch VOD without downloading the whole video.
---


So what if you want to download part of a Twitch VOD that's longer than a clip? (~1 minute or so) 
Recently I had this situation that a VTuber I like watching was doing an extended 24 hour stream and right at the end there was a part that I wanted to cut out.
It was too long for a clip and also I didn't want to download the whole 27 hours of video just to cut out this 2 minute section.
So I wrote down timestamps and took `ffmpeg` to the rescue.

Programs required for this are `ffmpeg` ([ffmpeg.org](https://ffmpeg.org/)) and `youtube-dl`.

## Cutting out a section of a video with ffmpeg

In general, all you need to do, is tell ffmpeg to fast forward to a timestamp that you supply, like that:

```bash
ffmpeg -ss 00:15:11 -i [input file] …
```

We put the `-ss` flag before the input file so that ffmpeg fasts forward to this time stamp before starting to read the file.
Time stamps are supplied in `hh:mm:ss` format where `h` equals hours, `m` equals minutes and `s` equals seconds.

The next thing we need to tell ffmpeg is how long the section is.
If your section is 2 minutes long, an according ffmpeg command line would look like this:

```bash
ffmpeg -ss 00:15:11 -i [input file] -t 00:02:00 …
```

If you do want to keep the entire end of the video, you may omit the `-t` option.

### losslessly

Explaining this deeper would be beyond the scope of this artice, all you need to know is that there's a way to extract a video-track without re-encoding the video.
This is how that is done in ffmpeg. 

We just need to tell ffmpeg to copy both the audio and video tracks into the output file:

```bash
ffmpeg -ss 00:15:11 -i [input file] -t 00:02:00 -codec copy output.mp4
```

If you get errors about the container format not supporting the video/audio that you want to put into it, try `.mkv` instead of `.mp4`.

If your video is stuck for the first couple of seconds/frames or your video and audio are out of sync in stupid video players, you need to **reencode**.
ffmpeg can only cut the video losslessly at an I-frame, so if the next I-frame is seconds away from the timestamp you supplied, you will have a still image until the I-frame comes up.
(This is the part that gets way too complicated for a simple how to like this, but at least now you know what to look up if you want to learn more.)

### re-encoding

This is pretty straight forward.
Instead of telling ffmpeg to copy all of the streams, we tell it to only copy the audio, but reencode the video with x264.

```bash
ffmpeg -ss 00:15:11 -i [input file] -t 00:02:00 -c:a copy -c:v libx264 -crf 19 -profile high -preset veryslow output.mp4
```

Also, this will not just fix any weirdness you encounter, it will also save you on file-size if there isn't happening much on screen in the video.

## How to do that with Twitch VODs without downloading the entire VOD

Okay so this is what I would have done if the input file was on my local harddrive.
Conveniently, ffmpeg also supports m3u8 playlist as an input so we just need to supply the extracted video URL from youtube-dl.

Get the video URL like this:

```bash
youtube-dl -g [URL to VOD]
```

Then copy the URL that youtube-dl returns and insert that for `[input file]`.
Press enter and watch the magic go!

Congrats!
There's your cut out section!

## Disclaimer

Creating a local copy is okay, at least to current german law.
Twitch VODs are not digital rights management protected content.
But ask the creator before sharing sections of their VOD.
This should be common knowledge but I feel like I need to say this regardless.

Now have fun creating long clips of your favourite streamers!
