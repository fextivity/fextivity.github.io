#import "@preview/cetz:0.5.2" as cetz
#import "@preview/frame-it:1.2.0": frames, frame-style
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/tiptoe:0.4.0" as tiptoe
#import "../../calculation.typ" as calculation

#let (
  definition,
  theorem,
  proposition,
  corollary,
  proof,
) = frames(
  definition: ("Định nghĩa", lq.color.map.petroff6.at(0).lighten(60%).desaturate(40%)),
  theorem: ("Định lý", lq.color.map.petroff6.at(1).lighten(60%).desaturate(40%)),
  proposition: ("Mệnh đề", lq.color.map.petroff6.at(1).lighten(60%).desaturate(40%)),
  corollary: ("Hệ quả", lq.color.map.petroff6.at(1).lighten(60%).desaturate(40%)),
  proof: ("Chứng minh", lq.color.map.petroff6.at(5).lighten(65%).desaturate(45%)),
)

#let blog-frame-style(title, tags, body, supplement, number, accent-color) = {
  let accent = accent-color.to-hex()
  let has-title = title not in ([], "", none)

  html.elem(
    "section",
    attrs: (
      class: "article-frame",
      style: "border-left: 4px solid " + accent + "; padding: 0.8rem 1rem; margin: 1rem 0;",
    ),
    {
      html.elem(
        "header",
        attrs: (
          style: "display: flex; justify-content: space-between; gap: 1rem; color: " + accent + "; font-weight: 700;",
        ),
        {
          if has-title {
            html.strong(title)
          }
          html.span[#supplement #number]
        },
      )
      html.elem("div", attrs: (style: "margin-top: 0.5rem;"), body)
    },
  )
}

#let article(body) = {
  show: frame-style(blog-frame-style)
  set figure(supplement: [Hình])
  body
}
