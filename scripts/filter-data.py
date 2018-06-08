import sys

def main():
    a = open(sys.argv[1])
    b = open(sys.argv[2])
    c = open(sys.argv[3])
    for al, bl, cl in zip(a, b, c):
        al, bl, cl = al.strip(), bl.strip(), cl.strip()
        if al != '' and bl != '' and cl != '':
            print('\t'.join([al, bl, cl]))

if __name__ == '__main__':
    main()