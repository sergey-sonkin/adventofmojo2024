from collections import Dict, Set
from testing import assert_equal


fn read_file[filename: String]() raises -> List[String]:
    with open(filename, "r") as file:
        lines = file.read().splitlines()
    return lines


fn process_lines(input: List[String]) -> Dict[String, List[Tuple[Int, Int]]]:
    var char_dict = Dict[String, List[Tuple[Int, Int]]]()
    var line_number = 0
    for line in input:
        char_number = 0
        for char in line[]:
            if char != ".":
                var new_tuple = List[Tuple[Int, Int]](
                    (line_number, char_number)
                )
                var curr_value: List[Tuple[Int, Int]] = char_dict.get(
                    char, List[Tuple[Int, Int]]()
                )
                char_dict[char] = curr_value + new_tuple
            char_number += 1
        line_number += 1
    return char_dict


fn test_process_lines() raises:
    var test_1 = List[String]("...#......")
    var resu_1 = process_lines(test_1)
    # print(resu_1.__str__())


fn print_tuple(tuple: Tuple[Int, Int], msg: String = ""):
    print(msg, tuple.get[0, Int](), tuple.get[1, Int]())


fn is_valid_antinode(
    antinode: Tuple[Int, Int], num_lines: Int, num_chars: Int
) -> Bool:
    return (
        0 <= antinode.get[0, Int]() < num_lines
        and 0 <= antinode.get[1, Int]() < num_chars
    )


fn calculate_antinodes_a[
    debug: Bool
](
    dic: Dict[String, List[Tuple[Int, Int]]], num_lines: Int, num_chars: Int
) -> Int:
    valid_anti_node_locations = Set[Int]()
    # dict_item_ref[]: Dict[String, List[Tuple[Int, Int]]]
    for dict_item_ref in dic.items():
        char = dict_item_ref[].key
        list_positions = dict_item_ref[].value
        num_positions = len(list_positions)
        if debug:
            print(char)
        for ii in range(num_positions):
            for jj in range(ii + 1, num_positions):
                tuple1 = list_positions[ii]
                tuple2 = list_positions[jj]
                if debug:
                    print_tuple(tuple1, "Tuple 1:")
                    print_tuple(tuple2, "Tuple 2:")
                x_coord_diff = tuple2.get[0, Int]() - tuple1.get[0, Int]()
                y_coord_diff = tuple2.get[1, Int]() - tuple1.get[1, Int]()
                antinode_1 = Tuple[Int, Int](
                    tuple2.get[0, Int]() + x_coord_diff,
                    tuple2.get[1, Int]() + y_coord_diff,
                )
                antinode_2 = Tuple[Int, Int](
                    tuple1.get[0, Int]() - x_coord_diff,
                    tuple1.get[1, Int]() - y_coord_diff,
                )
                if first_is_valid := is_valid_antinode(
                    antinode_1, num_lines, num_chars
                ):
                    pos = (
                        antinode_1.get[0, Int]() * num_chars
                        + antinode_1.get[1, Int]()
                    )
                    valid_anti_node_locations.add(pos)
                if second_is_valid := is_valid_antinode(
                    antinode_2, num_lines, num_chars
                ):
                    pos = (
                        antinode_2.get[0, Int]() * num_chars
                        + antinode_2.get[1, Int]()
                    )
                    valid_anti_node_locations.add(pos)
                if debug:
                    print_tuple(antinode_1, "Antinode 1:" + str(first_is_valid))
                    print_tuple(
                        antinode_2, "Antinode 2:" + str(second_is_valid)
                    )
                    print()
    return len(valid_anti_node_locations)


fn calculate_antinodes_b[
    debug: Bool
](
    dic: Dict[String, List[Tuple[Int, Int]]], num_lines: Int, num_chars: Int
) -> Int:
    valid_anti_node_locations = Set[Int]()
    # dict_item_ref[]: Dict[String, List[Tuple[Int, Int]]]
    for dict_item_ref in dic.items():
        char = dict_item_ref[].key
        list_positions = dict_item_ref[].value
        num_positions = len(list_positions)
        if debug:
            print(char)
        for ii in range(num_positions):
            for jj in range(ii + 1, num_positions):
                tuple1 = list_positions[ii]
                tuple2 = list_positions[jj]
                if debug:
                    print_tuple(tuple1, "Tuple 1:")
                    print_tuple(tuple2, "Tuple 2:")
                x_coord_diff = tuple2.get[0, Int]() - tuple1.get[0, Int]()
                y_coord_diff = tuple2.get[1, Int]() - tuple1.get[1, Int]()
                # Direction 1
                # antinode_1 = Tuple[Int, Int](
                #     tuple2.get[0, Int]() + x_coord_diff,
                #     tuple2.get[1, Int]() + y_coord_diff,
                # )
                antinode_1 = tuple2
                while is_valid_antinode(
                    antinode=antinode_1,
                    num_lines=num_lines,
                    num_chars=num_chars,
                ):
                    print_tuple(antinode_1, "Valid antinode 1:")
                    pos = (
                        antinode_1.get[0, Int]() * num_chars
                        + antinode_1.get[1, Int]()
                    )
                    valid_anti_node_locations.add(pos)
                    antinode_1 = Tuple[Int, Int](
                        antinode_1.get[0, Int]() + x_coord_diff,
                        antinode_1.get[1, Int]() + y_coord_diff,
                    )
                # Direction 2
                antinode_2 = tuple1
                # antinode_2 = Tuple[Int, Int](
                #     tuple1.get[0, Int]() - x_coord_diff,
                #     tuple1.get[1, Int]() - y_coord_diff,
                # )
                while is_valid_antinode(
                    antinode=antinode_2,
                    num_lines=num_lines,
                    num_chars=num_chars,
                ):
                    print_tuple(antinode_2, "Valid antinode 2:")
                    pos = (
                        antinode_2.get[0, Int]() * num_chars
                        + antinode_2.get[1, Int]()
                    )
                    valid_anti_node_locations.add(pos)
                    antinode_2 = Tuple[Int, Int](
                        antinode_2.get[0, Int]() - x_coord_diff,
                        antinode_2.get[1, Int]() - y_coord_diff,
                    )
    return len(valid_anti_node_locations)


fn main() raises:
    test_process_lines()

    alias sample_filename = "day8_sample.txt"
    alias filename = "day8.txt"
    alias debug = False
    lines = read_file[filename]()
    dic = process_lines(lines)

    num_lines = len(lines)
    num_chars = len(lines[0])
    num_keys = len(dic.keys())
    print(
        "Num lines:", num_lines, "Num chars:", num_chars, "Num keys:", num_keys
    )
    part_a = calculate_antinodes_a[debug](
        dic=dic, num_lines=num_lines, num_chars=num_chars
    )
    print(part_a)

    alias debug_b = False
    part_b = calculate_antinodes_b[debug_b](
        dic=dic, num_lines=num_lines, num_chars=num_chars
    )
    print(part_b)
