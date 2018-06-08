#!/usr/bin/python2

import tokenize
import re
import sys

def escape(text):
    text = text \
        .replace('"', '`') \
        .replace('\'', '`') \
        .replace(' ', '-SP-') \
        .replace('\t', '-TAB-') \
        .replace('\n', '-NL-') \
        .replace('(', '-LRB-') \
        .replace(')', '-RRB-') \
        .replace('|', '-BAR-')
    return repr(text)[1:-1] if text else '-NONE-'

class Readable:
    def __init__(self, text):
        self.__text = text.strip()
        self.__p = True
    def readline(self, size=-1):
        if self.__p:
            self.__p = False
            return self.__text
        else:
            raise StopIteration()

def main():
    p_elif = re.compile(r'^elif\s')
    p_else = re.compile(r'^else\s')
    p_try = re.compile(r'^try\s')
    p_except = re.compile(r'^except\s')
    p_finally = re.compile(r'^finally\s')
    p_decorator = re.compile(r'^@.*')

    for l in sys.stdin:
        try:
            l = l.strip()
            if not l:
                print()
                continue

            if p_elif.match(l): l = 'if True: pass\n' + l
            if p_else.match(l): l = 'if True: pass\n' + l

            if p_try.match(l): l = l + 'pass\nexcept: pass'
            elif p_except.match(l): l = 'try: pass\n' + l
            elif p_finally.match(l): l = 'try: pass\n' + l
            
            if p_decorator.match(l): l = l + '\ndef dummy(): pass'
            if l[-1] == ':': l = l + 'pass'
            
            toks = [escape(t[1]) for t in tokenize.generate_tokens(Readable(l).readline)]

            print(' '.join(toks[:-1]))
        except Exception as e:
            print()

if __name__ == '__main__':
    main()

