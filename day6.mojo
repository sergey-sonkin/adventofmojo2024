from testing import assert_equal
from collections import Set


fn main() raises:
    alias filename = "day6_sample.text"
    with open(filename, mode="r") as f:
        lines = f.read().splitlines()

    fn print_file():
        for line in lines:
            print(line[])

    var max_x = len(lines[0]) - 1
    var max_y = len(lines) - 1
    # Locate where the dude is
    var x: Int = 0
    var y = len(lines) - 1
    for line in lines:
        x = line[].find("^")
        if x != -1:
            break
        y -= 1

    var starting_pos = SIMD[DType.int16, 2](x, y)
    print("Starting pos", starting_pos)
    var current_pos = SIMD[DType.int16, 2](x, y)
    alias up = SIMD[DType.int16, 2](0, 1)
    alias right = SIMD[DType.int16, 2](1, 0)
    alias down = SIMD[DType.int16, 2](0, -1)
    alias left = SIMD[DType.int16, 2](-1, 0)
    alias directions = List[SIMD[DType.int16, 2]](up, right, down, left)

    fn determine_is_oob(pos: SIMD[DType.int16, 2]) -> Bool:
        x0 = pos.__getitem__(0)
        y0 = pos.__getitem__(1)
        return (x0 < 0) or (x0 > max_x) or (y0 < 0) or (y0 > max_y)

    assert_equal(determine_is_oob(current_pos), False)

    fn reduce_pos(pos: SIMD[DType.int16, 2]) -> Int:
        x0 = pos.__getitem__(0)
        y0 = pos.__getitem__(1)
        return int(y0) * max_x + int(x0)

    fn int_to_pos(inp: Int) -> SIMD[DType.int16, 2]:
        return SIMD[DType.int16, 2](inp % max_x, inp // max_x)

    assert_equal(int_to_pos(reduce_pos(current_pos)), current_pos)
    var test_pos = SIMD[DType.int16, 2](3, 3)
    assert_equal(int_to_pos(reduce_pos(test_pos)), test_pos)

    # assert_equal(reduce_pos(current_pos), 31)

    fn get_val(pos: SIMD[DType.int16, 2]) -> String:
        x0 = pos.__getitem__(0)
        y0 = pos.__getitem__(1)
        row = lines.__getitem__(max_y - int(y0))
        return row.__getitem__(int(x0))

    fn set_val(pos: SIMD[DType.int16, 2], char: String) -> String:
        x0 = pos.__getitem__(0)
        y0 = pos.__getitem__(1)
        old_value = lines[max_y - int(y0)]
        test = old_value[: int(x0)] + char + old_value[int(x0 + 1) :]
        print("Debug", lines[max_y - int(y0)])
        print("Block before change")
        print(lines.__str__())
        lines[max_y - int(y0)] = test
        print("Debug", lines[max_y - int(y0)])
        print("Block after change")
        print(lines.__str__())
        return old_value

    print("---")
    assert_equal(get_val(current_pos), "^")
    print(set_val(current_pos, "#").__str__())
    print("---")

    var current_direction = 0
    var spots = Set[Int](reduce_pos(current_pos))

    var is_oob = False
    while True:
        new_pos = current_pos + directions.__getitem__(current_direction)
        is_oob = determine_is_oob(new_pos)
        if is_oob:
            break
        if get_val(new_pos) == "#":
            current_direction = (current_direction + 1) % 4
        else:
            current_pos = new_pos
            spots.add(reduce_pos(current_pos))
    print(len(spots))

    ## Part b: Something to realize - valid spots are only somewhere along the path. So even brute force is somewhat limited
    var correct_to_try = List[Int]()
    # print(reduce_pos( SIMD[DType.int16, 2](3, 3)))
    # print(spots.__str__())
    # correct_to_try = correct_to_try[:5]
    # spots = List[Int](30)
    for spot_to_try in spots:
        if spot_to_try[] != 29:
            continue
        pos_to_try = int_to_pos(spot_to_try[])
        if all(pos_to_try == starting_pos):
            continue

        # Run through the loop with this new insert
        current_pos = starting_pos
        current_direction = 0
        is_oob = False
        print()
        print_file()
        print()
        _ = set_val(pos=spot_to_try[], char="#")
        print()
        print_file()
        print()
        while True:
            # Get new location
            new_pos = current_pos + directions.__getitem__(current_direction)
            # If we're back to beginning with same direction, stop
            if all(new_pos == starting_pos) and current_direction == 0:
                correct_to_try.append(spot_to_try[])
                break
            is_oob = determine_is_oob(new_pos)
            if is_oob:
                break
            if get_val(new_pos) == "#":
                current_direction = (current_direction + 1) % 4
            else:
                current_pos = new_pos
                spots.add(reduce_pos(current_pos))
            continue
        _ = set_val(pos=spot_to_try[], char=".")

    # print(correct_to_try.__str__())
    # print(current_pos)
