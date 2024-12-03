from testing import assert_equal


fn parse_reports(file_path: String) raises -> List[List[Int]]:
    var reports = List[List[Int]]()

    with open(file_path, "r") as file:
        var lines = file.read().splitlines()
        with open(file_path, "r") as file:
            lines = file.read().splitlines()
            for line in lines:
                row = List[Int]()
                numbers = line[].strip().split()
                for num in numbers:
                    row.append(int(num[]))
                reports.append(row)

    return reports


fn is_safe_sequence(levels: List[Int]) -> Bool:
    if len(levels) < 2:
        return True

    var first_diff = levels[1] - levels[0]
    if abs(first_diff) < 1 or abs(first_diff) > 3:
        return False

    var is_increasing = first_diff > 0

    for i in range(1, len(levels) - 1):
        var diff = levels[i + 1] - levels[i]

        if is_increasing:
            if diff <= 0:
                return False
        else:
            if diff >= 0:
                return False

        if abs(diff) < 1 or abs(diff) > 3:
            return False

    return True


fn is_safe_sequence_b(levels: List[Int]) -> Bool:
    # Try removing each element
    for i in range(len(levels)):
        var new_levels = List[Int]()
        for j in range(len(levels)):
            if j != i:
                new_levels.append(levels[j])
        if is_safe_sequence(new_levels):
            return True

    return False


fn is_safe_report(levels: List[Int]) -> Bool:
    return is_safe_sequence(levels)


fn is_safe_report_b(levels: List[Int]) -> Bool:
    return is_safe_sequence_b(levels)


fn test_is_safe_sequence() raises:
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 3, 4)), True)
    assert_equal(is_safe_sequence_b(List[Int](5, 4, 3, 2, 1)), True)
    assert_equal(is_safe_sequence_b(List[Int](1, 5, 8, 12)), False)
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 5, 6)), True)
    assert_equal(is_safe_sequence_b(List[Int](2, 3, 4, 5)), True)
    assert_equal(is_safe_sequence_b(List[Int](2, 6, 4, 5)), True)
    assert_equal(is_safe_sequence_b(List[Int](1, 3, 2, 4)), True)
    assert_equal(is_safe_sequence_b(List[Int](3, 3, 3, 3)), False)
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 3, 4)), True)


def test_is_safe_sequence_b_edge_cases():
    # All elements equal
    assert_equal(is_safe_sequence_b(List[Int](4, 4, 4, 4)), False)

    # Minimum allowed differences
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 3, 4)), True)

    # Maximum allowed differences
    assert_equal(is_safe_sequence_b(List[Int](1, 4, 7, 10)), True)

    # Exactly one removal makes it safe
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 5, 6, 9)), True)

    # Removal does not fix trend inconsistency
    assert_equal(is_safe_sequence_b(List[Int](1, 3, 2, 5, 4)), False)

    # Alternating increases and decreases with allowable removal
    assert_equal(is_safe_sequence_b(List[Int](2, 5, 3, 6, 4)), False)

    # Large list with one problematic element
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 3, 7, 4, 5)), True)

    # Differences exactly at the boundary
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 5, 8)), True)

    # Single removal needed at the start
    assert_equal(is_safe_sequence_b(List[Int](4, 1, 2, 3, 4)), True)

    # Single removal needed at the end
    assert_equal(is_safe_sequence_b(List[Int](1, 2, 3, 7)), True)


fn main() raises:
    var reports = parse_reports("day2.txt")

    reta = 0
    retb = 0
    for i in range(len(reports)):
        var safe = is_safe_report(reports[i])
        if safe:
            reta += 1
        var safeb = is_safe_report_b(reports[i])
        if safeb:
            retb += 1
    print(reta)
    print(retb)
