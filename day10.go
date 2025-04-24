package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
	"sync"
)

// Point represents a coordinate on the grid.
type Point struct {
	r, c int
}

// State represents the current state in the search.
// Used differently in Part 1 (DFS stack) and Part 2 (memoization key).
type State struct {
	pos    Point
	height int
}

// --- Part 1 Logic ---

// solvePart1 calculates the total score (sum of unique reachable 9s) for all trailheads using goroutines.
func solvePart1(grid [][]int, rows, cols int, trailheads []Point, dr, dc []int) int {
	if len(trailheads) == 0 {
		return 0
	}

	scoresChan := make(chan int, len(trailheads))
	var wg sync.WaitGroup

	for _, start := range trailheads {
		wg.Add(1)
		go func(startPoint Point) {
			defer wg.Done()

			reachableNines := make(map[Point]struct{})
			stack := []State{{pos: startPoint, height: 0}}
			// visitedState prevents cycles and redundant checks *within a single trailhead's search*
			visitedState := make(map[State]bool)
			visitedState[State{pos: startPoint, height: 0}] = true

			for len(stack) > 0 {
				currentState := stack[len(stack)-1]
				stack = stack[:len(stack)-1]

				r, c := currentState.pos.r, currentState.pos.c
				currentHeight := currentState.height

				if currentHeight == 9 {
					reachableNines[currentState.pos] = struct{}{}
					continue // Found an endpoint for this path
				}

				for i := 0; i < 4; i++ {
					nr, nc := r+dr[i], c+dc[i]
					if nr >= 0 && nr < rows && nc >= 0 && nc < cols {
						if grid[nr][nc] == currentHeight+1 {
							nextState := State{pos: Point{nr, nc}, height: currentHeight + 1}
							if !visitedState[nextState] {
								visitedState[nextState] = true
								stack = append(stack, nextState)
							}
						}
					}
				}
			}
			scoresChan <- len(reachableNines) // Send the count of unique 9s
		}(start)
	}

	go func() {
		wg.Wait()
		close(scoresChan)
	}()

	totalScore := 0
	for score := range scoresChan {
		totalScore += score
	}
	return totalScore
}

// --- Part 2 Logic ---

// countPathsRecursiveMemo calculates the number of distinct paths from currentState to any height 9 cell.
// It uses memoization (the memo map) to avoid redundant calculations.
func countPathsRecursiveMemo(currentState State, grid [][]int, rows, cols int, dr, dc []int, memo map[State]int) int {
	if count, found := memo[currentState]; found {
		return count
	}

	r, c := currentState.pos.r, currentState.pos.c
	currentHeight := currentState.height

	if currentHeight == 9 {
		return 1 // Base case: Found one path ending here
	}

	pathCount := 0
	for i := range 4 {
		nr, nc := r+dr[i], c+dc[i]
		if nr >= 0 && nr < rows && nc >= 0 && nc < cols {
			if grid[nr][nc] == currentHeight+1 {
				nextState := State{pos: Point{nr, nc}, height: currentHeight + 1}
				pathCount += countPathsRecursiveMemo(nextState, grid, rows, cols, dr, dc, memo)
			}
		}
	}

	memo[currentState] = pathCount
	return pathCount
}

// solvePart2 calculates the total rating (sum of distinct path counts) for all trailheads using goroutines.
func solvePart2(grid [][]int, rows, cols int, trailheads []Point, dr, dc []int) int {
	if len(trailheads) == 0 {
		return 0
	}

	ratingsChan := make(chan int, len(trailheads))
	var wg sync.WaitGroup

	for _, start := range trailheads {
		wg.Add(1)
		go func(startPoint Point) {
			defer wg.Done()
			memo := make(map[State]int) // Each goroutine needs its own memo cache
			initialState := State{pos: startPoint, height: 0}
			rating := countPathsRecursiveMemo(initialState, grid, rows, cols, dr, dc, memo)
			ratingsChan <- rating
		}(start)
	}

	go func() {
		wg.Wait()
		close(ratingsChan)
	}()

	totalRating := 0
	for rating := range ratingsChan {
		totalRating += rating
	}
	return totalRating
}

// --- Main Function ---

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	grid := [][]int{}

	// Read grid from standard input
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}
		row := []int{}
		cols := 0 // Keep track of expected column length
		for i, char := range line {
			digit, err := strconv.Atoi(string(char))
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error parsing input character '%c': %v\n", char, err)
				os.Exit(1)
			}
			if digit < 0 || digit > 9 {
				fmt.Fprintf(os.Stderr, "Error: Input height '%d' out of range (0-9)\n", digit)
				os.Exit(1)
			}
			row = append(row, digit)
			if i == 0 && len(grid) == 0 { // First char of first line
				cols = len(line)
			}
		}
		// Validation moved inside loop for clarity
		if len(grid) > 0 && len(row) != len(grid[0]) {
			fmt.Fprintf(os.Stderr, "Error: Inconsistent row length (expected %d, got %d)\n", len(grid[0]), len(row))
			os.Exit(1)
		} else if len(grid) == 0 && len(row) == 0 {
			// Handle case of empty first line if needed, though scanner loop might prevent this
		} else if len(grid) == 0 {
			// Set expected cols based on first non-empty line
			cols = len(row)
		} else if len(row) != cols {
			fmt.Fprintf(os.Stderr, "Error: Inconsistent row length (expected %d, got %d)\n", cols, len(row))
			os.Exit(1)
		}

		grid = append(grid, row)
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "Error reading standard input: %v\n", err)
		os.Exit(1)
	}

	rows := len(grid)
	if rows == 0 {
		fmt.Println("Part 1 Result: 0")
		fmt.Println("Part 2 Result: 0")
		return
	}
	cols := len(grid[0])
	if cols == 0 {
		fmt.Println("Part 1 Result: 0")
		fmt.Println("Part 2 Result: 0")
		return
	}

	// Find trailheads once
	trailheads := []Point{}
	for r := range rows {
		for c := range cols {
			if grid[r][c] == 0 {
				trailheads = append(trailheads, Point{r, c})
			}
		}
	}

	// Directions for neighbors (up, down, left, right)
	dr := []int{-1, 1, 0, 0}
	dc := []int{0, 0, -1, 1}

	// Calculate and print results
	resultPart1 := solvePart1(grid, rows, cols, trailheads, dr, dc)
	fmt.Printf("Part 1 Result: %d\n", resultPart1)

	resultPart2 := solvePart2(grid, rows, cols, trailheads, dr, dc)
	fmt.Printf("Part 2 Result: %d\n", resultPart2)
}
