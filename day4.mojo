fn day1() raises:
    with open("day4.txt", "r") as file:
        grid = file.read().splitlines()

    alias word: String = "XMAS"
    alias word_len = 4
    alias directions = List(
        List[Int](0, 1),
        List[Int](1, 0),
        List[Int](1, 1),
        List[Int](0, -1),
        List[Int](-1, 0),
        List[Int](-1, -1),
        List[Int](1, -1),
        List[Int](-1, 1),
    )

    var rows = len(grid)
    var cols = len(grid[0])
    var count = 0

    for r in range(rows):
        for c in range(cols):
            for dir in directions:
                var di = dir[][0]
                var dj = dir[][1]
                var k = 0
                while k < word_len:
                    var ni = r + di * k
                    var nj = c + dj * k
                    if ni < 0 or ni >= rows or nj < 0 or nj >= cols:
                        break
                    if grid[ni][nj] != word[k]:
                        break
                    k += 1
                if k == word_len:
                    count += 1

    print("Part a:", count)


fn day2() raises:
    with open("day4.txt", "r") as file:
        grid = file.read().splitlines()

    rows = len(grid)
    cols = len(grid[0])
    var count = 0

    for r in range(1, rows - 1):
        for c in range(1, cols - 1):
            if grid[r][c] == "A":
                if grid[r - 1][c - 1] == "M" and grid[r + 1][c + 1] == "S":
                    if grid[r - 1][c + 1] == "M" and grid[r + 1][c - 1] == "S":
                        count += 1
                    elif (
                        grid[r - 1][c + 1] == "S" and grid[r + 1][c - 1] == "M"
                    ):
                        count += 1
                elif grid[r - 1][c - 1] == "S" and grid[r + 1][c + 1] == "M":
                    if grid[r - 1][c + 1] == "S" and grid[r + 1][c - 1] == "M":
                        count += 1
                    elif (
                        grid[r - 1][c + 1] == "M" and grid[r + 1][c - 1] == "S"
                    ):
                        count += 1
    print("Part b: ", count)


fn main() raises:
    day1()
    day2()
