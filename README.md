# marcosrosse.github.io

Portfolio and blog, built with [Hugo](https://gohugo.io) (no theme, layouts in `layouts/`) and deployed to GitHub Pages by `.github/workflows/pages.yml` on every push to `main`. Pull requests only build.

## Run locally

```sh
brew install hugo          # 0.146+ (CI pins the version in the workflow)
hugo server                # http://localhost:1313, live reload
hugo server --bind 0.0.0.0 --baseURL http://<lan-ip>:1313/   # test from another device
```

## Add a project

Create `content/projects/<slug>.md`:

```yaml
---
title: "Project name"
summary: "One or two sentences shown in the list and as the page lede."
status: "Live"            # Live | In use | In development | Paused | Planning
weight: 80                # list order, lower first
private: true             # shows "Source is private" when there is no repo
repo: ""                  # public GitHub URL → "View on GitHub" button
live: ""                  # public site URL → "Open live site" button
setup:                    # layers, top to bottom; shown as the setup pipeline
  - "Layer one"
  - "Layer two"
stack: ["Go", "k3s"]
---
Markdown body: what it is, how it is set up, what is worth pointing out.
```

"Request a demo" is always shown; it opens an email to `params.email` (in `hugo.toml`) with the project name in the subject.

## Write a post

```sh
hugo new content posts/my-post.md   # starts as draft; set draft: false to publish
```

## One-time GitHub setup

Settings → Pages → Build and deployment → Source: **GitHub Actions**.

## CV

The home page renders `data/resume.json`, an export from [Reactive Resume](https://rxresu.me). Re-export and replace the file to update it. Sections or items marked hidden in Reactive Resume are skipped, and the phone number is never rendered, **but the raw JSON is public in this repo**: remove anything private from it before committing (CI fails if `basics.phone` is set). The displayed name comes from `params.author` in `hugo.toml`, not from the JSON.

**PDF:** CI renders the CV page to `/Marcos-Rosse-CV.pdf` (the "Download PDF" button) with headless Chrome and the site's print stylesheet. Locally the button 404s under `hugo server`; to preview the PDF:

```sh
hugo -d /tmp/site && scripts/cv-pdf.sh /tmp/site && open /tmp/site/Marcos-Rosse-CV.pdf
```

## Hidden projects

`_private/projects/` (gitignored, never pushed) holds project pages that are not public. Move a file back into `content/projects/` to publish it.
