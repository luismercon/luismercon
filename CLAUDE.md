# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

This is a bilingual personal blog built with Hugo, in progress. The core site renders end-to-end: base
layout, header/footer, language switcher, dark/light toggle, homepage, blog listing + post (with TOC), About
page, SEO meta (canonical/OG/hreflang/JSON-LD), full-content RSS, and Umami analytics are all implemented and
build clean with `hugo --minify`. Social Media and Topics (tags) were tried and then deliberately removed —
see `specs/BACKLOG.md` groups 12/16 for why; not re-adding either without explicit direction. Not yet
implemented: GitHub Actions deployment and `static/images/` (logo, favicon, OG image — see SPEC-002 caveat
in BACKLOG.md). See `specs/BACKLOG.md` for the exact per-spec status — check it before assuming something is
or isn't done.

`specs/SPECS.md` is the source of truth. It is written as a series of Given/When/Then specs (SPEC-001
through SPEC-040) plus a suggested implementation order at the bottom of the file. Before implementing any
feature, read the corresponding SPEC-### section in full — this file only summarizes the architecture.

`specs/BACKLOG.md` tracks which specs are implemented. Check it before assuming a spec is unimplemented,
and check the box there (not in SPECS.md) once a spec is fully done and verified.

A **Claude Design handoff bundle** (project "Luis Brand", imported via the Claude Design connector — see
SPEC-038) has already been applied: `assets/css/tokens.css` and `assets/css/main.css` are real, final CSS,
not placeholders — see "Design tokens" below before writing any template markup.

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

One content type with a strict required-frontmatter contract (see SPEC-008/009 for exact fields):
`content/blog/*.md` (title, date, description required; tags/draft/canonicalURL/images optional).
`archetypes/blog.md` exists so `hugo new blog/<slug>.md` scaffolds it correctly — keep the archetype in sync
if the frontmatter contract changes. No `tags` field — Topics (tags) was removed, see "Site nav" below.

### Design tokens

All visual styling is driven by CSS custom properties in `assets/css/tokens.css` (fonts, fluid `clamp()`
type scale, `--sp-*` spacing, radii, layout widths, motion, theme colors) — see SPEC-012 for the full list.
`assets/css/main.css` consumes these tokens and contains the bundle's complete component CSS (header/nav,
post cards, article/prose, TOC, pagination, footer, about) **already written ahead of the Hugo
templates that will use it** — when implementing a layout/partial, write markup with the classes `main.css`
already defines (e.g. `.post-item`, `.article-layout`, `.toc`) rather than inventing new ones. Both files
were ported from the Claude Design bundle "Luis Brand", not hand-authored — check `tokens.css`/`main.css`
directly for exact variable/class names rather than trusting older SPEC wording that predates the handoff.

**Visual direction:** the bundle offered two directions (A "Essay", centered/serif; B "Ledger", left-aligned
archive). Only **Direction A** was shipped — `main.css` has A's overrides baked in directly (no
`[data-dir]` runtime switching). Don't reintroduce Direction B selectors/markup.

**Dark mode (SPEC-013) is a manual toggle, not OS-driven** — `data-theme="dark"` (default) or `"light"` on
`<html>`, switched by a header button and persisted in `localStorage`. The toggle script lands with the
header partial; it isn't implemented yet even though the CSS for both themes is.

**Site nav has 2 items**: Blog, About. SPEC-003 in `specs/SPECS.md` describes an original 4-item menu (plus
Social Media and Topics) — both were implemented and then deliberately removed by the user (see
`specs/BACKLOG.md` groups 12/16). `specs/SPECS.md` is left as-is per project convention (status/deviations
live in BACKLOG.md only), so don't treat its 4-item menu description as current.

### SEO and head rendering

`partials/head.html` is responsible for canonical URLs (self-permalink fallback when `canonicalURL` is
unset), Open Graph + Twitter Card tags, hreflang alternates for every translation (plus a self-referencing
one), RSS autodiscovery, and JSON-LD `BlogPosting` structured data — the last one only on single blog post
pages, not listings or other sections (SPEC-025 through SPEC-028).

### Analytics

The Umami script is injected only when `params.umami.websiteId` and `params.umami.src` are both set in
`hugo.yaml` — `partials/analytics.html` must no-op otherwise. Outbound/CTA links that should be tracked
carry a `data-umami-event="<descriptive-name>"` attribute (e.g. `click-linkedin-profile`); at minimum this
applies to the footer LinkedIn link and RSS link (SPEC-031).

### Deployment

Push to `main` triggers `.github/workflows/deploy.yml`: install Hugo extended, `hugo --minify`, deploy
`./public` to GitHub Pages. No separate staging environment or PR preview is specified.

## Reference: directory layout (current — not yet fully matching SPEC-002's target tree)

```
├── archetypes/blog.md
├── assets/css/{tokens.css, main.css}
├── content/
│   ├── about/_index.md, _index.en.md
│   └── blog/_index.md, _index.en.md, advogado-a-programador.md (+ .en.md)
├── data/social.yaml
├── i18n/{pt-BR.yaml, en.yaml}
├── layouts/
│   ├── _default/baseof.html
│   ├── about/list.html
│   ├── blog/ (list.html, single.html)
│   ├── partials/ (head.html, header.html, footer.html,
│   │              language-switcher.html, post-meta.html, post-list.html)
│   └── index.html
├── hugo.yaml
└── specs/{SPECS.md, BACKLOG.md}
```

Still missing: `.github/workflows/deploy.yml` (group 17), `static/images/` (logo/favicon/OG image),
`layouts/partials/analytics.html` (group 6).