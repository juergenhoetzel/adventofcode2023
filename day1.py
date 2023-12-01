from pathlib import Path


test_input_text = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""".splitlines()

input_text = Path("input/day1.txt").read_text()

sum = 0
for line in input_text.splitlines():
    digits = [int(c) for c in line if c.isdigit()]
    sum += digits[0] * 10 + digits[-1]
print(sum)
