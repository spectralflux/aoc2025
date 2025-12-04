import gleam/list
import gleam/result
import gleam/string

type Roll {
  Roll(x: Int, y: Int)
}

pub fn run(inputs: String) {
  inputs
  |> part1()
  |> echo

  Nil
}

fn part1(inputs: String) -> Int {
  let rolls = parse(inputs)

  rolls
  |> list.count(is_accessible(rolls, _))
}

fn parse(inputs: String) -> List(Roll) {
  let rows =
    inputs
    |> string.split("\n")

  list.index_map(rows, fn(row, y) {
    let points = row |> string.to_graphemes()
    list.index_map(points, fn(point, x) {
      case point {
        "@" -> Ok(Roll(x, y))
        "." -> Error(Nil)
        _ -> panic
      }
    })
  })
  |> list.flatten
  |> list.filter(result.is_ok)
  |> list.map(fn(n) { result.unwrap(n, Roll(0, 0)) })
}

fn is_accessible(inputs, roll) {
  list.count(get_adjacent_rolls(roll), list.contains(inputs, _)) < 4
}

fn get_adjacent_rolls(roll) {
  let Roll(x, y) = roll
  [
    Roll(x - 1, y - 1),
    Roll(x + 0, y - 1),
    Roll(x + 1, y - 1),
    Roll(x - 1, y + 0),
    Roll(x + 1, y + 0),
    Roll(x - 1, y + 1),
    Roll(x + 0, y + 1),
    Roll(x + 1, y + 1),
  ]
}

fn sample() -> String {
  "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."
}
