from functools import reduce
from operator import mul
from pathlib import Path
import sys


EXAMPLE_INPUT = """Time:      7  15   30
Distance:  9  40  200
"""


def parse_input(input_str: str):
    [time_s, distance_s] = [map(int, line.split(":")[1].split()) for line in input_str.splitlines()]
    return zip(time_s, distance_s)


def millimeters(hold_time, race_time):
    return (race_time - hold_time) * hold_time


def n_win(race_time, distance):
    return len([hold_time for hold_time in range(1, race_time) if millimeters(hold_time, race_time) > distance])


def main():
    input_str = Path(sys.argv[1]).read_text() if len(sys.argv) > 1 else EXAMPLE_INPUT
    score = reduce(mul, (n_win(time, distance) for time, distance in parse_input(input_str)))
    print("Part1:", score)


if __name__ == "__main__":
    main()
