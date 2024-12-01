from collections import InlinedFixedVector
from testing import assert_equal
from memory import Reference
from sys import simdwidthof
from algorithm.functional import vectorize

alias UINT_SIZE = Int32
alias dtype = DType.int32
alias width = simdwidthof[UINT_SIZE]()


fn read_columns[
    file_path: String
]() raises -> (List[UINT_SIZE], List[UINT_SIZE]):
    var column1: List[UINT_SIZE] = List[UINT_SIZE]()
    var column2: List[UINT_SIZE] = List[UINT_SIZE]()

    with open(file_path, "r") as file:
        lines = file.read().splitlines()
        for line in lines:
            split_lines = line[].strip().split()
            column1.append(int(split_lines[0]))
            column2.append(int(split_lines[1]))

    return column1, column2


fn helper(l1: List[UINT_SIZE], l2: List[UINT_SIZE]) raises -> UINT_SIZE:
    var c1p = l1.unsafe_ptr()
    var c2p = l2.unsafe_ptr()

    var ret: UINT_SIZE = 0

    @parameter
    fn process_vector[simd_width: Int](offset: Int):
        smd1 = c1p.load[width=simd_width](offset)
        smd2 = c2p.load[width=simd_width](offset)
        print(smd1.__str__())
        print(smd2.__str__())
        print("----")
        smd3 = abs(smd1 - smd2)
        ret += smd3.reduce_add()

    n = len(l1)
    vectorize[process_vector, width](n)
    return ret


fn main() raises:
    alias file_path: String = "day1_sample.txt"
    column1, column2 = read_columns[file_path]()

    sort(column1)
    sort(column2)

    print(column1.__str__())
    print(column2.__str__())

    ret0 = helper(column1, column2)
    print("HELLO", ret0)

    var c1p = column1.unsafe_ptr()
    var c2p = column2.unsafe_ptr()

    var ret: UINT_SIZE = 0

    @parameter
    fn process_vector[simd_width: Int](offset: Int):
        smd1 = c1p.load[width=simd_width](offset)
        smd2 = c2p.load[width=simd_width](offset)
        print(smd1.__str__())
        print(smd2.__str__())
        print("----")
        smd3 = abs(smd1 - smd2)
        ret += smd3.reduce_add()

    for val in column1:
        print(val[])
    print("--------------------------------")
    for val in column2:
        print(val[])

    var n = len(column1)
    vectorize[process_vector, width](n)

    print(ret)
