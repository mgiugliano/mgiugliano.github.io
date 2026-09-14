---
title: Leaving Obsidian again
date: 2026-09-14
tags: productivity, markdown, notes
---

# Leaving Obsidian (Again)

I've recently switched from Obsidian to [Zen Notes](https://zennotes.org/), and along the way I ended up building something I didn't expect to build: my own self-hosted note-syncing stack, made of Syncthing and Tailscale. This post is about both things — why I moved, and what I built to make the move actually work.

This isn't the first time I've left Obsidian. About a year and a half ago I jumped to Apple Notes, mostly out of enthusiasm for its promise of a (forthcoming) tight integration with Siri and the Apple ecosystem. It did not go well.

Apple Notes at the time had no real markdown import, and it was simply unstable with the volume of notes and attachments I threw at it. The app crashed repeatedly. I even paid for a third-party conversion utility to get my Obsidian vault into Apple Notes, and it was, frankly, not worth it. In the end I wrote my own tooling on top of AppleScript and Shortcuts to try to patch things up. It was still a disaster: attachments got duplicated across notes, and the vault ended up in a genuinely messy state.

I only partially put a remedy to it afterward, using a local AI agent (the Pi agent, talking to a local model through an OpenAI-style API, running on OMLX as the inference engine) to help detect duplicates and clean things up via Python scripts working directly on the raw files. I wouldn't call the vault "solved," but at least it stopped being actively broken.

Fed up, I went back to Obsidian. And that's where things stood until Zen Notes appeared.

## Why Zen Notes

Zen Notes is open source, and its developer is extraordinarily prolific. New features and updates are shipping at real velocity, even though the project is only a few months into its first releases. It's built on Electron, and the author credits AI-assisted development for letting a small, very young project already feel reasonably versatile and stable across platforms.

The bigger draw for me, though, is that it's keyboard-first, with Vim motions built in. I've used Vim (well, technically Vi first) for many decades and switched to Neovim last year, so a fair chunk of those motions already live in muscle memory. Zen Notes also has direct MCP integration and a dedicated command-line companion, letting AI agents like Claude Code operate on the vault directly, something Obsidian, being older than the current wave of AI-assisted tooling, was never built around. No plugin system exists yet for Zen Notes, and there's no community around it yet either, which is a real limitation for something still this new. But the openness and the clean-slate pace of development make up for a lot.

It stores notes as plain markdown files on disk, just like Obsidian, and can even point at an existing Obsidian-style vault. That plain-file compatibility mattered a lot to what came next.

## My actual problem: iCloud sync

The core issue: iCloud sync, unlike Dropbox, isn't instantaneous. My iPhone or iPad would routinely lag behind changes made elsewhere, sometimes by a long while. Part of this is how iCloud works, and part of it is iOS and iPadOS not always triggering sync workflows immediately on file changes. I even tried the flag that keeps an iCloud folder resident on-device rather than fetched on demand. It didn't reliably stay in sync either. At some point I stopped experimenting and just accepted that, for syncing specifically, iCloud isn't the right tool, even within Apple's own ecosystem.

## Local-first alternative

Instead of paying for a sync service, I built my own, using two free, open-source tools: **Syncthing** and **Tailscale**.

**Syncthing** is a standard, cross-platform, peer-to-peer file synchronization protocol. On my Mac mini and my laptop, it runs as a background service installed via Homebrew — smooth to install, a little less smooth to configure the first time, since pairing two devices means manually exchanging unique device IDs (self-discovery kicks in after that, but the first pairing is inherently manual, and not something you can script into a dotfiles setup). Once devices are paired and awake, propagation is genuinely fast: the OS notifies the Syncthing service the moment a file changes, so sync latency between already-synced machines is a matter of seconds, not the vague, unpredictable delay I was getting from iCloud.

On iOS and iPadOS, the client is a separate app called **Synctrain** (originally released on GitHub as "Sushitrain," a pun on the sushi conveyor belt). Because iOS restricts background execution, Synctrain has to be manually opened to actually trigger a sync, a real limitation, but a predictable and honest one, unlike iCloud's opaque scheduling.

Both Syncthing and Synctrain are fully GUI-driven, through a web browser or native interface and no command line required anywhere in this stack.

One nice bonus: Syncthing's versioning runs on every device, each with its own dedicated subfolder holding old and deleted versions of files, rather than the conflicted-copy mess you sometimes get with naive sync tools. You can configure retention and keep old versions for 30 days, 60, a year, whatever suits you.

**Setting it up: Staggered File Versioning**

```
# 1. Access Folder Settings:
#    In the Syncthing Web UI, click on the served folder and select 'Edit'.
# 2. Enable Versioning:
#    Navigate to the 'Versioning' tab.
# 3. Choose Staggered File Versioning:
#    Select 'Staggered File Versioning' from the dropdown menu.
# 4. Set Retention Policy:
#    Configure the versioning parameters. For a robust safety net, 
#    set the maximum number of file copies to 5 and a maximum age of 60 days.
# 5. Save Changes:
#    This ensures that accidental deletions or corruptions can be easily 
#    recovered without relying on external version control systems like GitHub.
```

Staggered versioning keeps more copies of recent changes and fewer of older ones, which is a sensible default for a notes vault — you're far more likely to want to recover something from yesterday than from six months ago.

## Combo with Tailscale

The piece that makes the whole thing work without exposing anything to the open internet is **Tailscale**. Your public IP address isn't a fixed, reliable way for two devices to find each other, it changes depending on your network, and increasingly it's a bad idea to advertise it even when it doesn't. Think of IP addresses as phone numbers: if a device's number keeps changing, nobody else can reliably call it.

Tailscale runs a lightweight client in the background on every device you own and creates a private mesh network with static internal addresses that only your own devices can see. Functionally it's a VPN, well-supported on iOS and iPadOS, and it makes every device behave as if it's on the same home network, regardless of whether it's actually on Wi-Fi, mobile data, or fiber halfway across the country. That's what lets Syncthing reliably find and reach every device.

Setup-wise, Tailscale is genuinely easier than Syncthing, install one piece of software per device and you're mostly done, no manual ID exchange required. It's also free for personal use: the free Personal plan currently covers up to six users, and device limits have actually been removed entirely on every plan, so this isn't a setup you'll outgrow.

The full architecture, then: Tailscale linking every device into one private network, and Syncthing (via Synctrain on mobile) replicating the vault across all of them, with Zen Notes simply pointed at the local, synced folder, no iCloud and no paid Obsidian Sync required.

Worth being clear that none of this strictly requires a dedicated machine running around the clock, Syncthing is peer-to-peer, so any two devices that are both online at the same time will sync directly with each other. I happen to keep a Mac mini on 24/7 at home, and it does make a real difference: with an always-on node in the mix, every change gets replicated and backed up essentially immediately, rather than waiting for two other devices to happen to be online together. It's a nice-to-have that makes the whole system feel more like a continuous backup, not a hard requirement to get it working at all.

## Setting it up, step by step

For anyone who wants to actually replicate this, here's the concrete sequence I followed. One reordering note: although I explained the concepts above Syncthing-first, Tailscale-second, in practice you want Tailscale running before you touch Syncthing, since the pairing step below uses each device's Tailscale IP address directly.

**Phase 1 — Tailscale first, on every device**

```
# 1. Download and install Tailscale on all devices (e.g., a desktop, laptop, iPhone, iPad).
# 2. Open the app and log in to authenticate each device to your private tailnet.
# 3. From your Tailscale dashboard, verify all devices are connected. 
#    Note the desktop's specific Tailscale IP address (e.g., 100.x.y.z).
```

This is the easy part — no manual ID exchange, just install and log in on each device, and you can already see them all listed on your tailnet.

**Phase 2 — Install Syncthing on the desktop machines**

```bash
# Install the Syncthing daemon and set it to automatically start in the background.
brew install syncthing
brew services start syncthing
```

This is the part that was smooth for me on both the Mac mini and the laptop — Homebrew handles the install and the background service in two lines.

**Phase 3 — Pair devices through the web GUI**

```
# 1. Open a browser and navigate to the Syncthing Web UI.
http://127.0.0.1:8384

# 2. Go to Actions > Show ID to retrieve your unique Device ID.

# 3. Add your remote peers:
#    - In the Web UI of your laptop, click 'Add Remote Device'.
#    - Paste the desktop's Device ID.
#    - Go to the 'Advanced' tab and replace 'dynamic' in the Addresses field 
#      with the desktop's Tailscale IP: tcp://100.x.y.z:22000.
#    - Save and repeat this process in reverse on the desktop.
```

This is the fiddly, manual step I mentioned earlier — pointing Syncthing at the Tailscale IP directly, rather than leaving address discovery dynamic, is what makes the pairing reliable over the tailnet.

**Phase 4 — Configure the shared vault folder**

```bash
# 1. On the desktop, click 'Add Folder' to serve your ZenNotes directory.
# 2. Define the folder properties:
#    - Folder Label: A friendly display name (e.g., "ZenNotes Archive").
#    - Folder ID: A unique identifier (e.g., "zen-notes-sync") that matches on all devices.
#    - Folder Path: The absolute path to your ZenNotes folder (e.g., ~/ZenNotes).
# 3. Authorize peers by checking the boxes for your laptop and iOS devices in the 'Sharing' tab.
# 4. Accept the shared folder on your laptop when the prompt appears in its Web UI.
```

The Folder ID has to match exactly across every device sharing it — that's the one detail that trips people up here.

**Phase 5 — Bring iOS devices in via Synctrain**

```bash
# 1. Install and open the Synctrain app on your iOS device while connected to Tailscale.
# 2. Add the desktop as a remote device within the app by entering its Device ID and Tailscale IP.
# 3. Accept the incoming folder share. Synctrain will interface securely with your desktop.
```

Same principle as the desktop pairing, just through Synctrain's interface and remember, as noted above, that getting Synctrain to actually sync may mean opening the app in the foreground rather than trusting it to run in the background.


## A note on conflicts, and a real caveat about iOS

One reason this setup works comfortably for me is that it's a single-user vault: I'm never editing the same notes simultaneously from two devices, since it's just me moving between a laptop, an iPad, and an iPhone at different times rather than several people working at once. That doesn't rule out a genuine sync conflict, but it makes one unlikely. If a phone or iPad running Synctrain has been left un-synced for a day, or across a trip, and only catches up afterward, the odds of picking up and editing an outdated version of a note before the sync completes are minimal, you're the only one changing things, and you're not touching two devices at the same instant.

I do want to flag a real uncertainty here rather than paper over it, though: because of how restrictive iOS and iPadOS are about background execution, I'm not convinced Synctrain reliably syncs while sitting in the background, even outside of any power-saving mode. In my own experience, it's felt like the app needs to actually be in the foreground for a sync to start, but I'm not fully certain of that, and it's the kind of thing that really needs more deliberate testing rather than my own casual impression.


**Troubleshooting: getting iOS syncing to actually happen**

```
# 1. iOS Background Suspension:
#    iOS aggressively suspends apps running in the background. Synctrain will pause synchronization until the app is brought to the foreground.

# 2. Foregrounding the App:
#    Manually opening Synctrain and keeping it active on screen is the most reliable way to initiate synchronization and ensure your iOS device connects to your other clients.

# 3. Tailscale Status:
#    Ensure the Tailscale VPN tunnel is active so that synchronization begins immediately when the app is opened.
```

So the practical workaround, at least for now, is simple: don't assume a background sync happened. Open Synctrain, leave it on screen for a moment, and confirm Tailscale is connected, that combination is what reliably gets a device caught up.


## Why not Dropbox?

It's a fair question, since Dropbox's desktop client does exactly this kind of continuous, local, background sync on a Mac or PC. But on iOS and iPadOS, Dropbox doesn't behave the same way: it integrates with the Files app to expose your files on demand, but it doesn't keep a true, continuously synchronized local copy on the device the way its desktop client does. That mobile gap is precisely why a tool built around a genuine background sync daemon, like Syncthing, ends up necessary if you actually want your vault current on a phone or tablet.


## Who this is actually for

I wouldn't call this a power-user-only setup, but it's also not a zero-configuration one. It's for people willing to tinker and comfortable installing a couple of pieces of background software and going through a slightly fiddly first-time pairing step, even if none of it requires touching a terminal.

There's also a philosophy underneath it: I'd rather send a small, direct monthly token of appreciation to the developers who build tools like Syncthing, Synctrain, and Tailscale than pay for a subscription sync service, where a large share of that money tends to go not to the developers, but to the cloud infrastructure providers underneath them.

It's more moving parts than just paying for a sync subscription, no question. But it's local-first, self-hosted in spirit, and it finally makes my notes feel like they actually belong to me across every device I own.

