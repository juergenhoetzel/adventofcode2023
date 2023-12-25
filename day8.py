import re
import sys
import itertools
from pathlib import Path

EXAMPLE_INPUT = """LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)"""


def parse_graph(graph_lines):
    return {cols[0]: (cols[1], cols[2]) for graph_line in graph_lines if (cols := re.findall("([A-Z]+)", graph_line))}


def part_1(input_str=EXAMPLE_INPUT):
    [movements, _, *graph_lines] = input_str.splitlines()
    graph = parse_graph(graph_lines)
    pos = "AAA"
    for n, move in enumerate(itertools.cycle(movements)):
        if pos == "ZZZ":
            return n
        if move == "L":
            pos = graph[pos][0]
        else:
            pos = graph[pos][1]


def main():
    if len(sys.argv) > 1:
        input_str = Path(sys.argv[1]).read_text()
    else:
        input_str = EXAMPLE_INPUT
    print("Part1: ", part_1(input_str))


if __name__ == "__main__":
    main()
