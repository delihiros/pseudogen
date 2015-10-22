# -*- coding: utf-8 -*-

import sys
import re

def main():
    for i, l in enumerate(sys.stdin):
        l = re.sub(r'([()])', r' \1 ', l)
        tok_in = re.sub(r'\s+', r' ', l).strip().split()
        tok_out = []
        for i in range(1, len(tok_in)):
            if tok_in[i-1] != '(' and tok_in[i] not in ['(', ')']:
                tok_out.append(tok_in[i])
        print(' '.join(tok_out));           

if __name__ == '__main__':
    main()

