---
title: About
---

# About This Website

This is a minimalistic, self-contained personal website system built with simplicity and functionality in mind.

## The Philosophy

The goal of this website is to provide:

- **Simplicity**: Clean, distraction-free reading experience
- **Speed**: Fast-loading static pages
- **Searchability**: Powerful search to find content instantly
- **Maintainability**: Easy to update and manage

## How It Works

### Technology Stack

- **Pandoc**: Converts Markdown files to beautiful HTML
- **Lunr.js**: Provides fast, client-side search functionality
- **GitHub Pages**: Hosts the static site for free
- **GitHub Actions**: Automatically builds and deploys on every push

### Architecture

The site is built from:

1. **Markdown Content**: All posts and pages are written in simple Markdown
2. **Pandoc Templates**: HTML templates define the site structure and styling
3. **Build Script**: Bash script that converts Markdown to HTML and generates search index
4. **Static Assets**: CSS and JavaScript for styling and interactivity

### Workflow

1. Edit Markdown files directly on GitHub
2. Push changes to the main branch
3. GitHub Actions automatically builds the site
4. Updated site is deployed to GitHub Pages

No local development environment needed - though you can run it locally if you prefer!

## Features

### Large, Prominent Search

The search bar is designed to be highly visible and easy to use:

- Appears at the top of every page
- Provides instant results as you type
- Searches across all content (posts, pages, tags)
- Privacy-focused (runs entirely in your browser)

### Blog Posts

Blog posts are stored in `content/posts/` with date-based naming:

- Format: `YYYY-MM-DD-title.md`
- Supports YAML front matter for metadata
- Automatically listed on the blog page
- Fully searchable

### Static Pages

Create any number of static pages in `content/pages/`:

- Custom URLs based on filename
- Same Markdown format as blog posts
- Can be linked in navigation

### Responsive Design

The site looks great on all devices:

- Mobile-friendly layout
- Readable typography
- Touch-friendly interface

## Open Source

This website system is built to be:

- Self-contained
- Easy to understand
- Simple to modify
- Free to use

Feel free to explore the code and adapt it for your own use!
