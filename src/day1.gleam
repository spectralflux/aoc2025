import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

fn modulo(a: Int, b: Int) -> Int {
  case int.modulo(a, b) {
    Ok(res) -> res
    Error(_) -> panic
  }
}

pub fn run(input: String) {
  let scrubbed_inputs =
    input
    |> string.split("\n")
    |> list.filter(fn(line) { line != "" })

  let part1 =
    scrubbed_inputs
    |> list.fold(#(50, 0), fn(pair, turn) {
      let #(dial, count) = pair
      turn_lock(turn, dial, count)
    })
    |> pair.second

  io.println("part 1:")
  echo part1

  let part2 =
    scrubbed_inputs
    |> list.fold(#(50, 0), fn(pair, turn) {
      let #(dial, count) = pair
      turn_lock_pt2(turn, dial, count)
    })
    |> pair.second

  io.println("part 2:")
  echo part2

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

fn turn_lock_pt2(turn: String, dial: Int, count: Int) -> #(Int, Int) {
  let increment = case turn {
    "L" <> n -> result.unwrap(int.parse(n), 0)
    "R" <> n -> -result.unwrap(int.parse(n), 0)
    _ -> panic
  }

  let new_value = modulo(dial + increment, 100)
  let full_turns = int.absolute_value(increment) / 100

  let add_one_turn =
    new_value == 0
    || { increment > 0 && dial + modulo(increment, 100) >= 100 }
    || {
      dial != 0
      && increment < 0
      && dial - modulo(int.absolute_value(increment), 100) <= 0
    }

  let turns = case add_one_turn {
    True -> full_turns + 1
    False -> full_turns
  }

  #(new_value, count + turns)
}
