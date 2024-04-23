def color(s, r1, r2, y1, y2):
    a = bin(s)[2:]
    yellow_range = range(y1, y2)
    red_range = range(r1, r2)
    return ''.join([
        '\033[91m{}\033[0m'.format(char) if idx in red_range and idx in yellow_range else
        '\033[93m{}\033[0m'.format(char) if idx in yellow_range else
        '\033[91m{}\033[0m'.format(char) if idx in red_range else char
        for idx, char in enumerate(a)
    ])