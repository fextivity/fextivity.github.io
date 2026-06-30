# Fextive Blog

A Typst-based blog built with [tybook](https://codeberg.org/theZoq2/tybook).

## Setup

### Prerequisites
- Typst 0.15 or later (for bundle feature support)
- `utpm` package manager

### Installation

1. Install tybook:
```bash
utpm packages install https://codeberg.org/TheZoq2/tybook.git
```

2. (Optional) For local development with symlinks:
```bash
utpm prj link -n
```

## Building

Compile the full multilingual site to `book/`:
```bash
make build
```

For local preview:

```bash
make preview
```

Then open `http://127.0.0.1:3000/`. The root page redirects to `en/index.html`.

To use a different port:

```bash
make preview PORT=3001
```

For an auto-updating preview while editing `.typ` files:

```bash
make watch
```

This uses Typst's built-in watch server and rebuilds when source files change.

## Project Structure

```
fextive-blog/
├── book.typ           # Multilingual bundle entry point
├── content/           # Blog content files (.typ files)
│   ├── en/            # English pages
│   └── vi/            # Vietnamese pages
├── style/             # Local tybook CSS used by the custom page emitter
├── Makefile           # Build and preview commands
├── typst.toml         # Package configuration
└── README.md          # This file
```

## Adding Content

1. Create a new English `.typ` file in `content/en/`
2. Create its Vietnamese counterpart in `content/vi/`
3. Add both pages to the corresponding section lists in `book.typ`

```typst
#let english-sections = (
  page([Home], "./en/index.typ", "./content/en/index.typ", none, language-link: "../vi/index.html", language-label: [Tiếng Việt]),
  page([My Post], "./en/my-post.typ", "./content/en/my-post.typ", <my-post>, language-link: "../vi/my-post.html", language-label: [Tiếng Việt]),
)

#let vietnamese-sections = (
  page([Trang chủ], "./vi/index.typ", "./content/vi/index.typ", none, language-link: "../en/index.html", language-label: [English]),
  page([Bài viết của tôi], "./vi/my-post.typ", "./content/vi/my-post.typ", <my-post-vi>, language-link: "../en/my-post.html", language-label: [English]),
)
```

The root `book/index.html` is only a redirect to `book/en/index.html`.

## Styling

To add custom CSS, create a CSS file and modify `book.typ` to include it in the config:

```typst
#asset("style.css", read("style.css", encoding: none),) <custom-style>

#let config = (
  page-prelude: {
    link-css(<custom-style>)
  }
)

#emit-book(sections, title: [Your Title], config: config)
```

## Hosting on GitHub Pages

This repository is intended to deploy from source with GitHub Actions. Do not
commit the generated `book/` directory; the workflow builds it and publishes the
result to GitHub Pages.

For the user or organization site, push this repository to:

```bash
https://github.com/fextivity/fextivity.github.io.git
```

In GitHub, configure Pages to use **GitHub Actions** as the source. Each push to
`main` will rebuild and deploy the site.

## Resources

- [Typst Documentation](https://typst.app/docs)
- [tybook Repository](https://codeberg.org/theZoq2/tybook)
- [Typst Community Package Manager (utpm)](https://github.com/typst-community/utpm)
