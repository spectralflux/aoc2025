import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

type Tile {
  Tile(x: Int, y: Int)
}

pub fn run(inputs: String) {
  let assert Ok(part1) =
    parse(inputs)
    |> to_areas
    |> list.sort(int.compare)
    |> list.reverse
    |> list.first

  echo part1

  Nil
}

fn parse(inputs: String) -> List(Tile) {
  inputs
  |> string.split("\n")
  |> list.filter(fn(l) { !string.is_empty(l) })
  |> list.map(fn(line) {
    let assert [x, y] =
      string.split(line, ",")
      |> list.map(fn(x) { result.unwrap(int.parse(x), 0) })
    Tile(x:, y:)
  })
}

fn to_areas(tiles: List(Tile)) -> List(Int) {
  tiles
  |> list.combination_pairs
  |> set.from_list
  |> set.map(fn(pair) {
    let dy = int.absolute_value({ pair.1 }.y - { pair.0 }.y) + 1
    let dx = int.absolute_value({ pair.1 }.x - { pair.0 }.x) + 1
    dy * dx
  })
  |> set.to_list
}

fn sample() {
  "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"
}
