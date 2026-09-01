#!/bin/bash

# Build script for personal website
# Converts Markdown to HTML using Pandoc and generates search index

set -e

TEMPLATE="templates/default.html"
FINAL_OUTPUT_DIR="docs"
# Build into a scratch directory outside any synced folder (e.g. Dropbox) first,
# then publish atomically at the end. Building directly into $FINAL_OUTPUT_DIR
# with repeated rm-rf + rapid rewrites races Dropbox's own sync and can leave
# "conflicted copy" files / stale content behind under the real filenames.
OUTPUT_DIR=$(mktemp -d)
export OUTPUT_DIR
CONTENT_DIR="content"
STATIC_DIR="static"
# Generate timestamp for cache busting
BUILD_TIMESTAMP=$(date +%s)
# Current year, for the footer copyright line
COPYRIGHT_YEAR=$(date +%Y)

echo "🚀 Building personal website..."

# Clean scratch output directory
echo "🧹 Preparing scratch build directory ($OUTPUT_DIR)..."
mkdir -p "$OUTPUT_DIR/content/posts" "$OUTPUT_DIR/content/pages"

# Copy static files
echo "📦 Copying static files..."
cp -r "$STATIC_DIR" "$OUTPUT_DIR/"

# Create .nojekyll file to prevent Jekyll processing
echo "🔧 Creating .nojekyll file..."
touch "$OUTPUT_DIR/.nojekyll"

# Function to convert markdown to HTML
convert_md_to_html() {
  local input_file="$1"
  local output_file="$2"
  local root_path="${3:-.}"
  local is_post="${4:-}"
  local tags_html="${5:-}"

  echo "  Converting: $input_file -> $output_file"

  local extra_args=()
  if [ -n "$is_post" ]; then
    extra_args+=(--variable="is_post:true")
  fi
  if [ -n "$tags_html" ]; then
    extra_args+=(--variable="tags_html:$tags_html")
  fi
  # Only load jQuery + bigfoot.js on posts that actually use footnotes —
  # same "pay only for what you use" pattern as MathJax.
  if grep -qE '\[\^[^]]+\]' "$input_file" 2>/dev/null; then
    extra_args+=(--variable="has_footnotes:true")
  fi
  local credit_html
  credit_html="$(thumbnail_credit_html_for "$input_file")"
  if [ -n "$credit_html" ]; then
    extra_args+=(--variable="thumbnail_credit_html:$credit_html")
  fi

  pandoc "$input_file" \
    --template="$TEMPLATE" \
    --standalone \
    --to=html5 \
    --mathjax \
    --variable="cache_bust:$BUILD_TIMESTAMP" \
    --variable="copyright_year:$COPYRIGHT_YEAR" \
    --variable="root:$root_path" \
    "${extra_args[@]}" \
    -o "$output_file"
}

# Render a post's `tags:` front matter as <span class="tag-pill"> markup,
# wrapped in a container div. Empty output if the post has no tags.
tags_html_for() {
  python3 - "$1" << 'PYEOF'
import re, html, sys
with open(sys.argv[1], encoding='utf-8') as f:
    content = f.read()
m = re.search(r'(?m)^tags:\s*(.*)$', content)
tags = [t.strip() for t in (m.group(1) if m else '').split(',') if t.strip()]
if tags:
    spans = ''.join(f'<span class="tag-pill">{html.escape(t)}</span>' for t in tags)
    print(f'<div class="post-tags">{spans}</div>', end='')
PYEOF
}

# Render the visible credit line for a fetched thumbnail (blog thumbnail
# writes an HTML comment with this info right after the front matter; this
# turns it into small, muted, on-page text). Empty output if the post has
# no such comment (no thumbnail, or a hand-picked one with no fetch record).
thumbnail_credit_html_for() {
  python3 - "$1" << 'PYEOF'
import re, html, sys
with open(sys.argv[1], encoding='utf-8') as f:
    content = f.read()

title = page_url = license_ = artist = None

m = re.search(
    r'<!--\s*Thumbnail credit:\s*"(.*?)"\s*via\s*(\S+)\s*\(([^,)]+)(?:,\s*by\s*(.*?))?\)\s*-->',
    content,
)
if m:
    title, page_url, license_, artist = m.groups()
else:
    # Older format, written before blog thumbnail also recorded a title.
    m = re.search(
        r'<!--\s*Thumbnail source:\s*(\S+)\s*\(([^,)]+)(?:,\s*by\s*(.*?))?\)\s*-->',
        content,
    )
    if m:
        page_url, license_, artist = m.groups()

if page_url:
    by = f', by {html.escape(artist)}' if artist else ''
    lead = f'Thumbnail: &ldquo;{html.escape(title)}&rdquo; via' if title else 'Thumbnail via'
    print(
        f'<p class="thumbnail-credit">{lead} '
        f'<a href="{html.escape(page_url)}">Wikimedia Commons</a> '
        f'&mdash; {html.escape(license_)}{by}</p>',
        end='',
    )
PYEOF
}

# Convert index page (with blog entries injected)
if [ -f "index.md" ]; then
  echo "📄 Converting index page..."
  
  # Generate blog entries markdown for inline inclusion
  BLOG_ENTRIES=""
  if [ -d "$CONTENT_DIR/posts" ]; then
    for post in $(ls -r "$CONTENT_DIR/posts"/*.md 2>/dev/null); do
      if [ -f "$post" ]; then
        filename=$(basename "$post" .md)
        title=$(grep "^title:" "$post" | head -1 | sed 's/title: *//; s/"//g' || echo "$filename")
        date=$(grep "^date:" "$post" | head -1 | sed 's/date: *//; s/"//g' || echo "$filename" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' || echo "")
        BLOG_ENTRIES="${BLOG_ENTRIES}## [$title](content/posts/$filename.html)"$'\n'
        if [ -n "$date" ]; then
          BLOG_ENTRIES="${BLOG_ENTRIES}*$date*"$'\n'
        fi
        BLOG_ENTRIES="${BLOG_ENTRIES}"$'\n'
      fi
    done
  fi

  # Create a temporary copy of index.md with blog entries injected
  cp index.md /tmp/index-with-blogs.md
  # Replace the placeholder with actual blog entries
  if [ -n "$BLOG_ENTRIES" ]; then
    # Write blog entries to a temp file and use sed to replace
    BLOG_SECTION="# Recent Posts"$'\n\n'"$BLOG_ENTRIES"
    printf '%s' "$BLOG_SECTION" > /tmp/blog-entries-fragment.md
    python3 -c "
import sys
with open('/tmp/index-with-blogs.md', 'r') as f:
    content = f.read()
with open('/tmp/blog-entries-fragment.md', 'r') as f:
    entries = f.read()
content = content.replace('<!-- BLOG_ENTRIES -->', entries)
with open('/tmp/index-with-blogs.md', 'w') as f:
    f.write(content)
"
  else
    # No blog entries, just remove the placeholder
    sed -i 's/<!-- BLOG_ENTRIES -->//' /tmp/index-with-blogs.md
  fi

  convert_md_to_html "/tmp/index-with-blogs.md" "$OUTPUT_DIR/home.html" "."
fi

# Generate root index.html as a redirect stub to blog.html
echo "↪️  Generating index.html redirect to blog.html..."
cat > "$OUTPUT_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="0; url=blog.html">
  <title>Redirecting to Blog...</title>
  <script>window.location.replace('blog.html');</script>
</head>
<body>
  <p>Redirecting to the <a href="blog.html">Blog</a>...</p>
</body>
</html>
EOF

# Convert blog posts
if [ -d "$CONTENT_DIR/posts" ]; then
  echo "📝 Converting blog posts..."
  for post in "$CONTENT_DIR/posts"/*.md; do
    if [ -f "$post" ]; then
      filename=$(basename "$post" .md)
      post_tags_html="$(tags_html_for "$post")"
      convert_md_to_html "$post" "$OUTPUT_DIR/content/posts/$filename.html" "../.." "true" "$post_tags_html"
    fi
  done
fi

# Convert pages
if [ -d "$CONTENT_DIR/pages" ]; then
  echo "📄 Converting pages..."
  for page in "$CONTENT_DIR/pages"/*.md; do
    if [ -f "$page" ]; then
      filename=$(basename "$page" .md)
      convert_md_to_html "$page" "$OUTPUT_DIR/content/pages/$filename.html" "../.."
    fi
  done
fi

# Generate activity map (posts per month/year) for the blog page
echo "📊 Generating activity map..."
python3 << 'PYTHON_SCRIPT'
import glob
import re
from datetime import date
from collections import defaultdict

MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
MONTH_INITIALS = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]

def extract_date(filepath, content):
    m = re.search(r'^date:\s*"?([0-9]{4}-[0-9]{2}-[0-9]{2})"?', content, re.MULTILINE)
    if m:
        return m.group(1)
    m = re.match(r'.*?([0-9]{4}-[0-9]{2}-[0-9]{2})', filepath)
    return m.group(1) if m else None

counts = defaultdict(int)
for filepath in glob.glob('content/posts/*.md'):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    d = extract_date(filepath, content)
    if not d:
        continue
    y, m, _ = d.split('-')
    counts[(int(y), int(m))] += 1

today = date.today()
years = [y for y, m in counts.keys()]
min_year = min(years) if years else today.year
max_year = max(max(years), today.year) if years else today.year

def level(n):
    if n <= 0:
        return 0
    if n == 1:
        return 1
    if n == 2:
        return 2
    return 3

rows = []
header_cells = ''.join(f'<span class="activity-cell-label" title="{m}">{i}</span>' for m, i in zip(MONTHS, MONTH_INITIALS))
rows.append(f'<div class="activity-map-row activity-map-header"><span class="activity-map-year-label"></span>{header_cells}</div>')

for y in range(max_year, min_year - 1, -1):
    cells = []
    for m in range(1, 13):
        n = counts.get((y, m), 0)
        lvl = level(n)
        label = f"{n} post{'s' if n != 1 else ''}" if n else "no posts"
        cells.append(f'<span class="activity-cell" data-level="{lvl}" title="{MONTHS[m-1]} {y} &middot; {label}"></span>')
    rows.append(f'<div class="activity-map-row"><span class="activity-map-year-label">{y}</span>{"".join(cells)}</div>')

legend = (
    '<div class="activity-map-legend">'
    '<span class="activity-map-legend-label">Less</span>'
    '<span class="activity-cell" data-level="0"></span>'
    '<span class="activity-cell" data-level="1"></span>'
    '<span class="activity-cell" data-level="2"></span>'
    '<span class="activity-cell" data-level="3"></span>'
    '<span class="activity-map-legend-label">More</span>'
    '</div>'
)

fragment = '<div class="activity-map">' + ''.join(rows) + legend + '</div>'

with open('/tmp/activity-map-fragment.html', 'w', encoding='utf-8') as f:
    f.write(fragment)

print(f"  Activity map: {min_year}-{max_year}")
PYTHON_SCRIPT

# Generate the post-card grid for the blog list page: a thumbnail (the
# post's own image if it has one, otherwise a generated Catppuccin-accent
# tile picked deterministically per post) + title + date + tags.
echo "🎴 Generating post cards..."
python3 << 'PYTHON_SCRIPT'
import glob
import hashlib
import html
import os
import re

CATPPUCCIN_ACCENTS = [
    "rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach",
    "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender",
]

def accent_for(key):
    h = int(hashlib.md5(key.encode()).hexdigest(), 16)
    return CATPPUCCIN_ACCENTS[h % len(CATPPUCCIN_ACCENTS)]

def parse_front_matter(content):
    metadata, body = {}, content
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            for line in parts[1].split('\n'):
                if ':' in line:
                    k, v = line.split(':', 1)
                    metadata[k.strip()] = v.strip().strip('"')
            body = parts[2]
    return metadata, body

def thumb_html_for(slug, metadata, body):
    src = metadata.get('thumbnail', '').strip()
    if not src:
        # Strip HTML comments first — otherwise the example image in
        # blog new's reminder block (an inert <!-- ... --> block) gets
        # mistaken for a real embedded image.
        body_no_comments = re.sub(r'<!--.*?-->', '', body, flags=re.DOTALL)
        m = re.search(r'!\[[^\]]*\]\(([^)\s]+)\)', body_no_comments)
        if m:
            src = m.group(1)
    if src:
        return f'<div class="post-thumb"><img src="{html.escape(src)}" alt="" loading="lazy"></div>'
    accent = accent_for(slug)
    return f'<div class="post-thumb post-thumb-generated" data-accent="{accent}"></div>'

def tags_html_for(metadata):
    tags = [t.strip() for t in metadata.get('tags', '').split(',') if t.strip()]
    if not tags:
        return ''
    spans = ''.join(f'<span class="tag-pill">{html.escape(t)}</span>' for t in tags)
    return f'<div class="post-card-tags">{spans}</div>'

cards = []
for filepath in sorted(glob.glob('content/posts/*.md'), reverse=True):
    slug = os.path.basename(filepath)[:-3]
    with open(filepath, encoding='utf-8') as f:
        content = f.read()
    metadata, body = parse_front_matter(content)
    title = metadata.get('title', slug).strip('"\'')
    d = metadata.get('date', '')
    if not d:
        m = re.match(r'^([0-9]{4}-[0-9]{2}-[0-9]{2})', slug)
        d = m.group(1) if m else ''

    card = (
        f'<a class="post-card" href="content/posts/{slug}.html">'
        f'{thumb_html_for(slug, metadata, body)}'
        f'<div class="post-card-body">'
        f'<h2 class="post-card-title">{html.escape(title)}</h2>'
        f'<p class="post-card-date">{html.escape(d)}</p>'
        f'{tags_html_for(metadata)}'
        f'</div></a>'
    )
    cards.append(card)

fragment = '<div class="post-card-grid">' + ''.join(cards) + '</div>' if cards else ''

with open('/tmp/post-cards-fragment.html', 'w', encoding='utf-8') as f:
    f.write(fragment)

print(f"  Generated {len(cards)} post card(s)")
PYTHON_SCRIPT

# Generate blog index page
echo "📚 Generating blog index..."
cat > /tmp/blog-list.md << 'EOF'
---
title: Blog
---

![](https://visitor-badge.laobi.icu/badge?page_id=mgiug-io)

<p class="feed-link"><a href="feed.xml" title="Subscribe via RSS/Atom" aria-label="RSS feed"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 11a9 9 0 0 1 9 9"></path><path d="M4 4a16 16 0 0 1 16 16"></path><circle cx="5" cy="19" r="1"></circle></svg> RSS feed</a></p>

<!-- ACTIVITY_MAP -->

<!-- POST_CARDS -->
EOF

# Inject the activity map and post-card fragments
python3 -c "
with open('/tmp/blog-list.md', 'r') as f:
    content = f.read()
with open('/tmp/activity-map-fragment.html', 'r') as f:
    activity_map = f.read()
with open('/tmp/post-cards-fragment.html', 'r') as f:
    post_cards = f.read()
content = content.replace('<!-- ACTIVITY_MAP -->', activity_map)
content = content.replace('<!-- POST_CARDS -->', post_cards)
with open('/tmp/blog-list.md', 'w') as f:
    f.write(content)
"

convert_md_to_html "/tmp/blog-list.md" "$OUTPUT_DIR/blog.html" "."

# Generate Atom feed of blog posts
echo "📡 Generating Atom feed..."
python3 << 'PYTHON_SCRIPT'
import glob
import os
import re
from datetime import datetime, timezone
from xml.sax.saxutils import escape

SITE_URL = "https://blog.giugliano.info"

def extract_metadata(content):
    metadata = {}
    body = content
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            for line in parts[1].split('\n'):
                if ':' in line:
                    key, value = line.split(':', 1)
                    metadata[key.strip()] = value.strip().strip('"')
            body = parts[2]
    return metadata, body

def strip_markdown(text):
    text = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)
    text = re.sub(r'!\[[^\]]*\]\([^\)]*\)', '', text)
    text = re.sub(r'#+ ', '', text)
    text = re.sub(r'\[([^\]]+)\]\([^\)]+\)', r'\1', text)
    text = re.sub(r'[*_`]', '', text)
    return re.sub(r'\s+', ' ', text).strip()

def iso(date_str):
    return datetime.strptime(date_str, '%Y-%m-%d').replace(tzinfo=timezone.utc).strftime('%Y-%m-%dT00:00:00Z')

entries = []
for filepath in sorted(glob.glob('content/posts/*.md'), reverse=True):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    metadata, body = extract_metadata(content)
    filename = os.path.basename(filepath)[:-3]

    date_str = metadata.get('date', '')
    m = re.match(r'^([0-9]{4}-[0-9]{2}-[0-9]{2})', date_str) or re.match(r'^([0-9]{4}-[0-9]{2}-[0-9]{2})', filename)
    if not m:
        continue

    entries.append({
        'title': metadata.get('title', filename),
        'url': f'{SITE_URL}/content/posts/{filename}.html',
        'date': m.group(1),
        'summary': strip_markdown(body)[:400],
    })

updated = iso(entries[0]['date']) if entries else datetime.now(timezone.utc).strftime('%Y-%m-%dT00:00:00Z')

items = []
for e in entries:
    items.append(f'''  <entry>
    <title>{escape(e['title'])}</title>
    <link href="{escape(e['url'])}"/>
    <id>{escape(e['url'])}</id>
    <published>{iso(e['date'])}</published>
    <updated>{iso(e['date'])}</updated>
    <summary type="text">{escape(e['summary'])}</summary>
    <author><name>Michele Giugliano</name></author>
  </entry>''')

feed = f'''<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Michele Giugliano — Blog</title>
  <subtitle>Blog posts by Michele Giugliano</subtitle>
  <link href="{SITE_URL}/feed.xml" rel="self"/>
  <link href="{SITE_URL}/blog.html"/>
  <id>{SITE_URL}/</id>
  <updated>{updated}</updated>
{chr(10).join(items)}
</feed>
'''

output_dir = os.environ.get('OUTPUT_DIR', 'docs')
with open(f'{output_dir}/feed.xml', 'w', encoding='utf-8') as f:
    f.write(feed)

print(f"  Feed generated with {len(entries)} entries")
PYTHON_SCRIPT

# Generate search index
echo "🔍 Generating search index..."
python3 << 'PYTHON_SCRIPT'
import json
import os
import re
import glob
import sys

def extract_metadata(content):
    """Extract YAML front matter from markdown"""
    metadata = {}
    
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            front_matter = parts[1]
            for line in front_matter.split('\n'):
                if ':' in line:
                    key, value = line.split(':', 1)
                    metadata[key.strip()] = value.strip().strip('"')
            content = parts[2]
    
    return metadata, content

def strip_markdown(text):
    """Remove markdown formatting"""
    text = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)
    text = re.sub(r'#+ ', '', text)
    text = re.sub(r'\[([^\]]+)\]\([^\)]+\)', r'\1', text)
    text = re.sub(r'[*_`]', '', text)
    return text.strip()

try:
    search_index = []

    # Index all markdown files
    for pattern in ['index.md', 'content/posts/*.md', 'content/pages/*.md']:
        for filepath in glob.glob(pattern):
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            metadata, body = extract_metadata(content)
            
            # Determine URL
            if filepath == 'index.md':
                url = 'home.html'
            elif 'posts' in filepath:
                filename = os.path.basename(filepath).replace('.md', '.html')
                url = f'content/posts/{filename}'
            elif 'pages' in filepath:
                filename = os.path.basename(filepath).replace('.md', '.html')
                url = f'content/pages/{filename}'
            else:
                continue
            
            # Clean content for search
            clean_content = strip_markdown(body)
            
            search_index.append({
                'url': url,
                'title': metadata.get('title', os.path.basename(filepath)),
                'content': clean_content,
                'tags': metadata.get('tags', ''),
                'date': metadata.get('date', '')
            })

    # Write search index
    output_dir = os.environ.get('OUTPUT_DIR', 'docs')
    with open(f'{output_dir}/search-index.json', 'w', encoding='utf-8') as f:
        json.dump(search_index, f, indent=2)

    print(f"  Indexed {len(search_index)} documents")
    
except Exception as e:
    print(f"  ERROR: Failed to generate search index: {e}", file=sys.stderr)
    sys.exit(1)

PYTHON_SCRIPT

# Verify search index was created
if [ ! -f "$OUTPUT_DIR/search-index.json" ]; then
  echo "❌ ERROR: Search index was not created!"
  exit 1
fi

echo "  ✓ Search index created successfully"

# Publish: swap the finished scratch build into place in one shot, rather than
# mutating $FINAL_OUTPUT_DIR file-by-file over several seconds.
echo "📤 Publishing to '$FINAL_OUTPUT_DIR/'..."
rm -rf "$FINAL_OUTPUT_DIR"
cp -r "$OUTPUT_DIR" "$FINAL_OUTPUT_DIR"
rm -rf "$OUTPUT_DIR"

echo "✅ Build complete! Site generated in '$FINAL_OUTPUT_DIR/' directory"
echo ""
echo "To preview locally, run:"
echo "  cd $FINAL_OUTPUT_DIR && python3 -m http.server 8000"
