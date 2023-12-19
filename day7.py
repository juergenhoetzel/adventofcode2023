from collections import Counter
from pathlib import Path
import sys

EXAMPLE_INPUT = """32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"""


def parse_hand(s):
    hand, bid = s.split(" ")
    return hand, int(bid)


RELATIVE_STRENGTH = {c: i for i, c in enumerate("23456789TJQKA")}


def rank_hand(hand):
    c = Counter(hand)
    match sorted(c.values(), reverse=True):
        case [5]:
            typ = 7
        case [4, 1]:
            typ = 6
        case [3, 2]:
            typ = 5
        case [3, 1, 1]:
            typ = 4
        case [2, 2, 1]:
            typ = 3
        case [2, 1, 1, 1]:
            typ = 2
        case _:
            typ = 1
    return [typ] + [RELATIVE_STRENGTH.get(c) for c in hand]


def parse_input(input_string):
    return [parse_hand(s) for s in input_string.splitlines()]


def calc_score(input_hands):
    return sum((i + 1) * hand[1] for i, hand in enumerate(sorted(input_hands, key=lambda h: rank_hand(h[0]))))


def main():
    if len(sys.argv) > 1:
        input_string = Path(sys.argv[1]).read_text()
    else:
        input_string = EXAMPLE_INPUT
    print("Part1: ", calc_score(parse_input(input_string)))


if __name__ == "__main__":
    main()
