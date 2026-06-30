#let dot(a, b) = {
  return a.at(0) * b.at(0) + a.at(1) * b.at(1)
}

#let norm(a) = {
  return calc.sqrt(dot(a, a))
}