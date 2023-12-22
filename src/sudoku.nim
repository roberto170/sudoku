import std/random
import std/strutils
import std/sequtils

type
    Sdk* = ref object
      tb : seq[seq[string]]

#print sudoku to console
proc print*(s : Sdk)=
    for l in s.tb :
        echo l

proc init(s : var Sdk,l,c : int)=
    for ll in 1..l :
        var f : seq[string]
        for cc in 1..c :
            f.add("123456789")
        s.tb.add(f)

proc filtro(s : var Sdk,l,c : int, ch : string)=
    for x in 0..8 :
        if x == c :
            continue
        if s.tb[l][x].len == 1 : continue
        s.tb[l][x] = s.tb[l][x].replace(ch,"")
        if s.tb[l][x].len == 1 :
            s.filtro(l,x,s.tb[l][x])
    for x in 0..8 :
        if x == l :
            continue
        if s.tb[x][c].len == 1 : continue
        s.tb[x][c] = s.tb[x][c].replace(ch,"")
        if s.tb[x][c].len == 1 :
            s.filtro(x,c,s.tb[x][c])
    var c1 = 0
    var l1 = 0
    if l < 3 :
        l1 = 0
    elif l < 6 :
        l1 = 3
    else:
        l1 = 6
    if c < 3 :
        c1 = 0
    elif c < 6 :
        c1 = 3
    else:
        c1 = 6
    for x in 0..2 :
        for y in 0..2:
            if x+l1 == l and y+c1 == c : continue
            if s.tb[x+l1][y+c1].len == 1 : continue
            s.tb[x+l1][y+c1] = s.tb[x+l1][y+c1].replace(ch,"")
            if s.tb[x+l1][y+c1].len == 1 :
                s.filtro(x+l1,y+c1,s.tb[x+l1][y+c1])

proc choice(s : var Sdk, l,c : int , ch : string = "")=
    if ch != "" :
        s.tb[l][c] = ch
        s.filtro(l,c,ch)
    else:
        var t = s.tb[l][c]
        var t2 = $(t[rand(0..t.len-1)])
        s.tb[l][c] = t2
        s.filtro(l,c,t2)

proc prox(s : Sdk):(int,int)=
    var h = 2
    while h < 9 :
        for l in 0..8:
            for c in 0..8:
                if s.tb[l][c].len == h :
                    return (l,c)
        h += 1

proc minus(a,b : string):string=
    var x = a
    for c in b :
        x = x.replace($(c),"")
    return x


proc priority(s : Sdk,l,c : int):string=
    var t = s.tb[l][c]
    for x in 0..8 :
        if x == l : continue
        t = minus(t,s.tb[x][c])
    if t != "" : return t
    t = s.tb[l][c]
    for x in 0..8 :
        if x == c : continue
        t = minus(t,s.tb[l][x])
    if t != "" : return t
    return t

#init sudoku, x param is how many numbers from solution to erase (set to "0")
#example to 20 hints do : 
#     var d = Sdk()
#     d.generate(81-20)
proc generate*(s : var Sdk, x : int)=
    s.init(9,9)
    while true :
        var g = s.prox()
        if s.tb[g[0]][g[1]].len == 1 : break
        var e = s.priority(g[0],g[1])
        s.choice(g[0],g[1],e)
    var t = x
    while t > 0 :
        var l = rand(0..8)
        var c = rand(0..8)
        if s.tb[l][c] == "0" : continue
        s.tb[l][c] = "0"
        t -= 1


proc hasDup(x : seq[string]):bool=
    var t = deduplicate(x)
    if t.len == x.len : return false
    return true

#return false if sudoku contains error or true if OK
#ignores cell with "0" blank state
proc check*(s : Sdk):bool=
    var x1 : int
    var w : string
    var v : seq[string]
    for x in 0..8 :
        for y in 0..8 :
            w = s.tb[x][y]
            x1 = x
            if w != "0" : v.add(w)
        if v.hasDup() : return false
        v = @[]
    for x in 0..8 :
        for y in 0..8 :
            w = s.tb[y][x]
            x1 = x
            if w != "0" : v.add(w)
        if v.hasDup() : return false
        v = @[]
    for x in countup(0,8,3) :
        for y in countup(0,8,3) :
            for e  in 0..2 :
                for f in 0..2 :
                    w = s.tb[e+x][f+y]
                    x1 = e+x
                    if w != "0" : v.add(w)
            if v.hasDup() : return false
            v = @[]
    return true

randomize()
