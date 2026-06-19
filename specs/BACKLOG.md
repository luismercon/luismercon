# Backlog

Tracks implementation status of each spec in [SPECS.md](SPECS.md). SPECS.md is the source of truth for
*what* each spec requires — this file only tracks *whether it's done*. Check a box when the spec is fully
implemented and verified against its Given/When/Then criteria. Don't edit SPECS.md to reflect status.

## 1. Project init, structure, config
- [x] [SPEC-001 — Hugo Project Initialization](SPECS.md#spec-001) — `hugo.yaml` builds clean with `hugo --minify`
- [ ] [SPEC-002 — Directory Structure](SPECS.md#spec-002) — `content/`, `layouts/`, `assets/css/`, `archetypes/`, `i18n/` now exist; favicon/og-default images are generated via Hugo Pipes from `assets/images/favicon.png` (no `static/images/`, no `logo.svg`/`favicon.ico` — see CLAUDE.md/head.html) ; `.github/workflows/` still missing (group 17)
- [x] [SPEC-003 — Permalink Configuration](SPECS.md#spec-003) — permalinks + 4-item main menu (incl. Topics, see SPEC-040) set in `hugo.yaml`

## 2. Design tokens, dark mode, fonts
- [x] [SPEC-012 — CSS Design Tokens](SPECS.md#spec-012) — `assets/css/tokens.css` ported from the Claude Design bundle ("Luis Brand"); `assets/css/main.css` also written (Direction A "Essay" baked in)
- [x] [SPEC-013 — Theme Toggle (Dark/Light)](SPECS.md#spec-013) — toggle button in header + inline script in `head.html`/`baseof.html`; verified default dark, no FOUC on stored "light" preference
- [x] [SPEC-014 — Font Loading](SPECS.md#spec-014) — Google Fonts `<link>` tags (preconnect + CSS2 `display=swap`) wired into `layouts/partials/head.html`; verified in rendered output

## 3. Base layout
- [x] [SPEC-015 — Base Layout](SPECS.md#spec-015) — `layouts/_default/baseof.html` + partials; `hugo --minify` builds clean, dev server verified via curl

## 4. SEO (head.html)
- [x] [SPEC-025 — Canonical URLs](SPECS.md#spec-025) — `<link rel="canonical">` in `layouts/partials/head.html`, falls back to `.Permalink` when `canonicalURL` is unset
- [x] [SPEC-026 — Meta Tags and Open Graph](SPECS.md#spec-026) — OG + Twitter Card tags in `head.html`; `og:image` falls back to a Hugo Pipes-generated 1200x630 crop of `assets/images/favicon.png` when no page `images` are set
- [x] [SPEC-027 — Hreflang Tags](SPECS.md#spec-027) — loops `.AllTranslations` (self-referencing tag included); verified pt-br/en pair on the sample post
- [x] [SPEC-028 — Structured Data (JSON-LD)](SPECS.md#spec-028) — `BlogPosting` block only on single blog posts, built via `dict`/`jsonify`/`safeJS` (plain string interpolation inside `<script>` double-escapes under Hugo's contextual auto-escaping — verified and fixed)

## 5. RSS
- [ ] [SPEC-029 — RSS Feed](SPECS.md#spec-029) — Hugo's default RSS output works (`/blog/index.xml` verified 200), but doesn't yet include full `content:encoded` per spec — needs a custom RSS template

## 6. Analytics
- [ ] [SPEC-030 — Umami Analytics Script](SPECS.md#spec-030) — no Umami account/website ID yet; `partials/analytics.html` not created
- [ ] [SPEC-031 — Analytics Event Tracking](SPECS.md#spec-031) — `data-umami-event` already added to footer LinkedIn/RSS links and the About page LinkedIn link, ahead of SPEC-030; social-media-post tracking pending group 12

## 7. Header, mobile menu, language switcher
- [x] [SPEC-016 — Header (Desktop)](SPECS.md#spec-016) — `layouts/partials/header.html`
- [x] [SPEC-017 — Header (Mobile)](SPECS.md#spec-017) — hamburger + drawer, toggled by inline script in `baseof.html`
- [x] [SPEC-007 — Language Switcher](SPECS.md#spec-007) — `layouts/partials/language-switcher.html`; verified `/en/...` translation link renders

## 8. Footer
- [x] [SPEC-018 — Footer](SPECS.md#spec-018) — `layouts/partials/footer.html`; LinkedIn (from `data/social.yaml`) + RSS link with icon, copyright line

## 9. i18n wiring
- [x] [SPEC-004 — Filename-Based i18n Strategy](SPECS.md#spec-004) — verified `/en/blog/on-refactoring-systems-you-inherit/` resolves as the translation
- [x] [SPEC-005 — Translated Slugs for SEO](SPECS.md#spec-005) — English post overrides `slug`, pt-br keeps filename-derived slug
- [x] [SPEC-006 — UI String Translations](SPECS.md#spec-006) — `i18n/pt-BR.yaml` + `i18n/en.yaml`

## 10. Content models and archetypes
- [x] [SPEC-008 — Blog Post Content Model (pt-BR)](SPECS.md#spec-008) — real post matches the contract
- [x] [SPEC-009 — Blog Post Content Model (English)](SPECS.md#spec-009) — real `.en.md` translation with `slug` override
- [x] [SPEC-010 — Social Media Embed Content Model](SPECS.md#spec-010) — model encoded in `archetypes/socialmedia.md`; no actual post authored yet (group 18)
- [x] [SPEC-011 — Content Archetypes](SPECS.md#spec-011) — `archetypes/blog.md` + `archetypes/socialmedia.md`

## 11. Blog templates
- [x] [SPEC-020 — Blog Listing Page](SPECS.md#spec-020) — `layouts/blog/list.html`, reuses `partials/post-list.html`
- [x] [SPEC-021 — Blog Post Page](SPECS.md#spec-021) — `layouts/blog/single.html`; TOC via `.Fragments.Headings` (new scope from the handoff, see CLAUDE.md)

## 12. Social media templates
- [ ] [SPEC-022 — Social Media Listing Page](SPECS.md#spec-022) — not in the Claude Design bundle; still needs its own design pass
- [ ] [SPEC-023 — Social Media Embed Page](SPECS.md#spec-023)

## 13. About page
- [x] [SPEC-024 — About Page](SPECS.md#spec-024) — `layouts/about/list.html` (monogram, facts list); content in `content/about/_index.md` + `_index.en.md`

## 14. Homepage
- [x] [SPEC-019 — Homepage](SPECS.md#spec-019) — `layouts/index.html`, pulls posts via `site.GetPage "/blog"`

## 15. Responsive breakpoints
- [ ] [SPEC-032 — Responsive Layout: Mobile](SPECS.md#spec-032) — `main.css` is fluid/`clamp()`-based rather than the original fixed-padding scheme; behavior not yet verified visually at each breakpoint (no screenshot tooling available this session)
- [ ] [SPEC-033 — Responsive Layout: Tablet](SPECS.md#spec-033) — same caveat
- [ ] [SPEC-034 — Responsive Layout: Desktop](SPECS.md#spec-034) — same caveat

## 16. Topics (tags) taxonomy
- [x] [SPEC-040 — Topics (Tags) Taxonomy Pages](SPECS.md#spec-040) — `layouts/_default/taxonomy.html` + `term.html`; verified both tags render with correct counts

## 17. Deployment
- [ ] [SPEC-035 — GitHub Actions Deployment](SPECS.md#spec-035)

## 18. Sample content
- [x] One bilingual blog post (pt-BR + en, see SPEC-008/SPEC-009) — "Sobre Refatorar Sistemas que Herdamos" / "On Refactoring Systems You Inherit"
- [ ] One social media embed (see SPEC-010)

## 19. Final validation
- [ ] Lighthouse audit
- [ ] Open Graph debugger
- [ ] RSS validator

## Reference & process specs
Not part of the numbered build sequence — describe ongoing author workflows and project docs rather than a
one-time build artifact. Check off once the workflow has been exercised at least once / the doc exists.
- [x] [SPEC-039 — CLAUDE.md Project File](SPECS.md#spec-039) — done, `CLAUDE.md` exists at repo root
- [ ] [SPEC-036 — Blog Post Publication Workflow](SPECS.md#spec-036)
- [ ] [SPEC-037 — Social Media Publication Workflow](SPECS.md#spec-037)
- [x] [SPEC-038 — Claude Design Handoff Workflow](SPECS.md#spec-038) — exercised end-to-end: imported project "Luis Brand" via the Claude Design connector, tokens translated into `assets/css/`, templates built following the bundle
