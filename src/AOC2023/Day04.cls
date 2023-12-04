Class AOC2023.Day04 Extends AOC2023.Base
{

Parameter InputFile = "d04.txt";

// d ##class(AOC2023.Day04).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set cards=$piece(record,": ",2)
		kill winningCards
		set winningCards=$zstrip($piece(cards," | ",1),"<>W")
		set myCards=$zstrip($piece(cards," | ",2),"<>W")
		for i=1:1:$length(winningCards," ") {
			set winningCard=+$piece(winningCards," ",i)
			set:winningCard winningCards(winningCard)=""
		}
		set wins=0
		for i=1:1:$length(myCards," ") {
			set myCard=+$piece(myCards," ",i)
			if $data(winningCards(myCard)) set wins=wins+1
		}
		if verbose write record," > ",wins,!
		if wins set total=2**(wins-1)+total
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line),totalCards(line)=$get(totalCards(line))+1
		set cards=$piece(record,": ",2)
		kill winningCards
		set winningCards=$zstrip($piece(cards," | ",1),"<>W")
		set myCards=$zstrip($piece(cards," | ",2),"<>W")
		for i=1:1:$length(winningCards," ") {
			set winningCard=+$piece(winningCards," ",i)
			set:winningCard winningCards(winningCard)=""
		}
		set wins=0,total=total+totalCards(line)
		for i=1:1:$length(myCards," ") {
			set myCard=+$piece(myCards," ",i)
			if $data(winningCards(myCard)) set wins=wins+1
		}
		if wins {
			for i=line+1:1:line+wins {
				set totalCards(i)=$get(totalCards(i))+totalCards(line)
			}
		}
		if verbose write !,line,! zwrite totalCards
	}
	set answer=total
	quit answer
}

}

