---
title: How to Use the Search Feature
date: 2026-08-27
tags: tutorial, search, features
---

# (Not so) friendly dogs walking around 

I finally took a few days off in Liguria with my dog, Daisy. When she is with me, she turns into a tiny shark: she goes after anything that breathes nearby, growling, jumping, promising to dismember dogs and people alike. With my wife instead, perhaps unsurprisingly, she's a lamb and she is loved and recognized with a smile by anyone in this neighborhood. More than once people asked us: do you actually own twin dogs? From this, I suppose, the verdict at home is clear, in terms of who is in charge.

Now, the building across the street has another dog, same opinionated attitude against the world, same walking hours. The other dog dislikes me and my dog. That guarantees close encounters and out-of-control barking dogs on a daily basis. A couple of days ago, my neighbor told me the whole thing stresses her out enormously. Her proposed solution: swap numbers and text each other our locations in real time every time either of us goes for a walk. We ended up coordinating our walks like a military operation.


![ScreenShot](https://github.com/mgiugliano/DogWalkBoard/blob/main/docs/screenshots/control.jpg?raw=true)

# A web app, instead of back and forth messaging 

And yet this neighborhood is not well known by me: it is small but maze-like, with wooded paths and zero useful landmarks. Coordinating via WhatsApp turned out to be immediately hopeless for me: "heading to the meadow. Which meadow? I'm by the broken tree. The one near the bins or the tennis court?" There must have been some alternative. With some help from Claude, I put together a small web-app that shows both dogs' positions in real time on a street map. The rules: whoever stays more than 50 meters from the other for the entire walk wins.

Built with OpenStreetMap tiles and one's phone browser's geolocation API, the whole thing came together in an afternoon. It's called [Dog Walk Board](https://github.com/mgiugliano/DogWalkBoard), open source (MIT licensed), and it does exactly one thing: shows you where two (or more) dogs are in space at any given time, provided each turns on a "walk state on" switch in their own "settings page". No WhatsApp messages, no military coordinates, no "where the hell are you?". We both navigate to the web page, switch on our "walk state" and "GPS on" switch, and can easily avoid each other visually as in a videogame, should they other party be already outdoor or go for a walk while we are already out. 

It's free, requires no database, and uses only php. Have a look at it and install it on your favorite web hosting service (running PHP and serving pages). The one catch: keep your screen on and do not navigate away from that page. Indeed, the browser has to stay active to broadcast your location. Lock your phone and your dot goes "frozen" on everyone else's map and starts blinking. The app handles this gracefully: the other parties receive an audio alert and know pretty soon you are still on a walk but perhaps you are checking email or browsing through your playlist. Fair warning: your battery will notice.


Of course it also works the other way, in case of friendly dogs aiming at each others: use it to quickly find your dog-walking friends in the neighborhood and join for the night walk and let the dogs sniff together happily.


## Privacy and security

Since the current GPS coordinates must be shared and relayed to the others, during operation, the server temporarily stores those coordinates.
There is no security or authorisation mechanism: an offline bash script is run to configure the system and then one deploys all the files to a server. Anybody knowing the URL could impersonate each other or "see" the GPS  coordinates of all parties. 


Enjoy sharks walking!

