import random
import numpy
import subprocess
from numpy.linalg import matrix_power
def main():
    subprocess.run("./compile.sh")
    tests = 1000
    smin = 1
    smax = 100
    for _ in range(tests):
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
        proc1 = subprocess.run(["./151_Negrescu_Theodor_0"], input="1 " + input, capture_output=True, text=True)
        matrix1 = [[int(x) for x in line.split()] for line in proc1.stdout.splitlines()]
        proc2 = subprocess.run(["./151_Negrescu_Theodor_1"], input="1 " + input, capture_output=True, text=True)
        matrix2 = [[int(x) for x in line.split()] for line in proc2.stdout.splitlines()]
        if not (matrix1 == matrix == matrix2):
            print(f"Input (without req):\n{input}\nReturn code 1: {proc1.returncode}, return code 2: {proc2.returncode}")
            break
        plen = random.randint(1, 5)
        src = random.randint(0, size - 1)
        dst = random.randint(0, size - 1)
        input += f"\n{plen}\n{src}\n{dst}\n"
        proc1 = subprocess.run(["./151_Negrescu_Theodor_0"], input="2 " + input, capture_output=True, text=True)
        proc2 = subprocess.run(["./151_Negrescu_Theodor_1"], input="3 " + input, capture_output=True, text=True)
        matpow = numpy.array(matrix)
        matpow = matrix_power(matpow, plen)
        if proc1.returncode or proc2.returncode or not (matpow[src][dst] == int(proc1.stdout) == int(proc2.stdout)):
            # 2147483647 = 2^31 - 1
            if matpow[src][dst] > 2147483647:
                print("int overflow")
                continue
            print(f"Tester's answer: {matpow[src][dst]}, program 1 answer: {proc1.stdout}, program 2 answer: {proc2.stdout}")
            print(f"Input (without req):\n{input}\nReturn code 1: {proc1.returncode}, return code 2: {proc2.returncode}")
            break
    pass

if __name__ == '__main__':
    main()
