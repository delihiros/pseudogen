from nltk.tree import Tree
import sys

def insert_head(t):
    if isinstance(t, Tree):
        for ch in t:
            insert_head(ch)
        if t.label()[0].isupper() and not isinstance(t[0], str):
            t.insert(0, Tree('HEAD', [t.label()]))

def encode(t):
    if isinstance(t, Tree):
        ret = '(' + t.label()
        for ch in t:
            ret += ' ' + encode(ch)
        return ret + ')'
    else:
        return str(t)


def main():
    for l in sys.stdin:
        t = Tree.fromstring(l)
        insert_head(t)
        print(encode(t))
        sys.stdout.flush()


if __name__ == '__main__':
    main()

