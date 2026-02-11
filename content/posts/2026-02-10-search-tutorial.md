---
title: How to Use the Search Feature
date: 2026-02-10
tags: tutorial, search, features
---

# How to Use the Search Feature

The search functionality is one of the most powerful features of this website. Let me show you how to make the most of it.

## Getting Started with Search

The **large search bar** is prominently displayed at the top of every page. You can't miss it! Here's how to use it effectively:

### Basic Search

Simply type your search query into the search bar. As you type, results will appear instantly below the search box.

- **Minimum 2 characters**: The search activates after you type at least 2 characters
- **Real-time results**: Results update as you type
- **Click to navigate**: Click any result to navigate to that page

### What Gets Searched?

The search functionality indexes:

1. **Titles**: Post and page titles (highest priority)
2. **Content**: The actual text content of posts and pages
3. **Tags**: Any tags associated with posts (high priority)

### Search Tips

- **Be specific**: More specific queries return better results
- **Use keywords**: Think about the key terms in what you're looking for
- **Try different terms**: If you don't find what you want, try synonyms or related terms

### Keyboard Shortcuts

- **Escape**: Close the search results dropdown
- **Click outside**: The results close automatically when you click elsewhere

## Technical Details

For the technically curious, here's how it works:

- **Lunr.js**: A lightweight, client-side search library
- **JSON Index**: All content is indexed in a single JSON file at build time
- **Instant Search**: No server queries needed - everything runs in your browser
- **Lightweight**: The entire search index is typically just a few KB

## Privacy

Since search runs entirely in your browser:

- No search queries are sent to any server
- No tracking of what you search for
- Complete privacy

Enjoy searching!
