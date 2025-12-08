import gleam/float
import gleam/int
import gleam/list
import gleam/order.{type Order}
import gleam/result
import gleam/set.{type Set}
import gleam/string

pub type Box {
  Box(x: Int, y: Int, z: Int)
}

type Connection {
  Connection(source: Box, dest: Box)
}

type Circuits {
  Circuits(
    available_connections: List(Connection),
    connections: Set(Connection),
    circuits: List(Set(Box)),
  )
}

pub fn run(inputs: String) {
  // let in = parse(sample())
  let in = parse(inputs)

  echo part1(in)
  echo part2(in)

  Nil
}

pub fn parse(input: String) -> List(Box) {
  input
  |> string.split("\n")
  |> list.filter(fn(l) { !string.is_empty(l) })
  |> list.map(fn(line) {
    let assert [x, y, z] =
      string.split(line, ",")
      |> list.map(fn(x) { result.unwrap(int.parse(x), 0) })

    Box(x: x, y: y, z: z)
  })
}

fn euclid_distance_3d(c: Connection) -> Float {
  let delta_x = c.source.x - c.dest.x
  let delta_y = c.source.y - c.dest.y
  let delta_z = c.source.z - c.dest.z

  result.unwrap(
    int.square_root(delta_x * delta_x + delta_y * delta_y + delta_z * delta_z),
    0.0,
  )
}

fn create_circuits(boxes: List(Box)) -> Circuits {
  let available_connections =
    list.combination_pairs(boxes)
    |> list.map(fn(p) { Connection(source: p.0, dest: p.1) })
    |> list.sort(fn(a, b) {
      float.compare(euclid_distance_3d(a), euclid_distance_3d(b))
    })

  let circuits = list.map(boxes, fn(b) { set.insert(set.new(), b) })

  Circuits(
    available_connections: available_connections,
    connections: set.new(),
    circuits: circuits,
  )
}

fn connect_closest(circuits: Circuits) -> #(Connection, Circuits) {
  let Circuits(available_connections:, connections:, ..) = circuits
  let assert [connection, ..available_connections] = available_connections
  let state =
    Circuits(
      available_connections:,
      connections: circuits.connections,
      circuits: circuits.circuits,
    )

  case set.contains(connections, connection) {
    True -> connect_closest(state)
    False -> {
      let connections = set.insert(connections, connection)
      let circuits = case
        list.partition(state.circuits, fn(c) {
          set.contains(c, connection.source) || set.contains(c, connection.dest)
        })
      {
        #([c], circuits) -> [c, ..circuits]
        #([c, d], circuits) -> [set.union(c, d), ..circuits]
        _ -> panic
      }
      let state = Circuits(..state, connections:, circuits:)

      #(connection, state)
    }
  }
}

pub fn part1(boxes: List(Box)) -> Int {
  let num_boxes = list.length(boxes)
  part1_recurse(create_circuits(boxes), num_boxes)
}

fn part1_recurse(circuits: Circuits, connections_left: Int) -> Int {
  case connections_left {
    0 ->
      list.map(circuits.circuits, set.size)
      |> list.sort(inverse_compare_ints)
      |> list.take(3)
      |> int.product
    _ -> {
      part1_recurse(connect_closest(circuits).1, connections_left - 1)
    }
  }
}

// taken from int.compare, just rerversing the a < b case
fn inverse_compare_ints(a, b: Int) -> Order {
  case a == b {
    True -> order.Eq
    False ->
      case a > b {
        True -> order.Lt
        False -> order.Gt
      }
  }
}

pub fn part2(boxes: List(Box)) -> Int {
  part2_recurse(create_circuits(boxes))
}

fn part2_recurse(all_circuits: Circuits) -> Int {
  case connect_closest(all_circuits) {
    // match on circuits length of 1: [_], i.e. we are on the last iteration
    #(Connection(source:, dest:), Circuits(circuits: [_], ..)) ->
      source.x * dest.x

    // else, recurse
    #(_, all_circuits) -> part2_recurse(all_circuits)
  }
}

fn sample() {
  "162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689"
}
