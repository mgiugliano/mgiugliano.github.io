---
title: Interactive polls with Keynote
date: 2026-09-07
tags: polls, keynote, automation, learning, lectures
---

# My own live polling system for Keynote

For a while, I relied every now and then on Poll Everywhere to engage students during my university lectures. It was a great tool, but recently, their pricing policies changed. I did not realise it immediately and was surprised that my account stopped working. 

I wanted something truly minimal and frictionless. No student accounts. No IP logging. No tracking. Just a simple QR code on a projector screen that students could scan to instantly vote. And most importantly, I wanted it deeply integrated into my presentation software of choice: Apple Keynote. I know that many other services exist but I wondered whether a truly free, open source, and self-hosted solution was possible.

In fact, I quickly realized I didn't actually need a massive, database-heavy platform. So, with a bit of weekend coding (and major AI assistance!), I built **PollMe** from scratch and pushed it to [GitHub](https://github.com/mgiugliano/pollMe). 

# A menu-bar utility

Instead of dealing with clunky Keynote plugins or switching back and forth between presentation software and a web browser, Gemini suggested to build a tiny macOS app that sits quietly in my menu bar. It talks directly to Keynote, reading my Presenter Notes. If it sees a simple `[POLL]` tag in the notes, it instantly projects a beautiful, transparent live chart right over my slide. This overlay screen takes the content of a webpage I host on my own website.
As soon as exit the full-screen mode of Keynote or move on with the presentation, the app senses that the current slide is no longer projected and silently closes the overlay screen. I wonder whether it will still work fine with OBS and videorecording/teleconferencing... 

The backend is equally simple: a single PHP script with zero database requirements. It is hosted on the same website and just writes votes to a tiny local file, meaning I can host it on the most basic university web host imaginable. I do not need any shell access, or database installation. Just serving web pages.

# Live polls and real-time results

This small hack currently handles multiple-choice questions, donut charts, and live word clouds, and it promises to be very convenient for my lectures. 
I don't have to worry about subscriptions anymore, and the students may love how fast it is. I've open-sourced the whole thing here, hoping it might save another educator a bit of time and money!

