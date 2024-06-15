import random

def generate_random_40bit_value():
    return ''.join(random.choice('01') for _ in range(40))

def generate_vectors():
    vectors = []

    # Left edge cases
    for i in range(8):
        original_data = generate_random_40bit_value()
        error_pattern = '1' * (i + 1) + '0' * (7 - i)
        shift_amount = 56
        vectors.append(f"{original_data} {error_pattern} {shift_amount}")

    # Right edge cases
    for i in range(8):
        original_data = generate_random_40bit_value()
        error_pattern = '0' * (7 - i) + '1' * (i + 1)
        shift_amount = 0
        vectors.append(f"{original_data} {error_pattern} {shift_amount}")

    # No change cases
    for _ in range(4):
        original_data = generate_random_40bit_value()
        error_pattern = '00000000'
        shift_amount = 0
        vectors.append(f"{original_data} {error_pattern} {shift_amount}")

    # Random errors and shifts
    for _ in range(80):
        original_data = generate_random_40bit_value()
        error_pattern = ''.join(random.choice('01') for _ in range(8))
        shift_amount = random.randint(0, 56)
        vectors.append(f"{original_data} {error_pattern} {shift_amount}")

    return vectors

def write_vectors_to_file(filename, vectors):
    with open(filename, 'w') as f:
        for vector in vectors:
            f.write(f"{vector}\n")

if __name__ == "__main__":
    vectors = generate_vectors()
    write_vectors_to_file("./python/input_data.txt", vectors)
    print("Generated 100 vectors and saved to input_data.txt")
