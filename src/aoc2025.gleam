import day4

import simplifile.{read}

fn get_input(filename: String) -> String {
  case read(filename) {
    Ok(contents) -> contents
    Error(_) -> panic
  }
}

pub fn main() -> Nil {
  day4.run(get_input("inputs/4.txt"))
}
