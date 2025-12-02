import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

type ID {
  ID(code: String, val: Int)
}

pub fn run(inputs: String) -> Nil {
  io.println("part 1:")
  let ranges = part1(inputs)
  echo ranges

  Nil
}

fn part1(inputs: String) -> Int {
  let nums =
    inputs
    |> string.trim()
    |> string.split(",")
    |> list.flat_map(fn(s) { string.split(s, "-") })
    |> list.sized_chunk(into: 2)
    |> list.map(fn(a) {
      let start = result.unwrap(list.first(a), "")
      let end = result.unwrap(list.last(a), "")
      to_range(#(start, end))
    })
    |> list.flatten
    |> list.fold(0, has_repeats)
}

fn to_range(in: #(String, String)) {
  let start_n = result.unwrap(int.parse(pair.first(in)), 0)
  let end_n = result.unwrap(int.parse(pair.second(in)), 0)
  build_range(end_n - start_n, start_n, [])
  |> list.map(to_id)
}

fn build_range(deacc: Int, next: Int, out: List(Int)) -> List(Int) {
  case { deacc >= 0 } {
    False -> out
    True -> build_range(deacc - 1, next + 1, [next, ..out])
  }
}

fn to_id(in: Int) -> ID {
  ID(int.to_string(in), in)
}

fn has_repeats(acc: Int, code: ID) -> Int {
  let len = string.length(code.code)
  let half = len / 2
  let start = string.slice(code.code, 0, half)
  let end = string.slice(code.code, half, len - 1)

  case len {
    1 -> acc
    _ ->
      case string.contains(start, end) {
        False -> acc
        True -> acc + code.val
      }
  }
}
