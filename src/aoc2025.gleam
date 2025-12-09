import day9

import simplifile.{read}

fn get_input(filename: String) -> String {
  case read(filename) {
    Ok(contents) -> contents
    Error(_) -> panic
  }
}

pub fn main() -> Nil {
  day9.run(get_input("inputs/9.txt"))
}
