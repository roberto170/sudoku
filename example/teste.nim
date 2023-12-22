import sudoku

var d = Sdk()
d.generate(81-20) #generate a sudoku with 20 hints
d.print() #print to console
echo d.check() #check returns false if sudoku have errors, ignore cells set to "0"
