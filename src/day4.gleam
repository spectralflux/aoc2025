import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string

type Roll {
  Roll(x: Int, y: Int)
}

pub fn run(inputs: String) {
  inputs
  |> part1()
  |> echo

  inputs
  |> part2()
  |> echo

  Nil
}

fn part1(inputs: String) -> Int {
  let rolls = parse(inputs)

  rolls
  |> set.to_list
  |> list.count(is_accessible(rolls, _))
}

fn part2(inputs: String) -> Int {
  0
}

fn parse(inputs: String) -> Set(Roll) {
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
  |> set.from_list
}

fn is_accessible(inputs, roll) {
  let neighbour_count =
    list.count(get_adjacent_rolls(roll), set.contains(inputs, _))
  neighbour_count < 4
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
