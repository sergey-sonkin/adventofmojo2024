from python import Python


fn partb(file: List[String]) raises -> Int:
    re = Python.import_module("re")
    # Define regex patterns
    var pattern = re.compile(r"mul\((\d+),(\d+)\)|do\(\)|don't\(\)")
    print(pattern)

    var total = 0
    var mul_enabled = True  # Initial state

    for line in file:
        for matche in pattern._call_single_arg_method("finditer", line[]):
            var a = matche.__getitem__(0).__str__()
            var b = matche.__getitem__(1).__str__()
            var c = matche.__getitem__(2).__str__()
            if a == "do()":
                mul_enabled = True
            elif a == "don't()":
                mul_enabled = False
            elif b and c:
                if mul_enabled:
                    total += atol(b) * atol(c)

    return total


fn main() raises:
    re = Python.import_module("re")

    with open("day3.txt", "r") as file:
        lines = file.read().splitlines()

    # var input_str: String = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    # var lines = List[String](input_str)

    total = 0
    var pattern = r"mul\((\d+),(\d+)\)"

    for input_str in lines:
        var matches = re.findall(pattern, input_str[])

        for matche in matches:
            var a = atol(matche.__getitem__(0).__str__())
            var b = atol(matche.__getitem__(1).__str__())
            total += int(a) * int(b)

    print(total)

    print("--  Part Two  --")
    print(partb(lines))
