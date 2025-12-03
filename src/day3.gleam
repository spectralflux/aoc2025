import gleam/int
import gleam/list
import gleam/result.{unwrap}
import gleam/string

pub fn run(inputs: String) -> Nil {
  let part1 =
    inputs
    |> string.split("\n")
    |> list.map(fn(line) { to_jolt_combos(line, 2) })
    |> list.filter(fn(js) { !list.is_empty(js) })
    |> list.fold(0, highest_jolt)

  echo part1

  let part2 =
    inputs
    |> string.split("\n")
    |> list.map(fn(line) { to_jolt_combos(line, 12) })
    |> list.filter(fn(js) { !list.is_empty(js) })
    |> list.fold(0, highest_jolt)

  echo part2
  Nil
}

fn highest_jolt(acc: Int, jolts: List(Int)) -> Int {
  let highest =
    jolts
    |> list.sort(by: int.compare)
    |> list.reverse
    |> list.first
    |> unwrap(0)

  acc + highest
}

fn to_jolt_combos(jolt_s: String, combo_size: Int) -> List(Int) {
  jolt_s
  |> string.to_graphemes()
  |> list.combinations(combo_size)
  |> list.map(fn(digits) {
    let s =
      digits
      |> string.concat
    unwrap(int.parse(s), 0)
  })
}
