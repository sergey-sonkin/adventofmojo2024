from collections import InlinedFixedVector, Counter, Set
from sys import simdwidthof
from algorithm.functional import vectorize, parallelize

alias INT_SIZE = Int32
alias dtype = DType.int32
alias width = simdwidthof[INT_SIZE]()


fn read_columns[file_path: String]() raises -> (List[INT_SIZE], List[INT_SIZE]):
    var column1: List[INT_SIZE] = List[INT_SIZE]()
    var column2: List[INT_SIZE] = List[INT_SIZE]()

    with open(file_path, "r") as file:
        lines = file.read().splitlines()
        for line in lines:
            split_lines = line[].strip().split()
            column1.append(int(split_lines[0]))
            column2.append(int(split_lines[1]))

    return column1, column2


fn helper(l1: List[INT_SIZE], l2: List[INT_SIZE]) raises -> INT_SIZE:
    var c1p = l1.unsafe_ptr()
    var c2p = l2.unsafe_ptr()

    var ret: INT_SIZE = 0

    @parameter
    fn process_vector[simd_width: Int](offset: Int):
        smd1 = c1p.load[width=simd_width](offset)
        smd2 = c2p.load[width=simd_width](offset)
        # print(smd1.__str__())
        # print(smd2.__str__())
        # print("----")
        smd3 = abs(smd1 - smd2)
        ret += smd3.reduce_add()

    n = len(l1)
    vectorize[process_vector, width](n)
    return ret


fn helperb(l1: List[INT_SIZE], l2: List[INT_SIZE]) raises -> INT_SIZE:
    # Convert to List[Int] to make Counter library happy
    var il1 = List[Int]()
    var il2 = List[Int]()

    for i in l1:
        il1.append(int(i[]))
    for i in l2:
        il2.append(int(i[]))

    var ret: INT_SIZE = 0
    var c1 = Counter(il1)
    var c2 = Counter(il2)

    for item in c1.items():
        ret += item[].key * item[].value * c2.get(item[].key, 0)

    return ret


fn helperb2(l1: List[INT_SIZE], l2: List[INT_SIZE]) raises -> INT_SIZE:
    l = len(l1)
    var il1 = List[Int](capacity=l)
    var il2 = List[Int](capacity=l)

    @parameter
    fn convert_list(ii: Int):
        # The below is non-deterministic, leading to wrong part b results
        il1.append(int(l1[ii]))
        il2.append(int(l2[ii]))

    parallelize[convert_list](l)

    var ret: INT_SIZE = 0
    var c1 = Counter[Int](il1)
    var c2 = Counter[Int](il2)

    for item in c1.items():
        ret += item[].key * item[].value * c2.get(item[].key, 0)

    return ret


fn main() raises:
    # alias file_path: String = "day1_sample.txt"
    alias file_path: String = "day1.txt"
    column1, column2 = read_columns[file_path]()

    sort(column1)
    sort(column2)

    # print(column1.__str__())
    # print(column2.__str__())

    var reta = helper(column1, column2)
    print("Part a:", reta)
    var retb = helperb2(column1, column2)
    print("Part b:", retb)
