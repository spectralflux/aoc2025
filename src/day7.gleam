import gleam/list
import gleam/set.{type Set}
import gleam/string

pub fn run(inputs: String) {
  //let in = parse(sample())
  let in = parse(inputs)

  echo part1(in)

  Nil
}

fn parse(inputs: String) -> #(Set(Int), List(Set(Int))) {
  let assert [beam_pos, ..splitter_pos] =
    inputs
    |> string.split("\n")
    |> list.filter(fn(l) { !string.is_empty(l) })
    |> list.map(string.to_graphemes)
    |> list.map(fn(line) {
      line
      |> list.index_fold([], fn(acc, p, i) {
        case p == "." {
          False -> [i, ..acc]
          True -> acc
        }
      })
      |> set.from_list
    })
    |> list.filter(fn(s) { !set.is_empty(s) })

  #(beam_pos, splitter_pos)
}

fn part1(input: #(Set(Int), List(Set(Int)))) -> Int {
  let #(beam_pos, splitter_pos) = input

  let num_collisions =
    splitter_pos
    |> list.fold(#(beam_pos, 0), fn(acc, splits) {
      let #(beams, collisions) = acc
      let new_collisions = set.intersection(beams, splits)

      let new_beams =
        beams
        |> set.difference(splits)
        |> set.union(set.map(new_collisions, fn(c) { c + 1 }))
        |> set.union(set.map(new_collisions, fn(c) { c - 1 }))

      #(new_beams, collisions + set.size(new_collisions))
    })

  num_collisions.1
}

fn sample() {
  ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."
}
