# Luis Merçon — Personal Blog

A static, bilingual (pt-BR / en) personal blog built with [Hugo](https://gohugo.io) and hosted on
GitHub Pages.

## Stack

- **Hugo** (extended edition, ≥ 0.147) — static site generator
- Vanilla CSS with custom properties — no build step, no framework
- GitHub Pages + GitHub Actions — hosting/CI (deploy workflow not set up yet, see Status below)

## Run locally

Install Hugo (extended edition — required for the asset pipeline used by `assets/css/`):

```bash
winget install Hugo.Hugo.Extended
```

Then from the repo root:

```bash
hugo server
```

This starts a dev server with live reload at **http://localhost:1313/** — edits to content, layouts, or
`assets/css/` are picked up automatically without restarting.

To produce a production build (output to `./public`):

```bash
hugo --minify
```

## Adding content

```bash
# New pt-BR blog post (default language)
hugo new blog/my-post-slug.md

# Its English translation — same base filename, .en suffix
hugo new blog/my-post-slug.en.md
```

The English file needs a `slug:` field in its frontmatter (for a translated, SEO-friendly URL) — see
`specs/SPECS.md` (SPEC-005, SPEC-008, SPEC-009) for the full frontmatter contract. Posts are filed under
`content/blog/`.

Draft posts (`draft: true`, the archetype default) don't appear in `hugo server` or `hugo --minify` unless
you pass `-D`/`--buildDrafts`.

## Project status

This project is being built spec-by-spec. **`specs/SPECS.md`** is the full specification (Given/When/Then
format); **`specs/BACKLOG.md`** tracks exactly which specs are implemented and which aren't — check it
before assuming a feature exists. `CLAUDE.md` has a higher-level architecture summary for anyone (human or
AI) picking up the next round of work.

As of now: the core site (layout, header/footer, theme toggle, homepage, blog listing/post pages, About),
SEO meta tags, full-content RSS, and Umami analytics are implemented and verified. Social Media and Topics
(tags) were built and then deliberately removed — see `specs/BACKLOG.md` groups 12/16. Still open: the
GitHub Actions deploy workflow.
