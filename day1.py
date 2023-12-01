import re
import sys
from pathlib import Path


example_input_lines = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""".splitlines()

example_input_lines2 = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen""".splitlines()


TO_DIGITS = {"one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"}

NUMBERS_RE = re.compile("(one|two|three|four|five|six|seven|eight|nine)")


def resolve_spelling(lines: list[str]):
    for i in range(len(lines)):
        lines[i] = NUMBERS_RE.sub(lambda m: TO_DIGITS.get(m.group(0)), lines[i])


def decode_lines(lines: list[str]) -> int:
    sum = 0
    for line in lines:
        digits = [int(c) for c in line if c.isdigit()]
        sum += digits[0] * 10 + digits[-1]
    return sum


def main():
    input_lines = Path(sys.argv[1]).read_text().splitlines() if len(sys.argv) > 1 else example_input_lines
    input_lines2 = Path(sys.argv[2]).read_text().splitlines() if len(sys.argv) > 2 else example_input_lines2
    print("Part 1: ", decode_lines(input_lines))
    resolve_spelling(input_lines2)
    print("Part 2: ", decode_lines(input_lines2))


if __name__ == "__main__":
    main()
