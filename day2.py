import re
import sys
from pathlib import Path

EXAMPLE_INPUT = """Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""


def possible_game(game_str, limits={"red": 12, "green": 13, "blue": 14}):
    "Return game_id if game is possible, else 0"
    [game_str, set_str] = game_str.split(": ")
    game_id = int(re.match("Game ([0-9]+)", game_str).group(1))
    sets_strs = [set_str.split(", ") for set_str in set_str.split("; ")]
    for set_str in sets_strs:
        for color_str in set_str:
            n_str, color = color_str.split(" ")
            n = int(n_str)
            if limits[color] < n:
                return 0
    return game_id


def main():
    input_text = Path(sys.argv[1]).read_text() if len(sys.argv) > 1 else EXAMPLE_INPUT
    scores = [possible_game(game_str) for game_str in input_text.splitlines()]
    print(sum(scores))


if __name__ == "__main__":
    main()
