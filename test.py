import subprocess
import sys
import time

def print_progress_bar(iteration, total, prefix='', suffix='', decimals=1, length=50, fill='█'):
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filled_length = int(length * iteration // total)
    bar = fill * filled_length + '-' * (length - filled_length)
    sys.stdout.write('\r%s |%s| %s%% %s' % (prefix, bar, percent, suffix))
    sys.stdout.flush()

def run_main_multiple_times(num_times, output_file):
    start_time = time.time()

    with open(output_file, 'w') as f:
        for i in range(num_times):
            result = subprocess.run(['python', 'main.py'], capture_output=True, text=True)
            f.write(f"Output {i+1}:\n")
            f.write(result.stdout)
            f.write("\n\n")
            print_progress_bar(i + 1, num_times, prefix='Progress:', suffix='Complete', length=50)

    end_time = time.time()
    total_time = end_time - start_time
    print("\nTotal time taken:", total_time, "seconds")

tests = 500

etpo = 0.113634756565094
hours = int(tests * etpo / 3600)
minutes = int((tests * etpo % 3600) / 60)
seconds = int(tests * etpo % 60)
print(f'Estimated time: {hours:02d}:{minutes:02d}:{seconds:02d}')

run_main_multiple_times(tests, "output.txt")
