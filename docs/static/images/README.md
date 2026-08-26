Drop image files here (jpg, png, gif, svg, webp).

This whole `static/` folder is copied into `docs/` on every build, so anything
you add here is automatically published. In a post or page, reference an
image with a domain-absolute path so it resolves correctly no matter how
deep the markdown file lives:

```markdown
![A description of the image](/static/images/your-file.jpg)
```

See `templates/post-template.md` for a full example.
