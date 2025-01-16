from collections import Dict, Set
from testing import assert_equal


@value
struct Location:
    var starting_location: UInt16
    var last_location: UInt16

    fn debug_print(self):
        print(
            "Starting location:",
            self.starting_location,
            "last_location:",
            self.last_location,
        )

    fn __eq__(self, other: Self) -> Bool:
        return (
            self.starting_location == other.starting_location
            and self.last_location == other.last_location
        )

    fn __ne__(self, other: Self) -> Bool:
        return (
            self.starting_location != other.starting_location
            or self.last_location != other.last_location
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
        # Make sure all items in self are in other
        for self_item in self.files.items():
            self_file_id, self_file_list = self_item[].key, self_item[].value
            if self_file_id not in compared_keys:
                var other_file_list = other.files.get(self_file_id).value()
                if other_file_list != self_file_list:
                    return False
                compared_keys.add(self_file_id)
        # Make sure all items in other are in self
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

    fn __ne__(self, other: Self) -> Bool:
        return not self == other

    fn get_first_space(self) -> UInt16:
        return self.spaces[0].starting_location

    fn pop_first_space(mut self) -> None:
        first_location = self.spaces[0]
        if first_location.starting_location == first_location.last_location:
            _ = self.spaces.pop(0)
        else:
            first_location.starting_location += 1

    fn add_space(mut self, file_index: UInt16) raises -> None:
        num_spaces = len(self.spaces)
        # If already existing space, add it
        for ii in range(num_spaces):
            location = self.spaces[ii]
            if location.starting_location < file_index:
                if location.last_location != file_index - 1:
                    raise Error("Space already exists")
                location.last_location += 1
                # Need to compact spaces if necessary
                if ii + 1 < num_spaces and self.spaces[ii].last_location == self.spaces[ii+1].starting_location:
                    self.spaces[ii+1].starting_location = self.spaces[ii].starting_location
                    _ = self.spaces.pop(ii)
                return
        new_space = Location(starting_location=file_index, last_location=file_index)
        self.spaces.append(new_space)


    fn get_last_file_location(self, file_index: Int) raises -> UInt16:
        if file_index not in self.files:
            raise Error("File index not found")
        return self.files[file_index][-1].last_location

    fn pop_last_file_location(mut self, file_index: Int) raises:
        last_location_struct = self.files[file_index][-1]
        if (
            last_location_struct.starting_location
            == last_location_struct.last_location
        ):
            _ = self.files[file_index].pop(-1)
        else:
            # Can't mutate last element in place. Need to copy list, change last element, then paste back
            # Skill issue or deficiency in language?
            var locations_list = self.files[file_index]
            locations_list[-1].last_location -= 1
            self.files[file_index] = locations_list


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
            starting_location=curr_pos, last_location=curr_pos + file_length - 1
        )
        id_locations_dict[id] = List[Location](new_file_loc)
        curr_pos += file_length
        # Calculate spaces
        if ii + 1 < l:
            var space_length = int(input[ii + 1])
            var space_loc = Location(
                starting_location=curr_pos,
                last_location=curr_pos + space_length - 1,
            )
            space_locations.append(space_loc)
            curr_pos += space_length
    return DiskMap(files=id_locations_dict, spaces=space_locations)


fn test_process_initial_input() raises:
    alias test_input = "12345"
    var map = process_initial_input(test_input)
    var loc0 = List[Location](Location(starting_location=0, last_location=0))
    var loc1 = List[Location](Location(starting_location=3, last_location=5))
    var loc2 = List[Location](Location(starting_location=10, last_location=14))

    files = Dict[Int, List[Location]]()
    files[0] = loc0
    files[1] = loc1
    files[2] = loc2

    var sp0 = Location(starting_location=1, last_location=2)
    var sp1 = Location(starting_location=6, last_location=9)

    test_map = DiskMap(files=files, spaces=List[Location](sp0, sp1))

    if map != test_map:
        map.debug_print()
        test_map.debug_print()
        raise Error("WRONG")

fn test_add_space() raises:
    var space_1 = Location(starting_location=0, last_location=0)
    var space_2 = Location(starting_location=3, last_location=5)

    var disk_map = DiskMap(files=Dict[Int, List[Location]](), spaces=List[Location](space_1,space_2))
    disk_map.add_space(1)
    disk_map.debug_print()


fn main() raises:
    test_process_initial_input()
    test_add_space()
    print("Finished tests")

    alias sample_filename = "day9_sample.txt"
    alias filename = "day9.txt"
    var input: String

    with open(sample_filename, "r") as f:
        input = f.read()

    var disk_map = process_initial_input(input)
    var files = disk_map.files
    var spaces = disk_map.spaces
    print('hi')

    var current_int = len(files) - 1
    disk_map.debug_print()
    while True:
        print("Current int:",current_int)
        first_available_space = disk_map.get_first_space()
        last_file_location = disk_map.get_last_file_location(current_int)
        if first_available_space > last_file_location:
            break

    # while True:
    #     # Step 1. Grab the last number. We might need to grab a smaller number
    #     current_locations = files[current_int]
    #     first_available_space = spaces[0]
    #     last_file_location = current_locations[-1]
    #     if last_file_location.starting_location + last_file_location.length < first_available_space.starting_location:

    #     if current_locations == []
    #         current_int -= 1


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
