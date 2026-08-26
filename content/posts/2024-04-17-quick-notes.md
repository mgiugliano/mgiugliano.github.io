---
title: Quick notes
date: 2024-04-17
tags: productivity, macos
---

![Hammerspoon](/static/images/hammerspoon.jpeg)

## Personal Knowledge Management (PKM)

Over the last couple of years, I explored several apps for [PKM](https://en.wikipedia.org/wiki/Personal_knowledge_management). After getting more and more unhappy with Evernote and its proprietary format, I decided to stick to the minimalism of text file format and particularly of [Markdown](https://www.markdownguide.org). I played with [Roam Research](https://roamresearch.com), [LogSeq](https://logseq.com), but I fell in love with [Obsidian](https://obsidian.md).

I have been however searching for a very very fast way to jot down a though or recover a bit of information I previously noted down. I don't want to launch Obsidian every time and the create a new note or open an existing note. I wanted to have a superfast text editor to be spawn and presented on the screen.

## Hammerspoon and MacVim

As a macOs user and searching for tools for automation, increased productivity, windows management, and short-cuts manager, I use [Hammerspoon](https://www.hammerspoon.org) and found a super-fast way to spawn a text editor (i.e. in this case [MacVim](https://macvim.org)) for very rapidly note down information, to dos, snippets, etc. direclty appending to a note in my Obsidian notes vault:

```lua
hs.hotkey.bind(hyper, ",", function()
	local fileToOpen = "PATH/TO/OBSIDIAN/VAULT/NOTES/scratch.md"
	os.execute("/Applications/MacVim.app/Contents/bin/mvim " .. fileToOpen .. " &")
end)
```

## Configuring MacVim

I quickly found out that launching a terminal and then starting my favourite text editor, vim, took a few seconds. Using the GUI version of vim (i.e. MacVim), which may coexist with the standard vim on my system, allows a much much faster performance. This however requires to have an ad hoc `.gvimrc` configuration file:

```vim
if has('gui_running')
    " Put all your MacVim-specific settings here

    set spelllang=en_us,it
    set guifont=Monaco:h18
    set columns=140

    autocmd BufRead * execute "normal G2o"
    autocmd BufRead * execute ":r!echo -------"
    autocmd BufRead * execute ":r!date"
    autocmd BufRead * execute "normal G2o"
    autocmd BufRead * execute ":startinsert"
endif
```

## The final results

As I press my (Hammerspoon) *hyperkey* + comma, within less than a second MacVim appears and instantly opens scratch.md. MacVim is then ready, in insert mode by default at the end of the file, after appending the current date and time.

Such a scratch note is then used as a quick piece of paper, I no longer riks to loose.

I hope this might be of help.
