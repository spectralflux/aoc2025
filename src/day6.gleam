import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub type Operator {
  Plus
  Mult
}

pub type Problem {
  Problem(nums: List(Int), operator: Operator)
}

pub fn run(inputs: String) {
  // let problems = parse(sample())
  let problems = parse(inputs)

  echo part1(problems)

  Nil
}

fn part1(problems: List(Problem)) -> Int {
  problems
  |> list.fold(0, fold_solve_problem)
}

fn fold_solve_problem(acc: Int, problem: Problem) -> Int {
  let answer = case problem.operator {
    Plus -> list.fold(problem.nums, 0, int.add)
    Mult -> list.fold(problem.nums, 1, int.multiply)
  }

  answer + acc
}

fn parse(inputs: String) -> List(Problem) {
  let assert Ok(lines) =
    inputs
    |> string.split("\n")
    |> list.reverse
    |> list.rest

  let assert Ok(ops) = list.first(lines)
  let problems = ops |> build_problems
  let assert Ok(raw_vals) = list.rest(lines)

  let final_problems =
    raw_vals
    |> list.fold(problems, fn(probs, line) {
      line
      |> string.split(" ")
      |> list.filter(fn(s) { !string.is_empty(s) })
      |> list.index_fold(probs, fn(acc, val, i) {
        let assert Ok(num) = int.parse(val)
        dict.upsert(acc, i, fn(existing) {
          case existing {
            Some(Problem(nums, op)) -> Problem([num, ..nums], op)
            None -> panic
          }
        })
      })
    })

  final_problems
  |> dict.values
}

fn build_problems(ops_raw: String) {
  ops_raw
  |> string.split(" ")
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.index_map(fn(o, i) {
    let op = case o {
      "+" -> Plus
      "*" -> Mult
      _ -> panic
    }
    #(i, Problem([], op))
  })
  |> dict.from_list
}

fn sample() {
  "123 328  51 64
45 64  387 23
6 98  215 314
*   +   *   +
"
}
