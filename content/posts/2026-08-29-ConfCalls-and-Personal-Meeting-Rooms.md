---
title: Conf-calls and Personal Meeting Rooms
date: 2026-08-29
tags: web, snippet, work, lifestyle, hacks
thumbnail: /static/images/2026-08-29-ConfCalls-and-Personal-Meeting-Rooms-thumb.png
---
<!-- Thumbnail credit: "Google Meet icon (2020).svg" via https://commons.wikimedia.org/wiki/File:Google_Meet_icon_(2020).svg (Public domain, by Google) -->
# Conf-calls static link: How to?

With the convenience of "text-expanders" (e.g. [espanso](https://espanso.org), [TextExpander](https://textexpander.com), etc.), I have always felt the need to rapidly communicate (in an email, instant messaging, or a calendar invite) the hyperlink to join a conference call that I was organizing.

I dislike immensely the style of Microsoft Teams or even Google Meets, as one needs to first *schedule* a meeting, entering date and time, before getting the link to share.

Long are gone the times when Skype was popular and in practice running the web, vis-a-vis instant communications and VoIP.

[[ rewrite the previous paragraph in a concise pop-science manner ]]


## Zoom’s Personal Meeting Rooms

In my previous institutions, Zoom subscriptions for all was provided to all faculty members and I have to admit it was a blessing. I did particularly love the concept of a *Personal Meeting Room*: every user has a dedicated url link that is permanent and never changing. One can then note that link down, share it, email it, write it over and over, e.g. upfront on email signatures, on recurring calendar shared events, in online appointment booking systems (like [Calendly](https://www.giugliano.info/cv/blog/quick-confcall-link/calendly.com](https://calendly.com) or the built-in appointment schedule of [Google Calendar](https://workspace.google.com/resources/appointment-scheduling/)), etc.

With those text expanders, I became so quick to organize a conf-call (e.g. via Slack, Whatsapp, Teams, email, SMS, etc.), responding to a request for "a link to join". Admittedly, the concept of a Personal Meeting Room with a static url may not be always desirable or completely safe, but so far I rarely experience people joining too early to my room and never witnessed a *Zoom bombing*.

[[ rewrite the previous paragraph in a concise pop-science manner ]]


## Static link to a Google Meet?

Google Meet does NOT offer the exact same feature out of the box. When creating a new meeting, the user must first navigate to [meet.google.com](https://meet.google.com/), press the button *New Meeting*, and then select the desired option from the drop down menu, before finally getting a link to share, note down, email, etc.

I found a simple workaround: create once for all a daily (recurring) event on any Google Calendar. To do so, simply navigate to [calendar.google.com](https://calendar.google.com/) and then press the plus *+* button. Create a "new Event" and choose
```
- *Personal Meeting Room*, as title
   - 06:00 - 06:15am, as the event time 
   - daily repeating
   - disable notification
   - show as *Free* time
   - visibility as *Private*
   - **Add Google Meet video conferencing**
```
At that point a new link is generated. This link is precious and it should be saved somewhere safe. Note that I have chosen a presumed scheduled time of the day that is not intruding with my real daily schedule, so it does not visually overlap with other tasks or entries on my calendar. I also opted out from any "notification". Finally, click on the settings of the Google Meet and configure the meeting as you want. I have specifically decided to set
```
   - *Host Management* on
   - *Host must join before anyone else*
   - Meeting Access type: *Trusted* (people must ask to join)
```
although most of these settings can be changed from within the meeting itself. In this way, Google Meet will behave as a Zoom’s Personal Meeting Room default settings!

**Note:** There is a small catch: a recurring event has an upper limit to the time it can be repeating (i.e., a life-time of the link): 730 occurrences. For a daily repeating link (honestly I never tried to set it to any different recurrence), every two years the link will stop working and a new recurring events must be created from scratch. If you find a trick to go around this limitation, let me know.

Then, I configured my favorite text expander (i.e. espanso) so that:
```
  - trigger: ";zoom"
    replace: "https://blablabla.zoom.us/j/blablabla"
  - trigger: ";meet"
    replace: "https://meet.google.com/uhuhuhuhu"
```

I hope this might be of help.
