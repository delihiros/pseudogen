#!/usr/bin/python3

import sys
import re

def main():
    p_punct = re.compile(r'([^A-Za-z0-9_ ])')
    p_sp = re.compile(r'\s+')
    
    for l in sys.stdin:
        l = re.sub(p_punct, r' \1 ', l)
        l = re.sub(p_sp, r' ', l)
        l = l.replace('"', '`')
        l = l.replace('\'', '`')
        l = l.strip()
        print(l)
        

if __name__ == '__main__':
    main()


