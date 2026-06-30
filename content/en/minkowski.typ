#import "template.typ": *

#show: article

= Introduction

This topic has been explained many times on the Internet, but I find none quite satisfactory. In particular, on both #link("https://cp-algorithms.com/geometry/minkowski.html")[CP-Algorithms] and #link("https://wiki.vnoi.info/algo/trick/minkowski-sum")[VNOI Wiki], the following statement is given without any proof or intuition given:

#quote[The sequence of edges of $P + Q$ can be obtained by merging these two sequences preserving polar angle order and replacing consecutive co-directed vectors with their sum.]

In this article, I will try to explain how to derive the above result, while requiring as little background as possible.

= Prerequisite

In this article, we will only work with two-dimensional space.

- Vector, operations on vector.

  Specifically, the following notation(s) will be used in the article:
  - $norm(p)$ denotes the *length/magnitude* of the vector $p$.

= Basic geometry

== Dot product

We can define dot product either geometrically or algebraically.

#definition[Dot product - geometric][
  The dot product of two vectors $p$ and $q$ is the product of the length of $p$ multiplied with the (directed) length of the projection of $q$ onto $p$.
  
  In particular, the dot product is negative iff $theta$ is greater than $90 degree$.

  As the directed length of the projection of $q$ onto $p$ (denoted $q_p$) is $q_p = norm(q) cos theta$, the (geometrical) dot product is
  $ p dot.op_"geo" q = norm(p) norm(q) cos theta $
] <dot_product_geometrical>

#{
  let (px, py) = (6, 0)
  let (qx, qy) = (4, 5)
  
  figure(
    box(
      fill: white,
      inset: 0.65em,
      lq.diagram(
        aspect-ratio: 1,
        height: 4cm, width: auto,
        fill: white,
        margin: 20%,
        xaxis: (ticks: none),
        yaxis: (ticks: none),
        // p
        lq.line(
          (0, 0), (px, py),
          tip: tiptoe.stealth,
          toe: tiptoe.circle,
        ),
        lq.place(px, py, align: left,
          pad(0.3em)[$p$]
        ),
        // q
        lq.line(
          (0, 0), (qx, qy),
          tip: tiptoe.stealth,
          toe: tiptoe.circle,
        ),
        lq.place(qx, qy, align: left,
          pad(0.5em)[$q$]
        ),
        // projectino of q to p
        lq.line(
          (qx, qy), (qx, py),
          stroke: (dash: "dashed"),
        ),
        lq.place(qx / 2, py / 2, align: top,
          pad(0.3em)[$norm(q) cos theta$]
        ),
        // theta
        lq.place(0, 0, cetz.canvas({
          cetz.draw.circle((0, 0), stroke: 0pt) // Positioning hack.
          cetz.draw.arc((0, 0), anchor: "origin", start: 0deg, delta: calc.atan2(qx, qy), radius: 0.7)
          }
        )),
        lq.place(1.5, 0.7, align: bottom + left,
          [$theta$]
        )
      ),
    ),
    caption: [Illustration of the geometric dot product],
  )
}

#definition[Dot product - algebraic][
  The (algebraic) dot product of two vectors $p$ and $q$ is defined as
  $ p dot.op_"alg" q = p_x q_x + p_y q_y $
] <dot_product_algebraic>



#proposition[Equivalence of definitions of dot product][
  The geometrical and algebraic definition of dot product are equivalent. In other words, for every vector $p$ and $q$,
  $ p dot.op_"geo" q = p dot.op_"alg" q $
]

#proof[][

]

#let dot-product-contour(px, py) = {
  let x = lq.linspace(-6, 6, num: 50)
  let y = lq.linspace(-6, 6, num: 30)
  let z-bound = 6 * (calc.abs(px) + calc.abs(py))

  return box(
    fill: white,
    inset: 0.65em,
    lq.diagram(
      width: 5cm, height: 5cm,
      xlim: (-6, 6),
      ylim: (-6, 6),
      fill: white,
      lq.contour(
        x,
        y,
        (x, y) => calculation.dot((px, py), (x, y)),
        levels: lq.linspace(-z-bound, z-bound, num: 140),
        fill: true,
      ),
      lq.line(
        (0, 0), (px, py),
        tip: tiptoe.stealth,
        toe: tiptoe.circle,
      ),
      lq.place(0, 0, align: top, pad(.5em)[$p = (#px, #py)$])
    ),
  )
}

#figure(
  html.elem(
    "div",
    attrs: (
      style: "display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1rem; align-items: start; padding: 1rem; overflow-x: auto;",
    ),
    {
      html.elem(
        "div",
        attrs: (style: "display: flex; justify-content: center;"),
        html.elem(
          "div",
          attrs: (style: "background: white; color: black; padding: 0.65rem; display: inline-block;"),
          dot-product-contour(2, 3),
        ),
      )
      html.elem(
        "div",
        attrs: (style: "display: flex; justify-content: center;"),
        html.elem(
          "div",
          attrs: (style: "background: white; color: black; padding: 0.65rem; display: inline-block;"),
          dot-product-contour(-4, 1),
        ),
      )
    },
  ),
  caption: [
    A colormap of the dot product mapping $q mapsto p dot.op q$ for $p = (2, 3)$ and $p = (-4, 1)$.
  ],
)

== Cross product

== Convexity

