import day3

import simplifile.{read}

fn get_input(filename: String) -> String {
  case read(filename) {
    Ok(contents) -> contents
    Error(_) -> panic
  }
}

pub fn main() -> Nil {
  day3.run(get_input("inputs/3.txt"))
}
