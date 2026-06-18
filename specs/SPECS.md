# Personal Blog — Specification Document

## Overview

A static, bilingual (pt-BR / en) personal blog hosted on GitHub Pages. The goal is to publish technical and professional content to attract recruiters and demonstrate seniority. It must be lightweight, fast to load, and trivial to publish (write a `.md`, push, done).

## Stack

| Layer | Choice | Rationale |
|---|---|---|
| SSG | Hugo (≥ 0.147) | Fast builds, native i18n, mature ecosystem |
| Hosting | GitHub Pages via GitHub Actions | Free, automatic CI/CD on push |
| CSS | Vanilla CSS with custom properties | Zero build dependency, easy to customize |
| Analytics | Umami Cloud (free tier) | Lightweight (~2 KB), GDPR-compliant, cookieless, free up to 10k pageviews/month |
| RSS | Hugo built-in (`index.xml`) | Native, zero extra config |

## Design Handoff

Design tokens and visual direction come from a **Claude Design handoff bundle**. During implementation, Claude Code should read the bundle's tokens and translate them into `assets/css/tokens.css` as CSS custom properties. The base tokens in SPEC-012 serve as fallback defaults if no handoff bundle is provided.

---

## Specs

---

<a id="spec-001"></a>
### SPEC-001 — Hugo Project Initialization

**Given** a new empty repository
**When** the project is initialized
**Then**
- Hugo is configured via `hugo.yaml` at the repository root
- `defaultContentLanguage` is set to `"pt-br"`
- `defaultContentLanguageInSubdir` is set to `false` (pt-BR lives at the root, no `/pt-br/` prefix)
- Two languages are defined: `pt-br` (weight 1) and `en` (weight 2)
- Goldmark renderer has `unsafe: true` to allow iframes in social media posts
- Syntax highlighting uses the Dracula theme with line numbers enabled

---

<a id="spec-002"></a>
### SPEC-002 — Directory Structure

**Given** an initialized Hugo project
**When** the directory structure is set up
**Then** it follows this layout:

```
├── .github/workflows/deploy.yml
├── archetypes/
│   ├── blog.md
│   └── socialmedia.md
├── assets/css/
│   ├── tokens.css
│   └── main.css
├── content/
│   ├── blog/
│   ├── socialmedia/linkedin/
│   └── about/
├── data/social.yaml
├── i18n/
│   ├── pt-BR.yaml
│   └── en.yaml
├── layouts/
│   ├── _default/ (baseof.html, list.html, single.html)
│   ├── blog/ (list.html, single.html)
│   ├── socialmedia/ (list.html, single.html)
│   ├── partials/ (head.html, header.html, footer.html,
│   │              language-switcher.html, analytics.html, post-meta.html)
│   └── index.html
├── static/images/ (logo.svg, og-default.png, favicon.ico)
├── hugo.yaml
├── CLAUDE.md
└── README.md
```

---

<a id="spec-003"></a>
### SPEC-003 — Permalink Configuration

**Given** the Hugo configuration file
**When** permalinks are defined
**Then**
- Blog posts resolve to `/blog/:slug/`
- Social media posts resolve to `/socialmedia/:sections[1:]/:slug/`
- The main menu contains four entries in order: Writing (`/blog/`), Social Media (`/socialmedia/`), Topics (`/tags/`), About (`/about/`) — see SPEC-040 for Topics. "Writing" labels the blog section per the Claude Design bundle's copy (SPEC-038); it is the same `/blog/` section as elsewhere in this document

---

<a id="spec-004"></a>
### SPEC-004 — Filename-Based i18n Strategy

**Given** a content file `content/blog/meu-post.md` in pt-BR
**When** an English translation is created
**Then**
- The English file is named `content/blog/meu-post.en.md` (same base name, `.en` suffix)
- Hugo links both files as translations of the same content via the shared base name
- Each section has `_index.md` (pt-BR) and `_index.en.md` (en) listing pages

---

<a id="spec-005"></a>
### SPEC-005 — Translated Slugs for SEO

**Given** a blog post with filename `meu-primeiro-post.md` (pt-BR default slug: `meu-primeiro-post`)
**When** the English translation `meu-primeiro-post.en.md` is created
**Then**
- The English file overrides the slug in its frontmatter (e.g., `slug: "my-first-post"`)
- The pt-BR URL resolves to `/blog/meu-primeiro-post/`
- The English URL resolves to `/en/blog/my-first-post/`
- The `hreflang` tags in `<head>` link both versions regardless of differing slugs
- The `slug` field is required in all English blog post frontmatter

---

<a id="spec-006"></a>
### SPEC-006 — UI String Translations

**Given** the i18n files `i18n/pt-BR.yaml` and `i18n/en.yaml`
**When** the site is rendered in either language
**Then** all UI strings are translated, including at minimum:
- `read_more`, `min_read`, `published_on`, `all_posts`
- `subscribe_rss`, `language_label`
- `social_media_section`, `posted_on_linkedin`

---

<a id="spec-007"></a>
### SPEC-007 — Language Switcher

**Given** a page that has a translation available
**When** the page is rendered
**Then**
- A language switcher is visible in the header, to the right of the navigation
- It links to the translated version of the current page (using Hugo's `.Translations`)
- If no translation exists, the switcher is hidden or disabled

---

<a id="spec-008"></a>
### SPEC-008 — Blog Post Content Model (pt-BR)

**Given** a new blog post in pt-BR
**When** the author creates `content/blog/<slug>.md`
**Then** the frontmatter contains:
```yaml
---
title: "Post Title"            # required
date: 2024-01-15T14:30:00-03:00 # required
description: "Short description" # required
tags: ["tag1", "tag2"]          # optional
draft: false                    # optional, defaults to false
canonicalURL: ""                # optional, empty = auto-generated
images: ["path/to/image.png"]  # optional, for custom Open Graph
---
```
And the body is standard Markdown.

---

<a id="spec-009"></a>
### SPEC-009 — Blog Post Content Model (English)

**Given** a new blog post in English
**When** the author creates `content/blog/<pt-br-slug>.en.md`
**Then** the frontmatter contains all fields from SPEC-008 plus:
```yaml
slug: "english-slug"  # required — translated slug for SEO
```
And the filename matches the pt-BR version's filename for Hugo translation linking.

---

<a id="spec-010"></a>
### SPEC-010 — Social Media Embed Content Model

**Given** a new LinkedIn post to embed
**When** the author creates `content/socialmedia/linkedin/YYYYMMDDHHmm.md`
**Then** the frontmatter contains:
```yaml
---
title: "Descriptive title"                          # required
date: 2024-01-15T14:30:00-03:00                     # required
platform: "linkedin"                                 # required
embedURL: "https://www.linkedin.com/embed/feed/..."  # required
originalURL: "https://www.linkedin.com/posts/..."    # required
description: "Brief context about this post"         # required
draft: false                                         # optional
---
```
Optional body text appears as context above the embed.

---

<a id="spec-011"></a>
### SPEC-011 — Content Archetypes

**Given** the `archetypes/` directory
**When** archetypes are configured
**Then**
- `archetypes/blog.md` contains the blog post frontmatter template (SPEC-008)
- `archetypes/socialmedia.md` contains the social media embed frontmatter template (SPEC-010)
- Running `hugo new blog/my-post.md` scaffolds a file using the blog archetype
- Running `hugo new socialmedia/linkedin/202401151430.md` scaffolds a file using the social media archetype

---

<a id="spec-012"></a>
### SPEC-012 — CSS Design Tokens

**Given** the file `assets/css/tokens.css`
**When** design tokens are defined
**Then** the file declares CSS custom properties sourced from the Claude Design handoff bundle (project
"Luis Brand", imported via the Claude Design connector — see SPEC-038), covering:

**Type families:**
`--font-serif` (Spectral), `--font-sans` (IBM Plex Sans), `--font-mono` (IBM Plex Mono)

**Fluid type scale** (mobile-first, `clamp()`-based — grows continuously with viewport width instead of
jumping at fixed breakpoints):
`--fs-meta`, `--fs-small`, `--fs-body`, `--fs-lead`, `--fs-h3`, `--fs-h2`, `--fs-h1`, `--fs-display`

**Line heights & tracking:**
`--lh-tight` (1.1), `--lh-snug` (1.3), `--lh-body` (1.74), `--tracking-wide` (0.16em), `--tracking-mono` (0.04em)

**Spacing (0.25rem base):**
`--sp-1` through `--sp-10`

**Radii:**
`--radius-xs`, `--radius-sm`, `--radius`, `--radius-pill`

**Layout:**
`--maxw-prose` (42rem, reading measure), `--maxw-wide` (74rem, listings/index pages), `--gutter` (fluid
horizontal padding via `clamp()`)

**Motion:**
`--ease`, `--dur`

**Color tokens** (theme-switched — see SPEC-013): `--bg`, `--bg-grad`, `--bg-elev`, `--surface`,
`--surface-2`, `--text-strong`, `--text`, `--text-soft`, `--muted`, `--rule`, `--rule-strong`, `--accent`,
`--accent-strong`, `--accent-quiet`, `--warm`, `--warm-quiet`, `--shadow`, `--selection`

**Note:** These supersede the original fallback token names/values. Other spec sections below may still
reference the old names (`--color-bg`, `--text-4xl`, `--space-4`, etc.) — treat those as referring to this
token set instead, and check `assets/css/tokens.css` for the authoritative current names when implementing.

---

<a id="spec-013"></a>
### SPEC-013 — Theme Toggle (Dark/Light)

**Given** the design tokens in `tokens.css` define both a dark and a light palette
**When** a visitor loads the site or clicks the theme toggle button in the header
**Then**
- The active theme is controlled by a `data-theme` attribute on `<html>`, set to `"dark"` (default) or `"light"`
- A toggle button (sun/moon icon) in the header (SPEC-016/SPEC-017) switches themes via a small inline script
- The chosen theme is persisted in `localStorage` and restored on the next visit
- If no preference is stored, the site defaults to dark (`data-theme="dark"`)
- All components render correctly in both themes

**Note:** This replaces the original OS-only (`prefers-color-scheme`) approach with no toggle — the Claude
Design handoff bundle specifies a manual toggle defaulting to dark, matching the source LinkedIn banner's
navy/parchment mood.

---

<a id="spec-014"></a>
### SPEC-014 — Font Loading

**Given** the `<head>` of any page
**When** fonts are loaded
**Then**
- Three Google Fonts families are loaded: Spectral (weights 200/300/400/500, plus italic 300/400), IBM
  Plex Sans (weights 300/400/500/600), IBM Plex Mono (weights 300/400/500)
- `<link rel="preconnect">` is used for `fonts.googleapis.com` and `fonts.gstatic.com` (the latter with
  `crossorigin`)
- The Google Fonts CSS2 endpoint is used with `display=swap` to avoid FOIT (Flash of Invisible Text)
- The exact `<link>` markup is in the Claude Design handoff bundle's `Blog.html`; wired into
  `layouts/partials/head.html` when the base layout is built (SPEC-015)

---

<a id="spec-015"></a>
### SPEC-015 — Base Layout

**Given** the `layouts/_default/baseof.html` template
**When** any page is rendered
**Then** the HTML structure is:
```
<html>
  <head> → partials/head.html
  <body>
    <header> → partials/header.html
    <main> (max-width: var(--max-width-page), centered)
      {{ block "main" . }}
    </main>
    <footer> → partials/footer.html
  </body>
</html>
```

---

<a id="spec-016"></a>
### SPEC-016 — Header (Desktop)

**Given** a viewport wider than 768px
**When** the header is rendered
**Then**
- The logo (SVG) is displayed on the left, linking to home (`/blog/`)
- Navigation links (Blog, Social Media, About) are displayed horizontally
- The active page's link has a visually differentiated style (underline or accent color)
- The language switcher (SPEC-007) is positioned to the right of the navigation

---

<a id="spec-017"></a>
### SPEC-017 — Header (Mobile)

**Given** a viewport 768px or narrower
**When** the header is rendered
**Then**
- The logo is displayed on the left
- A hamburger menu icon replaces the horizontal navigation
- Tapping the hamburger opens a drawer/overlay with the navigation links and language switcher
- The overlay can be dismissed by tapping outside or a close button

---

<a id="spec-018"></a>
### SPEC-018 — Footer

**Given** any page
**When** the footer is rendered
**Then**
- Navigation links are repeated (Blog, Social Media, About)
- A LinkedIn link is displayed with icon and text, sourced from `data/social.yaml`
- An RSS feed link is displayed with icon and text, pointing to `/blog/index.xml`
- A copyright line is displayed: `© {year} {author name}` (internationalized)
- On viewports ≤ 768px, footer columns stack vertically

---

<a id="spec-019"></a>
### SPEC-019 — Homepage

**Given** a visitor navigates to the root URL (`/`)
**When** the homepage is rendered
**Then**
- The blog post listing is rendered directly on the homepage (no redirect to `/blog/`)
- Posts are displayed using the same card format as the blog listing page (SPEC-020)
- The implementation uses Hugo's `site.GetPage "/blog"` to pull posts

---

<a id="spec-020"></a>
### SPEC-020 — Blog Listing Page

**Given** a visitor navigates to `/blog/` (or `/en/blog/`)
**When** the listing page is rendered
**Then**
- All non-draft blog posts for the current language are listed
- Posts are sorted by date, most recent first
- Each card displays: title (as a link), formatted date, description, tags as badges, estimated reading time
- Initially all posts are listed without pagination
- If the post count exceeds 20, Hugo's `Paginator` is activated at 10 posts per page

---

<a id="spec-021"></a>
### SPEC-021 — Blog Post Page

**Given** a visitor navigates to a blog post URL (e.g., `/blog/meu-post/`)
**When** the single post page is rendered
**Then**
- The title is displayed using the post-title token (`--fs-h1`, see SPEC-012)
- Post metadata is shown: formatted date, estimated reading time, tags
- The body text is constrained to `max-width: var(--maxw-prose)`, centered
- Body font-size is `var(--fs-body)` with `var(--lh-body)`
- A table of contents (built from the post's headings) is shown: as a boxed callout above the article on
  narrow viewports, and as a sticky rail to the left of the article on viewports ≥ 960px — new scope from
  the Claude Design handoff (SPEC-038), not in the original spec set
- Code blocks use Hugo's built-in Chroma syntax highlighting (Dracula theme)
- Images are responsive with `max-width: 100%`
- At the end of the post, a link to the translated version is shown (if it exists)

---

<a id="spec-022"></a>
### SPEC-022 — Social Media Listing Page

**Given** a visitor navigates to `/socialmedia/` (or `/en/socialmedia/`)
**When** the listing page is rendered
**Then**
- Posts are grouped by platform (currently only LinkedIn)
- Each card displays: title, formatted date, platform name
- Cards link to the individual embed page

---

<a id="spec-023"></a>
### SPEC-023 — Social Media Embed Page

**Given** a visitor navigates to a social media post URL (e.g., `/socialmedia/linkedin/202401151430/`)
**When** the single page is rendered
**Then**
- If body text exists, it is displayed as context above the embed
- The `embedURL` from frontmatter is rendered as a responsive `<iframe>` with aspect ratio ~1:1.2 (adjustable)
- The iframe has `loading="lazy"`
- A link to `originalURL` is displayed below the embed

---

<a id="spec-024"></a>
### SPEC-024 — About Page

**Given** a visitor navigates to `/about/` (or `/en/about/`)
**When** the page is rendered
**Then**
- The content from `content/about/_index.md` (or `_index.en.md`) is rendered
- The page uses the default single-page layout
- The body text follows the same `max-width: var(--max-width-content)` constraint as blog posts

---

<a id="spec-025"></a>
### SPEC-025 — Canonical URLs

**Given** any blog post page
**When** the `<head>` is rendered
**Then**
- If the frontmatter defines `canonicalURL`, a `<link rel="canonical">` tag uses that value
- If `canonicalURL` is empty or absent, the tag uses the page's own `.Permalink`
- Exactly one `<link rel="canonical">` tag is present per page

---

<a id="spec-026"></a>
### SPEC-026 — Meta Tags and Open Graph

**Given** any page
**When** the `<head>` is rendered
**Then** it includes:
- `<meta name="description">` using the page's description (fallback: site description)
- `<meta name="author">` using `site.Params.author`
- Open Graph tags: `og:title`, `og:description`, `og:type` (`article` for pages, `website` for listings), `og:url`, `og:image` (page-specific or `og-default.png`), `og:locale`
- Twitter Card tags: `twitter:card` (`summary_large_image`), `twitter:title`, `twitter:description`

---

<a id="spec-027"></a>
### SPEC-027 — Hreflang Tags

**Given** a page that has one or more translations
**When** the `<head>` is rendered
**Then**
- A `<link rel="alternate" hreflang="{lang}" href="{url}">` tag is emitted for each translation
- A self-referencing hreflang tag is also emitted for the current page's language
- The `href` values use each translation's own permalink (which may have a translated slug)

---

<a id="spec-028"></a>
### SPEC-028 — Structured Data (JSON-LD)

**Given** a single blog post page
**When** the `<head>` is rendered
**Then** a `<script type="application/ld+json">` block is included with:
```json
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "headline": "<title>",
  "datePublished": "<date in YYYY-MM-DD>",
  "dateModified": "<lastmod in YYYY-MM-DD>",
  "author": { "@type": "Person", "name": "<author>" },
  "description": "<description>"
}
```
Non-blog pages do not include this block.

---

<a id="spec-029"></a>
### SPEC-029 — RSS Feed

**Given** the Hugo output configuration
**When** the site is built
**Then**
- A section-level RSS feed is generated at `/blog/index.xml`
- A site-level RSS feed is generated at `/index.xml`
- Each feed item includes: `title`, `description`, `link`, `pubDate`, `content:encoded` (full post content)
- The `<head>` of every page includes an RSS autodiscovery tag:
  `<link rel="alternate" type="application/rss+xml" title="{site title}" href="{/blog/index.xml absolute URL}">`
- The footer contains a visible link to the RSS feed with an icon

---

<a id="spec-030"></a>
### SPEC-030 — Umami Analytics Script

**Given** the Hugo configuration has `params.umami.websiteId` and `params.umami.src` set
**When** any page is rendered
**Then**
- A `<script defer src="{src}" data-website-id="{websiteId}">` tag is included in `<head>`
- The script is loaded via the `partials/analytics.html` partial
- If the Umami params are absent, no analytics script is injected

---

<a id="spec-031"></a>
### SPEC-031 — Analytics Event Tracking

**Given** an external link or CTA in the site templates
**When** the link is rendered
**Then**
- The `<a>` tag includes a `data-umami-event` attribute with a descriptive event name
- Example: `<a href="..." data-umami-event="click-linkedin-profile">LinkedIn</a>`
- At minimum, the following are tracked: LinkedIn profile link in footer, RSS feed link, links to original social media posts

---

<a id="spec-032"></a>
### SPEC-032 — Responsive Layout: Mobile

**Given** a viewport narrower than 768px
**When** any page is rendered
**Then**
- The header uses a hamburger menu (SPEC-017)
- Layout is single-column
- Horizontal padding is `var(--space-4)`
- Body font-size is `var(--text-base)`
- Footer columns stack vertically
- Social media iframes scale to full container width

---

<a id="spec-033"></a>
### SPEC-033 — Responsive Layout: Tablet

**Given** a viewport between 768px and 1024px
**When** any page is rendered
**Then**
- The header displays horizontal navigation (SPEC-016)
- Layout is single-column, wider than mobile
- Horizontal padding is `var(--space-8)`

---

<a id="spec-034"></a>
### SPEC-034 — Responsive Layout: Desktop

**Given** a viewport wider than 1024px
**When** any page is rendered
**Then**
- The page is centered with `max-width: var(--max-width-page)`
- Blog post body is constrained to `max-width: var(--max-width-content)` for a comfortable reading line length (~65–75 characters per line)

---

<a id="spec-035"></a>
### SPEC-035 — GitHub Actions Deployment

**Given** a push to the `main` branch
**When** the GitHub Actions workflow runs
**Then**
- Hugo is installed (latest version, extended edition)
- The site is built with `hugo --minify`
- The `./public` directory is deployed to GitHub Pages
- The workflow has `concurrency` configured to cancel in-progress deploys
- Required permissions: `contents: read`, `pages: write`, `id-token: write`

---

<a id="spec-036"></a>
### SPEC-036 — Blog Post Publication Workflow

**Given** an author wants to publish a new blog post
**When** the content is created
**Then** the workflow is:
1. Run `hugo new blog/<slug-pt-br>.md` to scaffold the pt-BR post
2. Run `hugo new blog/<slug-pt-br>.en.md` to scaffold the English version
3. Add `slug: "<english-slug>"` to the English file's frontmatter
4. Write the content in both files
5. `git add`, `git commit`, `git push` triggers automatic deployment (SPEC-035)

---

<a id="spec-037"></a>
### SPEC-037 — Social Media Publication Workflow

**Given** an author wants to embed a LinkedIn post
**When** the content is created
**Then** the workflow is:
1. Run `hugo new socialmedia/linkedin/YYYYMMDDHHmm.md`
2. Fill in the frontmatter: `embedURL`, `originalURL`, `title`, `description`
3. `git add`, `git commit`, `git push` triggers automatic deployment (SPEC-035)

---

<a id="spec-038"></a>
### SPEC-038 — Claude Design Handoff Workflow

**Given** a design system and page prototypes are finalized in Claude Design
**When** the design is ready for implementation
**Then** the workflow is:
1. In Claude Design, click **Export → Handoff to Claude Code**
2. The handoff bundle is generated, containing: design tokens, component structure, layout hierarchy, and a README
3. Optionally, edit the bundle's README to include Hugo-specific instructions (template paths, token file location, routing rules)
4. In Claude Code, provide the bundle together with this spec document
5. Claude Code translates the bundle's design tokens into `assets/css/tokens.css` (overriding SPEC-012 defaults)
6. Claude Code implements Hugo templates following both the visual intent from the bundle and the architecture from this spec

---

<a id="spec-039"></a>
### SPEC-039 — CLAUDE.md Project File

**Given** the repository root
**When** the `CLAUDE.md` file is created
**Then** it documents:
- The project stack (Hugo, GitHub Pages, Vanilla CSS, Umami)
- Design system rules (when to use each color token, typography hierarchy, spacing conventions)
- Content conventions (frontmatter requirements, slug translation rule for English)
- Build and dev commands (`hugo server`, `hugo --minify`)
- File organization conventions from SPEC-002
- Any constraints from the Claude Design handoff bundle

---

<a id="spec-040"></a>
### SPEC-040 — Topics (Tags) Taxonomy Pages

**Given** blog posts with a `tags` frontmatter field (SPEC-008)
**When** a visitor navigates to `/tags/` (or `/en/tags/`)
**Then**
- A tag cloud is displayed: every tag used by at least one non-draft post, each showing its post count
- The page is reachable from the main menu under the label "Topics" (SPEC-003), even though the underlying
  Hugo taxonomy and URL remain `tags` / `/tags/`
- Navigating to `/tags/<tag>/` (or `/en/tags/<tag>/`) shows all non-draft posts carrying that tag, sorted
  by date (most recent first), using the same card format as the blog listing page (SPEC-020)
- Added as part of the Claude Design handoff (SPEC-038); not in the original spec set

---

## Reference: URL Map

| Content | pt-BR (default) | English |
|---|---|---|
| Homepage | `/` | `/en/` |
| Blog listing | `/blog/` | `/en/blog/` |
| Blog post | `/blog/<slug-pt>/` | `/en/blog/<slug-en>/` |
| Social media listing | `/socialmedia/` | `/en/socialmedia/` |
| LinkedIn embed | `/socialmedia/linkedin/YYYYMMDDHHmm/` | `/en/socialmedia/linkedin/YYYYMMDDHHmm/` |
| Topics (tags) | `/tags/` | `/en/tags/` |
| Topic (single tag) | `/tags/<tag>/` | `/en/tags/<tag>/` |
| About | `/about/` | `/en/about/` |
| RSS (blog) | `/blog/index.xml` | `/en/blog/index.xml` |

## Reference: Hugo Configuration (`hugo.yaml`)

```yaml
baseURL: "https://<username>.github.io/"
title: "<Blog Name>"
defaultContentLanguage: "pt-br"
defaultContentLanguageInSubdir: false

languages:
  pt-br:
    languageName: "Português"
    weight: 1
    params:
      description: "<blog description in pt-BR>"
  en:
    languageName: "English"
    weight: 2
    params:
      description: "<blog description in English>"

params:
  author: "<Author Name>"
  linkedin: "https://www.linkedin.com/in/<profile>"
  umami:
    websiteId: "<UMAMI_WEBSITE_ID>"
    src: "https://cloud.umami.is/script.js"

permalinks:
  blog: "/blog/:slug/"
  socialmedia: "/socialmedia/:sections[1:]/:slug/"

menus:
  main:
    - name: "Writing"
      url: "/blog/"
      weight: 1
    - name: "Social Media"
      url: "/socialmedia/"
      weight: 2
    - name: "Topics"
      url: "/tags/"
      weight: 3
    - name: "About"
      url: "/about/"
      weight: 4

outputs:
  home: ["HTML", "RSS"]
  section: ["HTML", "RSS"]

markup:
  goldmark:
    renderer:
      unsafe: true
  highlight:
    style: "dracula"
    lineNos: true
```

## Implementation Checklist (Suggested Order)

1. SPEC-001, SPEC-002, SPEC-003 — Project init, structure, config
2. SPEC-012, SPEC-013, SPEC-014 — Design tokens, dark mode, fonts
3. SPEC-015 — Base layout
4. SPEC-025, SPEC-026, SPEC-027, SPEC-028 — SEO (`head.html`)
5. SPEC-029 — RSS
6. SPEC-030, SPEC-031 — Analytics
7. SPEC-016, SPEC-017, SPEC-007 — Header, mobile menu, language switcher
8. SPEC-018 — Footer
9. SPEC-004, SPEC-005, SPEC-006 — i18n wiring
10. SPEC-008, SPEC-009, SPEC-010, SPEC-011 — Content models and archetypes
11. SPEC-020, SPEC-021 — Blog templates
12. SPEC-022, SPEC-023 — Social media templates
13. SPEC-024 — About page
14. SPEC-019 — Homepage
15. SPEC-032, SPEC-033, SPEC-034 — Responsive breakpoints
16. SPEC-040 — Topics (tags) taxonomy pages
17. SPEC-035 — GitHub Actions deployment
18. Sample content: 1 bilingual blog post + 1 social media embed
19. Validate: Lighthouse audit, Open Graph debugger, RSS validator