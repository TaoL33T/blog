---
layout: post
title: How this site was made (old)
date: 2020-07-12 00:00:00 +0200
description: I was pissed by wordpress. Like, really really pissed. It was just all too much. All I wanted was a nice website where I could put markdown files in and out would come posts. So I started to think about creating my own.
---

{% include old-site-notice.html %}

I was pissed by wordpress.
Like, really really pissed.
It was just all too much.
All I wanted was a nice website where I could put markdown files in and out would come posts.
So I started to think about creating my own.

Having played with some static site generators like Jekyll and also what pandoc offers, I knew exactly what I wanted: pure markdown and html.
I didn't like Jekyll because it was very confusing and the only way to properly use it was to steal someone elses design work.
And it did more than I needed anyways.

I wanted all the posts to appear in a list on the front page, ordered by the time they were created.
And I wanted to write in vim and inside markdown and the html pages should be created from these files.
A RSS feed was something I didn't know existed back then. 

Coincidentally, a friend of mine, [kageru](https://blog.kageru.moe) to be exact, published a [post on his blog](https://blog.kageru.moe/content/lesscode.html) about *exactly* this topic.
He was doing exactly what I wanted, altough somewhat unconventional with some fancy nginx-magic that I didn't quite understand, but it was more or less 1:1 what I had imagined.

So, I did what I had to do: I tried to understand the shell-script he wrote that creates the blog index and html files for the posts.
At this point, I did already have some experience with pandoc.
My school notes were located on a seperate subdomain and everything was written mostly in markdown, autoconverted to html and uploaded to the webserver which then displayed the individual files inside the directory as the index.
Very ugly, I know.
And not acceptable as a blog index obviously.

This is exactly the problem kageru solved [in his script](https://git.kageru.moe/kageru/mdb) though.
I had a few problems though:

1. He was doing everything inside a git repo. 

Which is also what I wanted to do when this is finished but it's not suitable for testing purposes. 
So I removed the check that it was only run when the git repo got updates.
And I did also remove other git-specific commands.

2. I wanted to pull title and date from the yaml-metadata block that pandoc-specific markdown supports.

This way I could write the title and date that would later be displayed in the index directly into the individual posts.
kagerus solution was pulling the title from the first `<h1>` that if found and the date via some git command I didn't understand.
(I am just getting started with version control and git, so I hope this is okay)

3. Also, I was too autistic to accept that every blog post would display the same title inside the tab-label in the browser. 

Additionally, I didn't like that `<h1>` was occupied as the main title when pandoc provies a perfect way to implement a title.

4. CSS. 

kageru is using his own special CSS that he built over the years when he was doing his blog differently.
I found a easy solution though: [Sakura CSS](https://github.com/oxalorg/sakura/) on github.
They also had some examples so I didn't have to mess around with npm packages or anything else that I wanted to avoid.

I downloaded a dark-mode themed example that was called `sakura-vader.css`, pointed pandoc to it when it was creating the webpages and voila:
I had a really nice and modern looking output.
It had to be a font with serifs though, so I changed the standard font to be serif, done!

<!--  end of list -->

The next step was to design everything around pandoc.
Via a bit of research I found out that pandoc actually takes multiple input files and puts them together in order just like `cat`.
This allowed me to split the index site up into four parts:

1. The header with the title of the site and a welcome message.

2. A index-table of blog-posts.

3. Something that comes after the index-table.

4. A footer that would be on every page.

<!--  end of list -->

A few changes to the overall document structure were required though, so that it would play nicely with web-standards and git, which I was planning to use to store the markdown files.

To finish it up, I added extra files for the 404-error-page and the 403-error-page and tied the security strings, so the `src/` directory wouldn't be available via the web-server.
Try them out! This is the [404](https://lucy.moe/öalskdjföalksdjfölkasjdöflaksjdf).
And this is is the [403](https://lucy.moe/src/)-error, that you get when you try to access the src directory.

I'm still going to reveal what is in `src/` though:
Subdirectories for posts, the static parts that make up the index and other static pages like [404.html](/404.html) and [403](/403.html).
In the futuree, I might add a contact page though.
Or something else, dunno.

For this to work I added a few lines that generate html pages in a similar way, but don't add to the index of blog-posts.

## Conclusion

Thank you, kageru, for this script!
You enabled me, someone who doesn't know a lot about shell scripting, to build uppon this excellent usecase of pandoc and extend it to fit my purposes.
And thank you in general. 
Because how you created your blog inspired me to also try this out and finally [get away from WordPress](https://asagi.moe/2020/07/06/wordpress-is-bloat/).

*By the way, you can find the sourecode [on his gitea](https://git.kageru.moe/Lux49/mdb).*
