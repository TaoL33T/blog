---
layout: post
title: Becoming Virtual
date: 2021-02-17 16:07:42 +0100
description: So recently, I got into this whole VTuber thing.
---


So recently, I got into this whole VTuber thing.

# Getting started

The first things I tried were running Animaze by Facerig inside a virtual machine that had the GPU of my integrated Intel graphics passed through.
While I got it working in the end, the 3D performance of a Haswell era iGPU is unacceptable even for something this undemanding.
Also, I had quite strange stability problems where my CPU would lock up to 800MHz when the GPU driver of the guest OS crashes. And that happend almost everytime I'd launch a 3D application.

Anyways. 
The reviews of Animaze by Facerig were horrible and so was the software.
It didn't work on Proton because wine is really weird with passing cameras through.
(As in: You can't find any documentation of anyone ever trying it.)
So I started looking for something different.

# VSeeFace

That is when I discovered [VSeeFace](https://vseeface.icu/). 
A really nice application that allows you to utilize a protocol called [VMC](https://protocol.vmc.info/Reference) in order to stream positional data from another computer or another program on you local machine.
This could be used with the python script from [OpenSeeFace](https://github.com/emilianavt/OpenSeeFace) that was also used internally by VSeeFace.

Getting this to work wasn't plug and play though.
The pythonscript `facetacker.py` had quite q few dependecies.
Namely `python-cnnxruntime` and `python-opencv`.
Because there weren't any precompiled versions for python 3.9 that was the most recent version on Arch Linux,
i had to either compile cnnxruntime from scratch. 
Which didn't work because the package was broken at the time of writing this.

The alternative was fetching a precompiled packages from a Chinese repository.
With how tired I was in that moment and how straight forward that seemed, I just installed it and tried it.

Tada! 
It was working like a charm.
So well even, that I had some playtime with the standard character model of VSeeFace.

# Character Model

On the next day it was time to find out how to get a custom character model into the program.
It looks like the most straight forward way of accomplishing this is through a filetype name `.vrm` which probably stands for "Virtual Reality Model" or something.
But it is a standardized fileformat for 3D models to be used by the likes of VR-Chat, VRoid Studio, etc.

While discovering [this nice video series]() on how to create a character model for use in VSeeFace from scratch, I stumbled uppon Pixiv's VRoid Hub.
Just like pixiv but for 3D character models that you could use in VR-Chat.
They also had some free to use models so I downloaded a few and tried them in VSeeFace the next day.

Some of them needed adjustments for the expressions and eyes but even that seemed to work quite well.

# Creating my own

Like I just mentioned, I found a guide that teaches you how to create a VRoid character model in Blender, but seems to be a lot of work to do this properly, so I will not be touching that in this post. 
I already know how to model in Blender though, so this seems like a better option than commissioning someone for a few hundred bucks that I don't have.

I will be trying this out for sure and I'll probably learn a lot on the way, too.
Even if it's gonna require me to learn basic drawing skills and will eat up a lot of time.

# Gesture Tracking

So this was one of the biggest questions I solved just yesterday.
I saw some of the VTubers do some fancy hand gestures and use gestures in their video that really made me think about how amazing it would be to do this.

It is almost like a necessity if you want communicate properly and become even more "real".
And as it seems, it's not that hard to do.
All you need is a Leap Motion controller and a [bit of calibration](https://www.youtube.com/watch?v=R2o7R3FCEio).

Unlike some virtual reality tracking stuff, Leap Motion controlers aren't really that expensive and although sold out almost at every retailer, you can still get your hands on one of them on ebay with a bit of luck.
You'd then hook this up to your computer and position it inside the 3D space in VSeeFace.

XBox Kinect tracking is also a thing but it only with with Kinect V1 which is rather limited and doesn't really have any advantate over Leap Motion tracking.
Leap Motion even tracks every individual finger.
It's kinda insane you can get such a device for around 120€.

# Conclusion

So after a few days a late night research I finally have a more clear idea of how to become virtual.
I really like this format as it is an entirely different way of expression yourself that I can't even tell you how excited I am to try out.

I will be designing a character together with my girlfriend and I can't even imagine how cool this is going to be. uwu

For a perfect experience a few things are missing though:

1. A proper camera.	
This was one of the most difficult things to get perfect. 
The camera of my laptop wasn't suitable for this kind of task as it is located at the bottom of the screen and doesn't see my face properly when positioned on my desk.
What I used in the end was ton of lighting and the camera of my smartphone via DroidCam.
Not a solution I will be keeping, but worth knowing if you are having issues to a limited camera setup aswell.
I will definetly have to invest in a semi proper webcam.
The Logitech C920 seems like a good option for that.

2. Leap motion controler.
I absolutely need this.
I can't live without gestures.
It adds another dimension of expression that makes the experience so much more exciting.
(Also I am probably a nerd for this kinda stuff)

3. A character model.
This is going to be the only thing that is going to consume a lot of time and where it's the least straight forward.
But I'll get there, eventually.

For now, I'll just play with the few free models that I found and use those to get set up.

<!-- eol -->

In the end I will be using my laptop to track my face and fingers which then renders the 3D model and sends the virtual camera to my NAS.
My Desktop where the games will be running on will be streaming the audio of my mixing desk together with the video of my main monitor to my NAS.
OBS will be running on the NAS and will be receiving both of the streams so I can properly integrate them with a layout and scene setting.
Also I wanna stream to YouTube and Twitch at the same time if possible and I want both of the superchats to appear in my stream.

I have never gotten into this whole donations and sub thing but I wanna integrate that aswell.
I am hoping I can just use OBS plugins that will run on Linux aswell.

The only Windows computer in this setup will be my laptop because I doubt VSeeFace will recognize the Leap Motion controller on Linux running through Wine even though a Linux driver and SDK exists.

You will be hearing from me again when I have started working on that character model or when I get my hands on a Leap Motion controller and new camera.

Until the next post!
