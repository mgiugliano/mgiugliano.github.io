#!/bin/bash

# Build script for personal website
# Converts Markdown to HTML using Pandoc and generates search index

set -e

TEMPLATE="templates/default.html"
OUTPUT_DIR="docs"
CONTENT_DIR="content"
STATIC_DIR="static"
# Generate timestamp for cache busting
BUILD_TIMESTAMP=$(date +%s)

echo "🚀 Building personal website..."

# Clean output directory
echo "🧹 Cleaning output directory..."
rm -rf "$OUTPUT_DIR"
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
  
  echo "  Converting: $input_file -> $output_file"
  
  pandoc "$input_file" \
    --template="$TEMPLATE" \
    --standalone \
    --to=html5 \
    --variable="cache_bust:$BUILD_TIMESTAMP" \
    --variable="root:$root_path" \
    -o "$output_file"
}

# Convert index page
if [ -f "index.md" ]; then
  echo "📄 Converting index page..."
  convert_md_to_html "index.md" "$OUTPUT_DIR/index.html" "."
fi

# Convert blog posts
if [ -d "$CONTENT_DIR/posts" ]; then
  echo "📝 Converting blog posts..."
  for post in "$CONTENT_DIR/posts"/*.md; do
    if [ -f "$post" ]; then
      filename=$(basename "$post" .md)
      convert_md_to_html "$post" "$OUTPUT_DIR/content/posts/$filename.html" "../.."
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

# Generate blog index page
echo "📚 Generating blog index..."
cat > /tmp/blog-list.md << 'EOF'
---
title: Blog
---

# Blog Posts

EOF

# List all blog posts (sorted by filename, newest first)
if [ -d "$CONTENT_DIR/posts" ]; then
  for post in $(ls -r "$CONTENT_DIR/posts"/*.md 2>/dev/null); do
    if [ -f "$post" ]; then
      filename=$(basename "$post" .md)
      
      # Extract title from YAML front matter or use filename
      title=$(grep "^title:" "$post" | head -1 | sed 's/title: *//; s/"//g' || echo "$filename")
      
      # Extract date from YAML front matter or filename
      date=$(grep "^date:" "$post" | head -1 | sed 's/date: *//; s/"//g' || echo "$filename" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' || echo "")
      
      echo "## [$title](content/posts/$filename.html)" >> /tmp/blog-list.md
      if [ -n "$date" ]; then
        echo "*$date*" >> /tmp/blog-list.md
      fi
      echo "" >> /tmp/blog-list.md
    fi
  done
fi

convert_md_to_html "/tmp/blog-list.md" "$OUTPUT_DIR/blog.html" "."

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
                url = 'index.html'
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
                'content': clean_content[:500],  # First 500 chars
                'tags': metadata.get('tags', ''),
                'date': metadata.get('date', '')
            })

    # Write search index
    with open('docs/search-index.json', 'w', encoding='utf-8') as f:
        json.dump(search_index, f, indent=2)

    print(f"  Indexed {len(search_index)} documents")
    
except Exception as e:
    print(f"  ERROR: Failed to generate search index: {e}", file=sys.stderr)
    sys.exit(1)

PYTHON_SCRIPT

# Verify search index was created
if [ ! -f "docs/search-index.json" ]; then
  echo "❌ ERROR: Search index was not created!"
  exit 1
fi

echo "  ✓ Search index created successfully at docs/search-index.json"

echo "✅ Build complete! Site generated in '$OUTPUT_DIR/' directory"
echo ""
echo "To preview locally, run:"
echo "  cd $OUTPUT_DIR && python3 -m http.server 8000"
