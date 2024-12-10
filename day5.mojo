from collections import Dict, Set
from algorithm.functional import map


fn main() raises:
    alias filename = "day5.txt"
    var sections: List[String]
    with open(filename, "r") as file:
        file2 = file.read().strip()
        sections = file2.split("\n\n")

    var successors = Dict[Int, List[Int]]()
    # First part: Pre-requisites
    var prerequisite_lines = sections[0].split()
    for line in prerequisite_lines:
        var two_number_list = line[].split("|")
        var earlier_page = int(two_number_list[0])
        var later_page = int(two_number_list[1])
        if earlier_page in successors:
            successors[earlier_page].append(later_page)
        else:
            successors[earlier_page] = List[Int](later_page)

    var parsed_pages_list = List[List[Int]]()
    # Second part: Pages
    second_section = sections[1].split()
    for pages_list in second_section:
        nums_strings = pages_list[].split(",")
        int_list_to_add = List[Int]()
        for num_string in nums_strings:
            int_list_to_add.append(int(num_string[]))
        parsed_pages_list.append(int_list_to_add)

    # Part a
    var ret = 0
    var incorrect_books = List[List[Int]]()
    for book in parsed_pages_list:
        seen = Set[Int]()
        is_valid_book = True
        for page in book[]:
            if page[] in seen:
                continue
            if page[] not in successors:
                seen.add(page[])
                continue
            for successor in successors[page[]]:
                if successor[] in seen:
                    is_valid_book = False
                    break
            if not is_valid_book:
                break
            seen.add(page[])
        if is_valid_book:
            ret += book[][(len(book[]) // 2)]
        else:
            incorrect_books.append(book[])
    print(ret)

    var retb = 0
    # Part b
    for old_book in incorrect_books:
        var new_book = List[Int]()

        # We go through each page and see how early we need to insert it
        for old_page_to_add in old_book[]:
            need_to_add = True
            var ii = 0  # Mojo doesn't support enumerate() yet
            for already_added_page in new_book:
                if old_page_to_add[] not in successors:
                    continue
                # If run into an element, and we realize that it needs to come after the page we want to add,
                # We have to split the array and add it there
                if already_added_page[] in successors[old_page_to_add[]]:
                    new_book = (
                        new_book[:ii]
                        + List[Int](old_page_to_add[])
                        + new_book[ii:]
                    )
                    need_to_add = False
                    break
                ii += 1
            if need_to_add:
                new_book.append(old_page_to_add[])
        retb += new_book[(len(new_book) // 2)]
    print(retb)
