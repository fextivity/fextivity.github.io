#import "@local/tybook:0.1.0": book-mandatory-style, link-css, section, sidebar

#show: book-mandatory-style

#let section-label(section) = {
  if section.label != none {
    section.label
  } else {
    label(section.filename)
  }
}

#let page(title, output, source, label, language-link: none, language-label: none, sub: ()) = {
  section(title, output, include source, label, sub: sub) + (
    language-link: language-link,
    language-label: language-label,
  )
}

#let with-footnotes(body) = {
  let footnotes = state("footnotes", ())
  footnotes.update(())

  show footnote: it => context {
    let idx = footnotes.get().len() + 1
    footnotes.update(f => (..f, it))
    super(html.a(id: "footnote-back-" + str(idx), href: "#footnote-" + str(idx), str(idx)))
  }

  body

  context {
    let footnotes = footnotes.get()

    if footnotes.len() > 0 {
      divider()
      html.ol(
        class: "footnote-definition",
        footnotes.enumerate().map(((i, footnote)) => {
          let idx = i + 1
          html.li(
            id: "footnote-" + str(idx),
            [#footnote.body #html.a(href: "#footnote-back-" + str(idx), sym.arrow.l.hook)],
          )
        }).join(),
      )
    }
  }
}

#let language-switch(section) = {
  if section.language-link != none {
    html.elem(
      "nav",
      attrs: (
        class: "language-switch",
        style: "display: flex; align-items: center; padding: 0 0.75em; font-size: 0.65em; white-space: nowrap;",
      ),
      html.a(
        href: section.language-link,
        style: "display: inline-block; padding: 0.25rem 0.6rem; border: 1px solid currentColor; border-radius: 4px;",
        section.language-label,
      ),
    )
  }
}

#let book-page(prev-section, section, next-section, sidebar, book-title: none, config: none) = {
  html.html({
    html.head({
      html.meta(charset: "utf-8")
      if book-title != none {
        html.title([#section.title - #book-title])
      } else {
        html.title(section.title)
      }
      link-css(<tybook:main-css>)
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      config.page-prelude
    });

    html.body({
      sidebar(section.filename)

      html.div(class: "menu-bar", {
        html.elem("label", attrs: (class: "clickable sidebar-button-wide", "for": "sidebar-visible-wide"), [☰])
        html.elem("label", attrs: (class: "clickable sidebar-button-slim", "for": "sidebar-visible-slim"), [☰])
        html.h1(book-title)
        language-switch(section)
      })

      html.main({
        html.div(class: "content", {
          show: with-footnotes
          section.content
        })
      })

      html.nav(
        class: "nav-buttons",
        {
          if prev-section != none {
            link(section-label(prev-section))[
              #html.span(class: "button-icon", sym.chevron.l)
              #html.span(class: "button-title", prev-section.title)
              #html.span(class: "button-subtitle", [Previous page])
            ]
          }
          html.div(class: "spacer")
          if next-section != none {
            link(section-label(next-section))[
              #html.span(class: "button-icon", sym.chevron.r)
              #html.span(class: "button-title", next-section.title)
              #html.span(class: "button-subtitle", [Next page])
            ]
          }
        }
      )
    })
  })
}

#let get-content-sections(sections) = {
  sections
    .filter((s) => s.kind == "section")
    .map((s) => (s,) + if s.sub != none { get-content-sections(s.sub) } else { () })
    .flatten()
}

#let emit-pages-with-language(sidebar, sections, book-title: none, config: (page-prelude: none)) = {
  let sections = get-content-sections(sections)
  let prev-sections = (none,) + sections
  let next-sections = if sections.len() > 1 { sections.slice(1) + (none,) } else { (none,) }

  for (prev, section, next) in prev-sections.zip(sections, next-sections) {
    let output-filename = section.filename.replace(".typ", ".html")
    let page = book-page(prev, section, next, sidebar, book-title: book-title, config: config)

    [#document(output-filename, page) #section-label(section)]
  }
}

#let english-sections = (
  page([Home], "./en/index.typ", "./content/en/index.typ", none, language-link: "../vi/index.html", language-label: [Tiếng Việt]),

  (kind: "chapter", title: [Minkowski sum]),
  page([Minkowski sum], "./en/minkowski.typ", "./content/en/minkowski.typ", none, language-link: "../vi/minkowski.html", language-label: [Tiếng Việt]),
)

#let vietnamese-sections = (
  page([Trang chủ], "./vi/index.typ", "./content/vi/index.typ", none, language-link: "../en/index.html", language-label: [English]),

  (kind: "chapter", title: [Tổng Minkowski]),
  page([Tổng Minkowski], "./vi/minkowski.typ", "./content/vi/minkowski.typ", none, language-link: "../en/minkowski.html", language-label: [English]),
)

#document(
  "index.html",
  html.html({
    html.head({
      html.meta(charset: "utf-8")
      html.title([Fextive Blog])
      html.elem("meta", attrs: ("http-equiv": "refresh", content: "0; url=en/index.html"))
      html.elem("link", attrs: (rel: "canonical", href: "en/index.html"))
    })
    html.body({
      html.p[
        Redirecting to #html.a(href: "en/index.html")[English].
      ]
    })
  }),
)

#asset("style/style.css", read("style/style.css", encoding: none)) <tybook:main-css>
#emit-pages-with-language(sidebar(english-sections), english-sections, book-title: [Fextive Blog])
#emit-pages-with-language(sidebar(vietnamese-sections), vietnamese-sections, book-title: [Fextive Blog])
