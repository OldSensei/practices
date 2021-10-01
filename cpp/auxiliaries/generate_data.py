#! python3

import random
import sys

default_number_count = 300
default_test_data_filename = "data.bin"

def generate_data(length):
    return [num.to_bytes(4, "little") for num in random.sample(range(1000), length)]
    
if __name__ == "__main__":
    args_count = len(sys.argv)
    data_count = default_number_count
    filename = default_test_data_filename

    if (args_count == 3):
        data_count = int(sys.argv[1])
        filename = sys.argv[2]
    elif (args_count == 2):
        data_count = int(sys.argv[1])

    data = generate_data(data_count)

    with open(filename, "wb") as f:
        f.write(data_count.to_bytes(4, "little"))
        for b in data:
            f.write(b)