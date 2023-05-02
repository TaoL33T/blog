---
layout: post
title: Switch to PipeWire, now!
date: 2021-08-07 14:46:59 +0200
description: PipeWire is a prime example of a better software replacing something and doing literary almost everying better than its predecessor.
---


PipeWire is a prime example of a better software replacing something and doing literary almost everying better than its predecessor.

So at the beginning of the year, I started watching the development of PipeWire closely.
The ultimate PulseAudio replacement was still in early development at that point but distros like Fedora were already looking at using it as a default for their newest version.
It was very interesting though because it looked like PipeWire had a way better approach at finally making Linux Audio far superior.

The state of Linux audio at that point was a little messy. 
We had PulseAudio, a working, but rather borked and hard to configure daily-use sound server that was fine for most tasks but performed really bad at low latency tasks.
And there is Jack Audio, a professional grade sound server that utilizes a ring buffer and interrupts in order to get audio latency down to a couple milliseconds on fast hardware.

Not all software did support Jack Audio though, and although far superior in functionality and resource use, it wasn't really ment to be used for simple desktop tasks that don't require low latency.
PulseAudio on the other hand suffers from a lot of badly documented configuration and just general bad code quality that made it neccessairy to restart every now and then to prevent it from doing funny stuff.

This is where PipeWire comes in.
PipeWire combines the ring buffer and high efficiency of Jack Audio with the genereal desktop readyness of PulseAudio.

It comes with a session manager that is pretty good and not buggy, like the one that PulseAudio uses.
Additionally to the native PipeWire protocol that almost no application uses at this date, PipeWire has a PulseAudio interface that works pretty well for legacy clients.
On top of that, it also has to possibility of connecting Jack applications due to the similar design approach.

Even plugin hosts like Carla works pretty much out of the box.
Although my experience with that program in particual was rather unstable.
What I did was pretty against any standard aswell though, so it might just be my faul.
I was still able to use LV2 plugins with a PulseAudio application like Firefox, which is pretty stunning.

So, combining the superior desktop audio functionaly together with Jack support, I was all in and only a single puzzle piece was missing for me to completely switch over to PipeWire and dump PulseAudio once and for all: getting Osu to run with low audio latency.

Osu was one of the reasons I had to tinker around with PulseAudio and it was a real nightmare until I finally understood how PulseAudio configuration works.
By default, the wine version that I had to use in order to get the latency to a playable state didn't really allow me to configure latency at all and just smashed a standard PulseAudio config.
I was reloading ALSA-modules to set a fixed latency in order to work around it and make it work.

This didn't work at all with PipeWire Pulse though and I was getting no audio and also no playable Osu no matter what I tried with my methods.
That was until I discovered that some talented people on the Discord of ThePoon, a streamer from France and the person I got the original wine version from, created another Wine version that was working perfectly fine with PipeWire!

How I configured that, will be the scope of another article that is going to be released soon™.

If this did convince you to switch over to PipeWire, install it (on Arch Linux) with `sudo pacman -Syu pipewire-pulse` and reboot your computer. 
Have a try if it works for you and if it doesn't just `sudo pacman -S pulseaudio` and it will be back to normal again after a reboot.
I would choose an up to date Manjaro, Arch Linux or Fedora for that, because recently there were a lot of fixes for weird clients like Firefox and bug fixes in general that improved PipeWire quite a lot.
