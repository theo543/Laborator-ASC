import random
import numpy
import subprocess
import argparse
import os
from numpy.linalg import matrix_power
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source0")
    parser.add_argument("source1")
    parser.add_argument("--tests", type=int, default=1000)
    parser.add_argument("--smin", type=int, default=1)
    parser.add_argument("--smax", type=int, default=100)
    args = parser.parse_args()
    source0 = args.source0
    source1 = args.source1
    exec0 = "./" + source0.replace(".s", "")
    exec1 = "./" + source1.replace(".s", "")
    tests = args.tests
    smin = args.smin
    smax = args.smax
    os.system(f"gcc -m32 {source0} -o {exec0}")
    os.system(f"gcc -m32 {source1} -o {exec1}")
    for testnr in range(tests):
        size = random.randint(smin, smax)
        matrix = [[random.randint(0, 1) for _ in range(size)] for _ in range(size)]
        adj = [[] for _ in range(size)]
        for i, line in enumerate(matrix):
            for j, val in enumerate(line):
                if val:
                    adj[i].append(j)
        input = f"{size}\n"
        for node in adj:
            input += f"{len(node)}"
            input += '\n'
        for node in adj:
            for edge in node:
                input += f"{edge} "
            input += '\n'
        proc1 = subprocess.run([exec0], input="1 " + input, capture_output=True, text=True)
        out1 = [int(x) for x in proc1.stdout.split()]
        proc2 = subprocess.run([exec1], input="1 " + input, capture_output=True, text=True)
        out2 = [int(x) for x in proc2.stdout.split()]
        def flatten_list(l):
            return [item for sublist in l for item in sublist]
        if not (out1 == out2 == flatten_list(matrix)):
            print(f"Input (without req):\n{input}\nReturn code 1: {proc1.returncode}, return code 2: {proc2.returncode}")
            break
        plen = random.randint(1, 5) # higher causes overflows
        src = random.randint(0, size - 1)
        dst = random.randint(0, size - 1)
        input += f"\n{plen}\n{src}\n{dst}\n"
        proc1 = subprocess.run([exec0], input="2 " + input, capture_output=True, text=True)
        proc2 = subprocess.run([exec1], input="3 " + input, capture_output=True, text=True)
        matpow = numpy.array(matrix)
        matpow = matrix_power(matpow, plen)
        if proc1.returncode or proc2.returncode or not (matpow[src][dst] == int(proc1.stdout) == int(proc2.stdout)):
            if matpow[src][dst] > 2147483647 or matpow[src][dst] < -2147483648:
                print("32bit int overflow")
                continue
            print(f"Tester's answer: {matpow[src][dst]}, program 1 answer: {proc1.stdout}, program 2 answer: {proc2.stdout}")
            print(f"Input (without req):\n{input}\nReturn code 1: {proc1.returncode}, return code 2: {proc2.returncode}")
            break
        else: print(f"Test {testnr} passed")
    print("Done")

if __name__ == '__main__':
    main()
