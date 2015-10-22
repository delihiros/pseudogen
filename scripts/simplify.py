import sys
from nltk.tree import Tree

def at(tree, label):
    for ch in tree:
        if ch.label() == label:
            return ch
    raise ValueError('not found')

RULES = [
    (
        lambda t: t.label() == 'body' and t[0].label() == 'list' and t[0][0].label() == 'Pass'
        ,
        lambda t: None
    ),(
        lambda t: t.label() == 'ctx'
        ,
        lambda t: None
    ),(
        lambda t: t.label() in ['kwarg', 'kwargs', 'starargs'] and t[0].label() == 'NoneType'
        ,
        lambda t: None
    ),(
        lambda t: t.label() == 'Name'
        ,
        lambda t: Tree('Name', [at(at(t, 'id'), 'str')[0]])
    ),(
        lambda t: t.label() == 'Num'
        ,
        lambda t: Tree('Num', [at(t, 'n')[0][0]])
    ),(
        lambda t: t.label() == 'BinOp'
        ,
        lambda t: Tree('BinOp', [
            Tree('left', [at(t, 'left')[0]]),
            Tree('op', [at(t, 'op')[0][0]]),
            Tree('right', [at(t, 'right')[0]])
        ])
    ),(
        lambda t: t.label() == 'UnaryOp'
        ,
        lambda t: Tree('UnaryOp', [
            Tree('op', [at(t, 'op')[0][0]]),
            Tree('operand', [at(t, 'operand')[0]])
        ])
    ),(
        lambda t: t.label() == 'Compare'
        ,
        lambda t: Tree('Compare', [
            Tree('left', [at(t, 'left')[0]]),
            Tree('ops', [at(t, 'ops')[0]]),
            Tree('comparators', [at(t, 'comparators')[0]]),
        ])
    )
]

def simplify(tree):
    if isinstance(tree, str):
        return tree

    ret = Tree(tree.label(), [])
    for ch in tree:
        newch = simplify(ch)
        if newch is None:
            continue
        ret.append(newch)
    if len(ret) == 0:
        ret.append('None')

    for cond, modif in RULES:
        if cond(ret):
            ret = modif(ret)
            if ret is None:
                break
    return ret

def encode(tree):
    if isinstance(tree, Tree):
        ret = '(' + tree.label()
        for ch in tree:
            ret += ' ' + encode(ch)
        return ret + ')'
    else:
        return str(tree)

def main():
    for l in sys.stdin:
        tree = Tree.fromstring(l)
        tree = simplify(tree)
        print(encode(tree))
        sys.stdout.flush()

if __name__ == '__main__':
    main()

