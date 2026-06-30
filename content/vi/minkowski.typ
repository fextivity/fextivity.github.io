#import "template.typ": *

#show: article

= Giới thiệu

Chủ đề này đã được giải thích nhiều lần trên Internet, nhưng tôi chưa thấy cách trình bày nào thật sự thỏa đáng. Cụ thể, trên cả #link("https://cp-algorithms.com/geometry/minkowski.html")[CP-Algorithms] và #link("https://wiki.vnoi.info/algo/trick/minkowski-sum")[VNOI Wiki], mệnh đề sau được nêu ra mà không có chứng minh hay trực giác đi kèm:

#quote[Dãy các cạnh của $P + Q$ có thể thu được bằng cách trộn hai dãy cạnh ban đầu theo thứ tự góc cực, đồng thời thay các vector liên tiếp cùng hướng bằng tổng của chúng.]

Trong bài viết này, tôi sẽ cố gắng giải thích cách suy ra kết quả trên, với yêu cầu nền tảng ít nhất có thể.

= Kiến thức chuẩn bị

Trong bài viết này, ta chỉ làm việc trong không gian hai chiều.

- Vector và các phép toán trên vector.

  Cụ thể, bài viết sẽ dùng ký hiệu sau:
  - $norm(p)$ là *độ dài/độ lớn* của vector $p$.

= Hình học cơ bản

== Tích vô hướng

Ta có thể định nghĩa tích vô hướng theo hình học hoặc theo đại số.

#definition[Tích vô hướng - định nghĩa hình học][
  Tích vô hướng của hai vector $p$ và $q$ là tích của độ dài $p$ với độ dài có hướng của hình chiếu của $q$ lên $p$.

  Đặc biệt, tích vô hướng âm khi và chỉ khi $theta$ lớn hơn $90 degree$.

  Vì độ dài có hướng của hình chiếu của $q$ lên $p$ (ký hiệu là $q_p$) là $q_p = norm(q) cos theta$, tích vô hướng theo hình học là
  $ p dot.op_"geo" q = norm(p) norm(q) cos theta $
] <dot_product_geometrical_vi>

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
        lq.line(
          (0, 0), (px, py),
          tip: tiptoe.stealth,
          toe: tiptoe.circle,
        ),
        lq.place(px, py, align: left,
          pad(0.3em)[$p$]
        ),
        lq.line(
          (0, 0), (qx, qy),
          tip: tiptoe.stealth,
          toe: tiptoe.circle,
        ),
        lq.place(qx, qy, align: left,
          pad(0.5em)[$q$]
        ),
        lq.line(
          (qx, qy), (qx, py),
          stroke: (dash: "dashed"),
        ),
        lq.place(qx / 2, py / 2, align: top,
          pad(0.3em)[$norm(q) cos theta$]
        ),
        lq.place(0, 0, cetz.canvas({
          cetz.draw.circle((0, 0), stroke: 0pt)
          cetz.draw.arc((0, 0), anchor: "origin", start: 0deg, delta: calc.atan2(qx, qy), radius: 0.7)
          }
        )),
        lq.place(1.5, 0.7, align: bottom + left,
          [$theta$]
        )
      ),
    ),
    caption: [Minh họa định nghĩa hình học của tích vô hướng],
  )
}

#definition[Tích vô hướng - định nghĩa đại số][
  Tích vô hướng theo đại số của hai vector $p$ và $q$ được định nghĩa là
  $ p dot.op_"alg" q = p_x q_x + p_y q_y $
] <dot_product_algebraic_vi>

#proposition[Tính tương đương của hai định nghĩa tích vô hướng][
  Định nghĩa hình học và định nghĩa đại số của tích vô hướng là tương đương. Nói cách khác, với mọi vector $p$ và $q$,
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
    Bản đồ màu của ánh xạ tích vô hướng $q mapsto p dot.op q$ với $p = (2, 3)$ và $p = (-4, 1)$.
  ],
)

== Tích có hướng

== Tính lồi
