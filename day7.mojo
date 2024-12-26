from testing import assert_equal

fn process_file[filename: String]() raises -> List[List[Int]]:
    with open(filename, "r") as file:
        lines = file.read().splitlines()
    results = List[List[Int]]()
    for s in lines:
        nums_in_line = List[Int]()
        parts = s[].split(":")
        nums_in_line.append(int(parts[0].strip()))
        for x in parts[1].split():
            nums_in_line.append(int(x[]))
        results.append(nums_in_line)
    return results

fn test_process_file() raises -> None:
    lines = process_file["day7.testtxt"]()
    assert_equal(lines[0], List[Int](200,20,20))
    assert_equal(lines[1], List[Int](3000,31,31))
    assert_equal(lines[2], List[Int](1,2,3,4))

fn determine_valid_options_a(line: List[Int]) -> Int:
    var to_potentially_return = line[0]

    var options = List[List[Int]](line)
    while options:
        option = options.pop(0)
        if len(option) == 2:
            if option[0] == option[1]:
                return to_potentially_return
            else:
                continue
        else:
            first = option[0]
            last = option[-1]

            # Case 1: Multiplication
            if first % last == 0:
                to_add = option[:-1]
                to_add[0] = first // last
                options.append(to_add)
             # Case 2: Addition
            to_add_2 = option[:-1]
            to_add_2[0] = first - last
            options.append(to_add_2)
    return 0

fn determine_valid_options_b[debug: Bool = False](line: List[Int]) raises -> Int:
    var to_potentially_return = line[0]

    var options = List[List[Int]](line)
    while options:
        option = options.pop(0)
        if len(option) == 2:
            if option[0] == option[1]:
                return to_potentially_return
            else:
                continue
        first = option[0]
        last = option[-1]

        # Case 1: Multiplication
        if first % last == 0:
            to_add = option[:-1]
            to_add[0] = first // last
            if debug:
                print("Multiplication option", to_add.__str__())
            options.append(to_add)

        # Case 2: Addition
        if first >= last:
            to_add_2 = option[:-1]
            to_add_2[0] = first - last
            if debug:
                print("Addition option", to_add_2.__str__())
            options.append(to_add_2)

        # Case 3: Concatenation
        last_number_digit_length = len(str(last))
        power_of_ten = 10 ** (last_number_digit_length)
        if (first - last) % power_of_ten == 0:
            to_add_3 = option[:-1]
            to_add_3[0] = (first - last) // power_of_ten
            if debug:
                print("Concatenation option", to_add_3.__str__())
            options.append(to_add_3)

    return 0


fn test_determine_valid_options_a() raises -> None:
    var case_1 = List[Int](190, 10, 19)
    var resu_1 = determine_valid_options_a(case_1)
    var case_2 = List[Int](3267,81,40,27)
    var resu_2 = determine_valid_options_a(case_2)
    var case_3 = List[Int](83,17,5)
    var resu_3 = determine_valid_options_a(case_3)

    assert_equal(resu_1,190)
    assert_equal(resu_2,3267)
    assert_equal(resu_3,0)

fn test_determine_valid_options_b() raises -> None:
    var case_1 = List[Int](190, 10, 19)
    var resu_1 = determine_valid_options_b(case_1)
    var case_2 = List[Int](3267,81,40,27)
    var resu_2 = determine_valid_options_b(case_2)
    var case_3 = List[Int](83,17,5)
    var resu_3 = determine_valid_options_b(case_3)

    # New cases relying on concatenation
    var case_4 = List[Int](156,15,6)
    var resu_4 = determine_valid_options_b(case_4)
    var case_5 = List[Int](7290,6,8,6,15)
    var resu_5 = determine_valid_options_b(case_5)
    var case_6 = List[Int](192,17,8,14)
    var resu_6 = determine_valid_options_b(case_6)
    var case_7 = List[Int](192,192)
    var resu_7 = determine_valid_options_b(case_7)
    #1233: 1 18 5 3
    var case_8 = List[Int](1233,1,18,5,3)
    var resu_8 = determine_valid_options_b[True](case_8)


    assert_equal(resu_1,190)
    assert_equal(resu_2,3267)
    assert_equal(resu_3,0)
    assert_equal(resu_4,156)
    assert_equal(resu_5,7290)
    assert_equal(resu_6,192)
    assert_equal(resu_7,192)
    assert_equal(resu_8,1233)

fn main() raises -> None:
    test_process_file()
    test_determine_valid_options_a()
    test_determine_valid_options_b()

    alias sample_filename = "day7_sample.txt"
    alias filename = "day7.txt"
    lines = process_file[filename]()

    # Part a
    ret = 0
    for line in lines:
        ret += determine_valid_options_a(line[])

    # Part b
    ret_b = 0
    for line in lines:
        ret_b += determine_valid_options_b(line[])

    print(ret_b)
