# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

This repository currently contains only `specs/SPECS.md` — the full specification for a bilingual personal
blog that has **not been implemented yet**. There is no `hugo.yaml`, no `content/`, no `layouts/`, no
`assets/`. The first work in this repo will be to scaffold the Hugo project from scratch following the spec.

`specs/SPECS.md` is the source of truth. It is written as a series of Given/When/Then specs (SPEC-001 through SPEC-039) plus a suggested implementation order at the bottom of the file. Before implementing any
feature, read the corresponding SPEC-### section in full — this file only summarizes the architecture.

`specs/BACKLOG.md` tracks which specs are implemented. Check it before assuming a spec is unimplemented,
and check the box there (not in SPECS.md) once a spec is fully done and verified.

## Stack

| Layer | Choice |
|---|---|
| SSG | Hugo (≥ 0.147, extended edition) |
| Hosting | GitHub Pages via GitHub Actions |
| CSS | Vanilla CSS with custom properties (no build step, no framework) |
| Analytics | Umami Cloud, loaded conditionally via `partials/analytics.html` |
| RSS | Hugo's built-in `index.xml` output |

## Commands

- `hugo new blog/<slug>.md` — scaffold a pt-BR blog post from `archetypes/blog.md`
- `hugo new blog/<slug>.en.md` — scaffold the English translation (same base filename + `.en`)
- `hugo new socialmedia/linkedin/YYYYMMDDHHmm.md` — scaffold a LinkedIn embed from `archetypes/socialmedia.md`
- `hugo server` — local dev server with live reload
- `hugo --minify` — production build (output to `./public`, what CI runs)

There is no package manager, linter, or test suite in this project — it's a static Hugo site with vanilla CSS. Validation is manual: Lighthouse audit, Open Graph debugger, RSS validator (see end of SPECS.md).

## Architecture

### i18n: filename-based translations, not subdirectories

- pt-BR is the default content language, served at the root (no `/pt-br/` prefix). English is served under `/en/`.
- A translation pair is two files sharing the same base filename: `content/blog/meu-post.md` (pt-BR) and  `content/blog/meu-post.en.md` (English). Hugo links them as translations via this shared base name —  renaming one without the other breaks the language switcher.
- **Slugs are allowed to differ between languages for SEO.** The pt-BR file uses the filename as the slug; the English file must set `slug: "<english-slug>"` explicitly in frontmatter. This is the one frontmatter   field unique to English posts (SPEC-009). `hreflang` tags must still resolve correctly across differing slugs (SPEC-027).
- UI strings (not content) live in `i18n/pt-BR.yaml` and `i18n/en.yaml`.

### Content models

Two content types, each with a strict required-frontmatter contract (see SPEC-008/009/010 for exact fields): `content/blog/*.md` (title, date, description required; tags/draft/canonicalURL/images optional) and `content/socialmedia/linkedin/*.md` (title, date, platform, embedURL, originalURL, description
required). Archetypes in `archetypes/` exist so `hugo new` scaffolds these correctly — keep archetypes in
sync if the frontmatter contract changes.

### Design tokens

All visual styling is driven by CSS custom properties in `assets/css/tokens.css` — colors, typography
scale, spacing (4px scale), layout widths, transitions. `assets/css/main.css` consumes these tokens; it
should not hardcode raw color/size values. SPEC-012 lists the full token set and their default values.
Dark mode (SPEC-013) is OS-driven only (`prefers-color-scheme: dark`), with no manual toggle — every dark
token has a `-dark` suffixed counterpart that gets swapped in via a single media query, not per-component
overrides.

If a **Claude Design handoff bundle** is provided for a piece of work, its tokens override the SPEC-012
defaults in `tokens.css`, and its component/layout structure should drive the corresponding Hugo templates
(SPEC-038). Without a handoff bundle, SPEC-012's defaults apply.

### SEO and head rendering

`partials/head.html` is responsible for canonical URLs (self-permalink fallback when `canonicalURL` is
unset), Open Graph + Twitter Card tags, hreflang alternates for every translation (plus a self-referencing
one), RSS autodiscovery, and JSON-LD `BlogPosting` structured data — the last one only on single blog post
pages, not listings or other sections (SPEC-025 through SPEC-028).

### Analytics

The Umami script is injected only when `params.umami.websiteId` and `params.umami.src` are both set in
`hugo.yaml` — `partials/analytics.html` must no-op otherwise. Outbound/CTA links that should be tracked
carry a `data-umami-event="<descriptive-name>"` attribute (e.g. `click-linkedin-profile`); at minimum this
applies to the footer LinkedIn link, RSS link, and links to original social media posts (SPEC-031).

### Deployment

Push to `main` triggers `.github/workflows/deploy.yml`: install Hugo extended, `hugo --minify`, deploy
`./public` to GitHub Pages. No separate staging environment or PR preview is specified.

## Reference: directory layout

```
├── .github/workflows/deploy.yml
├── archetypes/{blog.md, socialmedia.md}
├── assets/css/{tokens.css, main.css}
├── content/{blog/, socialmedia/linkedin/, about/}
├── data/social.yaml
├── i18n/{pt-BR.yaml, en.yaml}
├── layouts/
│   ├── _default/ (baseof.html, list.html, single.html)
│   ├── blog/ (list.html, single.html)
│   ├── socialmedia/ (list.html, single.html)
│   ├── partials/ (head.html, header.html, footer.html,
│   │              language-switcher.html, analytics.html, post-meta.html)
│   └── index.html
├── static/images/(logo.svg, og-default.png, favicon.ico)
├── hugo.yaml
└── specs/SPECS.md
```