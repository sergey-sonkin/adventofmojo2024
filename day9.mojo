from collections import Dict, Set
from testing import assert_equal


@value
struct Location:
    var starting_location: UInt16
    var length: UInt16

    fn debug_print(self):
        print(
            "Starting location:", self.starting_location, "Length:", self.length
        )

    fn __eq__(self, other: Self) -> Bool:
        return (
            self.starting_location == other.starting_location
            and self.length == other.length
        )

    fn __ne__(self, other: Self) -> Bool:
        return (
            self.starting_location != other.starting_location
            or self.length != other.length
        )


@value
struct DiskMap:
    var files: Dict[Int, List[Location]]
    var spaces: List[Location]

    fn debug_print(self):
        for file in self.files.items():
            int, locations = file[].key, file[].value
            print("Index:", int)
            for location in locations:
                location[].debug_print()
        print("Spaces:")
        for space in self.spaces:
            space[].debug_print()

    fn __eq__(self, other: Self) -> Bool:
        var compared_keys = Set[Int]()
        for self_item in self.files.items():
            self_file_id, self_file_list = self_item[].key, self_item[].value
            if self_file_id not in compared_keys:
                var other_file_list = other.files.get(self_file_id).value()
                if other_file_list != self_file_list:
                    return False
                compared_keys.add(self_file_id)

        for other_item in other.files.items():
            other_file_id, other_file_list = (
                other_item[].key,
                other_item[].value,
            )
            if other_file_id not in compared_keys:
                self_file_list = self.files.get(other_file_id).value()
                if other_file_list != self_file_list:
                    return False

        return True


fn process_initial_input(input: String) raises -> DiskMap:
    l = len(input)
    var curr_pos = 0
    var id_locations_dict = Dict[Int, List[Location]]()
    var space_locations = List[Location]()
    for ii in range(0, l, 2):
        # Calculate file
        var file_length = int(input[ii])
        var id = ii // 2
        var new_file_loc = Location(
            starting_location=curr_pos, length=file_length
        )
        id_locations_dict[id] = List[Location](new_file_loc)
        curr_pos += file_length
        # Calculate spaces
        if ii + 1 < l:
            var space_length = int(input[ii + 1])
            var space_loc = Location(
                starting_location=curr_pos, length=space_length
            )
            space_locations.append(space_loc)
            curr_pos += space_length
    return DiskMap(files=id_locations_dict, spaces=space_locations)


fn test_process_initial_input() raises:
    alias test_input = "12345"
    var map = process_initial_input(test_input)
    var loc0 = List[Location](Location(starting_location=0, length=1))
    var loc1 = List[Location](Location(starting_location=3, length=3))
    var loc2 = List[Location](Location(starting_location=10, length=5))

    files = Dict[Int, List[Location]]()
    files[0] = loc0
    files[1] = loc1
    files[2] = loc2

    var sp0 = Location(starting_location=1, length=2)
    var sp1 = Location(starting_location=6, length=4)

    test_map = DiskMap(files=files, spaces=List[Location](sp0, sp1))
    # map.debug_print()
    # test_map.debug_print()

    if not map == test_map:
        raise Error("WRONG")


fn main() raises:
    alias sample_filename = "day9_sample.txt"
    alias filename = "day9.txt"
    var input: String

    with open(sample_filename, "r") as f:
        input = f.read()

    print(input)
    test_process_initial_input()


## 12345
## 1 block file, 2 blocks space, 3 blocks file, 4 blocks space, 5 blocks file
## 90909: 9 blocks file, 0 space, 9 blocks file, 0 space, 9 blocks file

## 1 block file (id 0), 2 blocks space, 3 blocks file (id 1), 4 blocks space, 5 blocks file (id 2)
## 0..111....2

## 23 33 13 3121414131402
## 00...111...2...


## 0..111....22222
## 02.111....2222.
## 022111....222..
## 0221112...22...
## 02211122..2....
## 022111222......
