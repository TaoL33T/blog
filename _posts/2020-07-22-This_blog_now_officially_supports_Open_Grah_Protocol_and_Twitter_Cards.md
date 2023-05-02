---
layout: post
title: This blog now officially supports Open Grah Protocol and Twitter Cards
date: 2020-07-22 10:55:04 +0200
description: As the title suggests, I have now successfully integrated the Open Graph Protocol for Discord, WhatsApp and the likes. Of course, Twitter Cards also needed to be added as this is the main social network I still use.
---


As the title suggests, I have now successfully integrated the Open Graph Protocol for Discord, WhatsApp and the likes.
Of course, Twitter Cards also needed to be added as this is the main social network I still use.

Twitter Cards, if you didn't know, is this nice little card that is shown whenever you post a link to a webpage on twitter that does support OG.
It looks something like this:

<div style="text-align:center"><img width="100%" src="https://f.lucy.moe/m20V" alt="Twitter Card of lucy.moe"/></div>

Other applications do also support that.
For example Discord:

<div style="text-align:center"><img width="100%" src="https://f.lucy.moe/3dWf" alt="Discord Card of lucy.moe"/></div>

And also WhatsApp:

<div style="text-align:center"><img width="100%" src="https://f.lucy.moe/nH5t" alt="WhatsApp Card of lucy.moe"/></div>

I really wanted to have this, because it makes the webpage seem more professional to people scrolling by on a social media site.
Just the blank link isn't very appealing at all in my opinion and so I had to implement it.

Basically, the information shown on the cards is implemented via metadata in the html-`<head>`, which looks something like this for my second post:

```xml
<meta property="og:author" content="Lucy" />
<meta property="og:article:author" content="Lucy" />
<meta property="og:title" content="How I tied two VPNs and two home networks together to share files." />
<meta property="twitter:title" content="How I tied two VPNs and two home networks together to share files." />
<meta property="og:image" content="https://f.lucy.moe/pb.jpg" />
<meta property="twitter:image" content="https://f.lucy.moe/pb.jpg" />
<meta property="og:description" content="So, have you ever heared of wireguard? The VPN that everyone speaks of and that is rising fast because it is very fast and has very low latency. Essentially, it’s not even a VPN. All it is, is a very efficient and encrypted tunnel between two computers. It allows you to create a virtual network between any number of devices." />
<meta property="twitter:description" content="So, have you ever heared of wireguard? The VPN that everyone speaks of and that is rising fast because it is very fast and has very low latency. Essentially, it’s not even a VPN. All it is, is a very efficient and encrypted tunnel between two computers. It allows you to create a virtual network between any number of devices." />
<meta property="twitter:card" content="summary" />
<meta property="og:site_name" content="Lucys Blog" />
<meta property="og:url" content="https://2020-07-16_wireguard-part1.html" />
<meta property="og:article:published_time" content="2020-07-17T00:00:00+02:00" />
```

`og:article:published_time`, `og:article:author` and `og:author` are rarely used though, but I wanted to implement this for the extra portion of autism.

Anyways, to do that, I decided to use pandocs metadata functionality that would let me define custom variables in the markdown files. 
These variables can then be used inside pandoc-templates.
I added statements that would add the title, image and description for Twitter Cards and Open Graphs and also statements for the URL 
and the name of the site that would appear next to the description and image.

For things that would be global to all posts, like the image and `site_name`, I decided to add a default metadata file, which looks like this:

```yaml
---
author: Lucy
site-name: Lucys Blog
og-type: artice
header-image: 'https://f.lucy.moe/pb.jpg'
...
```
This file is now also added first for the pandoc command, that generates the posts.
For example, this is how the command in `create_entry()` looks like:

```bash
pandoc -s --css=/css/sakura-vader.css --template=./pandoc-template-v2.2.1.html5 \
    -V og-url="https://$outpath" -V published-date="$published_date" \
    -V include-footer="$footer" \
    src/meta/default.yaml "$path" -t html5 -f markdown -o "dist/$outpath"
```

`src/meta/default.yaml` is where all the standard stuff is included. 
Having this at the beginning of the command allows me to later overwrite these values in the source file of the post if I desire.

The `-V` statements add additional information to the document, like the url, so I don't have to type that by hand (and it is already known anyways),
and the published date, that is read from the `date` directive in the source file anyways because it is used to generate the RSS-feed.

Also, I had to deal with the footer in a different way because it was included in the body before the date and author (that I also move to the bottom).
The `-V footer="$footer"` is including raw html-text that is then added *at the far end* of the body after the date and author.

Overall, I am fine with this solution, it works very well for what I wanted and I have full control over it.
All that is left now is to write posts!
And so I did!
Cheers.
