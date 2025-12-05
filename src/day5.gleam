import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

type Range {
  Range(start: Int, end: Int)
}

pub fn run(inputs: String) {
  //let #(ranges, items) = parse(sample())
  let #(ranges, items) = parse(inputs)

  // part 1
  items
  |> list.count(fn(i) { is_fresh(i, ranges) })
  |> echo

  Nil
}

fn is_fresh(n: Int, ranges: List(Range)) -> Bool {
  ranges
  |> list.any(fn(range) { n >= range.start && n <= range.end })
}

fn parse(inputs: String) {
  let assert Ok(#(ranges, items)) =
    inputs
    |> string.split_once("\n\n")

  #(parse_ranges(ranges), parse_items(items))
}

fn parse_ranges(ranges: String) {
  ranges
  |> string.split("\n")
  |> list.map(fn(s) { string.split(s, "-") })
  |> list.map(fn(r) {
    let assert Ok(start) = int.parse(result.unwrap(list.first(r), ""))
    let assert Ok(end) = int.parse(result.unwrap(list.last(r), ""))
    Range(start, end)
  })
}

fn parse_items(items: String) {
  items
  |> string.split("\n")
  |> list.map(fn(n) { result.unwrap(int.parse(n), 0) })
}

fn sample() -> String {
  "3-5
10-14
16-20
12-18

1
5
8
11
17
32"
}
