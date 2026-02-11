# Personal Website

A minimalistic, self-contained personal website system powered by Pandoc, featuring a large prominent search bar and automatic GitHub Pages deployment.

## Features

- 🎨 **Minimalistic Design**: Clean, distraction-free interface with generous white space
- 🔍 **Powerful Search**: Large, prominent search bar powered by Lunr.js
- 📝 **Markdown-Based**: Write content in simple Markdown format
- 🚀 **Auto-Deploy**: Push to GitHub, automatic build and deployment
- 📱 **Responsive**: Beautiful on all devices
- ⚡ **Fast**: Static site generation for optimal performance
- 🔒 **Privacy-Focused**: Client-side search, no tracking

## Quick Start

### Adding a New Blog Post

1. Create a new file in `content/posts/` with the format: `YYYY-MM-DD-title.md`
2. Add YAML front matter:
   ```yaml
   ---
   title: Your Post Title
   date: 2026-02-11
   tags: tag1, tag2
   ---
   ```
3. Write your content in Markdown below the front matter
4. Commit and push to GitHub - the site rebuilds automatically!

**Example**: Create `content/posts/2026-02-11-my-first-post.md`:

```markdown
---
title: My First Blog Post
date: 2026-02-11
tags: personal, introduction
---

# My First Blog Post

This is my first post on my new website!

## Why I Started This Blog

I wanted a simple, clean platform to share my thoughts...
```

### Adding a New Page

1. Create a new file in `content/pages/` (e.g., `contact.md`)
2. Add YAML front matter with at least a title:
   ```yaml
   ---
   title: Contact
   ---
   ```
3. Write your content in Markdown
4. The page will be accessible at `/content/pages/contact.html`
5. Add it to navigation by editing `templates/default.html` (optional)

### Editing Existing Content

1. Navigate to the file on GitHub
2. Click the edit button (pencil icon)
3. Make your changes
4. Commit directly to the main branch
5. Your site rebuilds automatically within a few minutes

## Site Structure

```
.
├── content/
│   ├── posts/          # Blog posts (YYYY-MM-DD-title.md)
│   └── pages/          # Static pages (any-name.md)
├── templates/
│   └── default.html    # Pandoc HTML template
├── static/
│   ├── css/
│   │   └── style.css   # Site styling
│   └── js/
│       └── search.js   # Search functionality
├── docs/               # Generated site (do not edit directly)
├── index.md            # Homepage
├── build.sh            # Build script
└── .github/
    └── workflows/
        └── deploy.yml  # GitHub Actions workflow
```

## Local Development

### Prerequisites

- [Pandoc](https://pandoc.org/installing.html) (3.0+)
- Python 3.x
- Bash

### Building Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/mgiugliano/mgiugliano.github.io.git
   cd mgiugliano.github.io
   ```

2. Run the build script:
   ```bash
   ./build.sh
   ```

3. Serve locally:
   ```bash
   cd docs
   python3 -m http.server 8000
   ```

4. Open http://localhost:8000 in your browser

## Customization

### Changing the Site Title and Branding

Edit `templates/default.html`:

```html
<div class="logo">
  <a href="/index.html">Your Name Here</a>
</div>
```

And the title tag:

```html
<title>$if(title)$$title$ - $endif$Your Website Name</title>
```

### Modifying Navigation Links

Edit the navigation section in `templates/default.html`:

```html
<ul class="nav-links">
  <li><a href="/index.html">Home</a></li>
  <li><a href="/content/pages/about.html">About</a></li>
  <li><a href="/blog.html">Blog</a></li>
  <li><a href="/content/pages/contact.html">Contact</a></li> <!-- Add new links -->
</ul>
```

### Customizing Styles

Edit `static/css/style.css` to change:

- Colors and fonts
- Layout and spacing
- Search bar appearance
- Responsive breakpoints

### Modifying the Footer

Edit the footer section in `templates/default.html`:

```html
<footer>
  <div class="container">
    <p>&copy; 2026 Your Name. Built with Pandoc and ❤️</p>
  </div>
</footer>
```

## Search Functionality

### How It Works

1. During build, `build.sh` generates `docs/search-index.json`
2. This file contains all page titles, content excerpts, and tags
3. `search.js` loads the index and uses Lunr.js for full-text search
4. Results appear instantly as you type (minimum 2 characters)
5. Everything runs client-side - no server queries needed

### Search Tips for Users

- Type at least 2 characters to activate search
- Results are ranked by relevance (titles > tags > content)
- Click any result to navigate to that page
- Press Escape to close results
- Click outside the search area to close results

## Deployment

### GitHub Pages Setup (First Time)

1. Go to your repository Settings
2. Navigate to "Pages" section
3. Under "Build and deployment":
   - Source: GitHub Actions
4. The workflow will run automatically on every push to main

### Manual Deployment Trigger

You can manually trigger a deployment:

1. Go to the "Actions" tab in your repository
2. Select "Deploy to GitHub Pages" workflow
3. Click "Run workflow"

## Writing in Markdown

### YAML Front Matter

Always include front matter at the top of your files:

```yaml
---
title: Page Title (required)
date: 2026-02-11 (for blog posts)
tags: tag1, tag2 (optional)
---
```

### Markdown Syntax

Common Markdown elements:

```markdown
# Heading 1
## Heading 2
### Heading 3

**bold text**
*italic text*

[link text](https://example.com)

- Bullet point 1
- Bullet point 2

1. Numbered item 1
2. Numbered item 2

`inline code`

\`\`\`
code block
\`\`\`

> Blockquote
```

## Troubleshooting

### Site not updating after push

1. Check the Actions tab for build errors
2. Ensure the workflow completed successfully
3. Wait a few minutes for GitHub Pages to update
4. Clear your browser cache

### Search not working

1. Ensure `docs/search-index.json` exists
2. Check browser console for JavaScript errors
3. Verify Lunr.js is loading (check network tab)

### Build fails locally

1. Verify Pandoc is installed: `pandoc --version`
2. Verify Python is installed: `python3 --version`
3. Ensure build.sh is executable: `chmod +x build.sh`

## Contributing

This is a personal website, but if you find issues or have suggestions:

1. Open an issue describing the problem or suggestion
2. Fork the repository and make your changes
3. Submit a pull request

## License

This website system is provided as-is for personal use. Feel free to adapt it for your own needs.

## Credits

Built with:

- [Pandoc](https://pandoc.org/) - Universal document converter
- [Lunr.js](https://lunrjs.com/) - Client-side search
- [GitHub Pages](https://pages.github.com/) - Free hosting
- [GitHub Actions](https://github.com/features/actions) - CI/CD automation
