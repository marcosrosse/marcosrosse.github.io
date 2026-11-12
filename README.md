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

`data/cv.yaml` is the only source of the CV. It follows the [JSON Resume](https://jsonresume.org/schema) schema (as YAML; editors with the YAML language server validate it). Edit it and push; everything below is generated from it:

| URL | What | For |
| --- | --- | --- |
| `/` | CV page | people |
| `/Marcos-Rosse-CV.pdf` | PDF, rendered in CI with headless Chrome and the print stylesheet | recruiters, ATS uploads |
| `/resume.json` | JSON Resume | ATS and resume tools |
| `/cv.md` | Markdown | AI agents, copy and paste |
| `/llms.txt` | Short index of the above ([llms.txt](https://llmstxt.org)) | AI agents and crawlers |
| JSON-LD in `<head>` | schema.org `Person` | search engines |

Everything in `cv.yaml` is public, so keep phone numbers and anything private out of it.

**PDF:** CI renders the CV page to `/Marcos-Rosse-CV.pdf` (the "Download PDF" button) with headless Chrome and the site's print stylesheet. Locally the button 404s under `hugo server`; to preview the PDF:

```sh
hugo -d /tmp/site && scripts/cv-pdf.sh /tmp/site && open /tmp/site/Marcos-Rosse-CV.pdf
```

## Hidden projects

`_private/projects/` (gitignored, never pushed) holds project pages that are not public. Move a file back into `content/projects/` to publish it.
