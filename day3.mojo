from python import Python


fn parta(lines: List[String]) raises -> Int:
    re = Python.import_module("re")
    var pattern = r"mul\((\d+),(\d+)\)"

    var total = 0
    for input_str in lines:
        var matches = re.findall(pattern, input_str[])

        for matche in matches:
            var a = atol(matche.__getitem__(0).__str__())
            var b = atol(matche.__getitem__(1).__str__())
            total += int(a) * int(b)
    return total


fn partb(file: List[String]) raises -> Int:
    var re = Python.import_module("re")
    var pattern = re.compile(r"mul\((\d+),(\d+)\)|do\(\)|don't\(\)")

    var total = 0
    var mul_enabled = True

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

    total = 0
    var pattern = r"mul\((\d+),(\d+)\)"

    for input_str in lines:
        var matches = re.findall(pattern, input_str[])

        for matche in matches:
            var a = atol(matche.__getitem__(0).__str__())
            var b = atol(matche.__getitem__(1).__str__())
            total += int(a) * int(b)

    print("Part a:", parta(lines))
    print("Part b:", partb(lines))
