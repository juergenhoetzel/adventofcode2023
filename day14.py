from pathlib import Path
import sys

EXAMPLE_INPUT = """O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""


def parse_input(s: str) -> list[list[str]]:
    return [list(line) for line in s.splitlines()]


def move_north(pf: list[list[str]]):
    for y in range(1, len(pf)):
        for x, item in enumerate(pf[y]):
            if item == "O":
                to_pos = None  # keep in place if no movement possible
                for y2 in range(y - 1, -1, -1):
                    if pf[y2][x] == ".":
                        to_pos = y2
                    if pf[y2][x] in {"O", "#"}:
                        break
                if to_pos is not None:
                    pf[to_pos][x] = "O"
                    pf[y][x] = "."


def calc_score(pf: list[list[str]]):
    n = len(pf)
    return sum(line.count("O") * (n - y) for y, line in enumerate(pf))


def main():
    if len(sys.argv) > 1:
        input_str = Path(sys.argv[1]).read_text()
    else:
        input_str = EXAMPLE_INPUT
    platform = parse_input(input_str)
    move_north(platform)
    print("Part1:", calc_score(platform))


if __name__ == "__main__":
    main()
