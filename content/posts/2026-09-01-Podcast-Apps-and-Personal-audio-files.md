---
title: Podcast Apps and Personal Audio Files
date: 2026-09-01
tags: podcast, coding, lifestyle, macos, automation
---

# Importing audio files into a Podcast app
I spend a lot of time commuting—walking or driving. While I do love my usual news and topic feeds, I often find myself wanting to listen to my own thoughts. Whether it's voice notes I've recorded or synthetic podcasts generated from articles via NotebookLM, I need a way to brainstorm and process information when I can't be staring at a screen.

For a long time, I used an app called [Downcast](https://en.wikipedia.org/wiki/Downcast_(app)), which made importing local MP3s simple. On any iOS devices I could simply "Open in..." and Downcast would add it into its local storage and show it as an episode. One could then add that file to a given podcast.

# Overcast App
Recently, I switched to [Overcast](https://en.wikipedia.org/wiki/Overcast_(app)). It's a fantastic piece of software by an independent developer, Marco Arment, who truly deserves support. However, I quickly realized that the ability to easily upload and sync custom audio files is a "Plus" feature, requiring a subscription.

While the subscription is tempting, it got me thinking about the resources I already have. I already pay for a web hosting service (for my blog, publications, and lab websites). It's a significant annual expense, so I wanted to maximize its utility. In the "cloud" I do have disk space, and although I don't have SSH access, I have FTP.

So, I "vibe-coded" (with Claude Sonnet 5) a simple utility to solve this. 

# How it works
I have a simple script running on my Mac that monitors a specific local folder (which could easily be a Dropbox subfolder) every five minutes. When a new audio file appears, the script does two things:
1. It uploads the file to my web server via FTP.
2. It updates the XML file in the same web server location, which emulates a standard podcast RSS feed.

By doing this, I've essentially created my own private podcast. I simply subscribe to this personal RSS feed in (any) podcast app, and whenever I drop a new file into that folder on my computer (or in any other device sharing that Dropbox folder), it automatically syncs and appears as a new "episode" on my phone.

I thought this might be useful for others who have their own web hosting or otherwise some sort of network storage and a web server with a public IP. You can host these files on a secret or even password-protected domain to keep your voice notes private while enjoying the seamless experience of a professional podcast app.

If you'd like to set this up for yourself, you can find the code [here](https://github.com/mgiugliano/PodcastUploader).

