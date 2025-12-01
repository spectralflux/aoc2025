import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

import simplifile.{read}

fn get_input(filename: String) -> String {
  case read(filename) {
    Ok(contents) -> contents
    Error(_) -> panic
  }
}

fn modulo(a: Int, b: Int) -> Int {
  case int.modulo(a, b) {
    Ok(res) -> res
    Error(_) -> panic
  }
}

pub fn main() -> Nil {
  let input = get_input("inputs/1.txt")

  let part1 =
    input
    |> string.split("\n")
    |> list.filter(fn(line) { line != "" })
    |> list.fold(#(50, 0), fn(pair, turn) {
      let #(dial, count) = pair
      turn_lock(turn, dial, count)
    })
    |> pair.second

  io.println("part 1:")
  echo part1

  Nil
}

fn turn_lock(turn: String, dial: Int, count: Int) -> #(Int, Int) {
  let increment = case turn {
    "L" <> n -> result.unwrap(int.parse(n), 0)
    "R" <> n -> -result.unwrap(int.parse(n), 0)
    _ -> panic
  }

  let new_value = modulo(dial + increment, 100)

  let count = case new_value {
    0 -> count + 1
    _ -> count
  }

  #(new_value, count)
}
