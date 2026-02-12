---
title: Conf-calls static link
date: 2023-12-29
tags: web, snippet
---

# Conf-calls static link: How to?

## Zoom’s Personal Meeting Room

I love Zoom’s Personal Meeting Room: every user has a dedicated url link that is permanent and never changing. I can then use it, share it, email it, write it over and over, e.g. upfront on email signatures, on recurring calendar shared events, in online appointment booking systems (like [Calendly](https://www.giugliano.info/cv/blog/quick-confcall-link/calendly.com)), etc.

Skilled users may configure their OS’s default text substitution, or install an ad hoc text expander app (e.g. [espanso](https://espanso.org), [TextExpander](https://textexpander.com), etc.), and become lightening fast in sharing the link. Indeed, as soon as I type a certain combination of characters (i.e. ;zoom), a specific string is automatically replaced (e.g. ```https://blabla.zoom.us/j/blablabla```).

In this way, organising a quick conf-call through instant messaging (e.g. Slack, Whatsapp, Teams, etc.), responding to an email asking for the link of our scheduled meeting, booking an (online) event on my calendar became much faster than launching Zoom, creating a new meeting, copy-pasting the link generated, etc. Admittedly, the concept of a Personal Meeting Room may not be always desirable or completely safe, but so far I rarely created ad hoc events in Zoom.

## Static link to a Google Meet?

Google Meet does NOT offer the same feature out of the box. When creating a new meeting, the user must first navigate to [meet.google.com](https://meet.google.com/), press the button New Meeting, and then select the desired option from the drop down menu, before finally getting to the link to be shared, noted, saved, emailed, etc.

A simple workaround exists: create a daily (recurring) event on any Google Calendar. To do so, navigate to [calendar.google.com](https://calendar.google.com/) and then press the plus + button and create a new Event once for all. Then choose

```
- *Personal Meeting Room*, as title
   - 06:00 - 06:15am, as the event time 
   - daily repeating
   - disable notification
   - show as *Free* time
   - visibility as *Private*
   - **Add Google Meet video conferencing**
```

At that point a new link is generated. This link is precious and it should be saved somewhere safe. Note that I have chosen a time of the day that is not intruding with my real daily schedule. I also opted out from any notification. Finally, click on the settings of the Google Meet and configure the meeting as you want. I have chosen to set

```
   - *Host Management* on
   - *Host must join before anyone else*
   - Meeting Access type: *Trusted* (people must ask to join)
```

In this way, Google Meet will be like Zoom’s Personal Meeting Room default settings.

Note: The upper limit of a recurring even is 730 occurrences, so every two years the link will stop working. The procedure will have to be repeated. If you find a trick to go around this limitation, let me know.

I configured my favorite text expander (i.e. espanso) so that:

```
  - trigger: ";zoom"
    replace: "https://blablabla.zoom.us/j/blablabla"
  - trigger: ";meet"
    replace: "https://meet.google.com/uhuhuhuhu"
```

I hope this might be of help.
