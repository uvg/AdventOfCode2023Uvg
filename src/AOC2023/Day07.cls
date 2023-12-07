Class AOC2023.Day07 Extends AOC2023.Base
{

Parameter InputFile = "d07.txt";

// d ##class(AOC2023.Day07).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set cards=$piece(record," ",1),bid=$piece(record," ",2)
		set res=..GetKindOfWin(cards),kindOfWin=$list(res,1),value=$list(res,2)
		if $increment(arr(kindOfWin)) set arr(kindOfWin,value)=$listbuild(cards,+bid)
	}
	if verbose write ! zwrite arr
	set kindOfWin="",rank=0,totalRank=0
	for  {
		set kindOfWin=$order(arr(kindOfWin),-1) quit:kindOfWin=""
		set key=""
		for  {
			set key=$order(arr(kindOfWin,key),-1) quit:key=""
			set data=arr(kindOfWin,key),cards=$list(data,1),bid=$list(data,2)
			set rank=rank+1
			set curRank=rank*bid
			set totalRank=curRank+totalRank
			if verbose write !,rank,?10,kindOfWin,?15,cards,?25,bid,?35,curRank,?50,totalRank
		}
	}
	set answer=totalRank
	quit answer
}

ClassMethod GetKindOfWin(cards As %String) As %String
{
	set cardsVal=0,mul=15*15*15*15,cardSym=..GetCardSym()
	for i=1:1:5 {
		set card=$extract(cards,i)
		set card(i)=card
		set arr(card)=$get(arr(card))+1
		set cardVal=$find(cardSym,card)
		set cardsVal=cardVal*mul+cardsVal,mul=mul/15
	}
	//write !,cards,"=",cardsVal
	set card=""
	for  {
		set card=$order(arr(card)) quit:card=""
		set amount=arr(card)
		set arrA(amount,card)=""
	}
	if $data(arrA(5)) quit $listbuild(1,cardsVal)
	if $data(arrA(4)) quit $listbuild(2,cardsVal)
	if $data(arrA(3)),$data(arrA(2)) quit $listbuild(3,cardsVal)
	if $data(arrA(3)) quit $listbuild(4,cardsVal)
	if '$data(arrA(2)) quit $listbuild(7,cardsVal)
	if $order(arrA(2,""))=$order(arrA(2,""),-1) quit $listbuild(6,cardsVal)
	quit $listbuild(5,cardsVal)
}

ClassMethod GetCardSym() As %String
{
	quit "AKQJT98765432"
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set cards=$piece(record," ",1),bid=$piece(record," ",2)
		set res=..GetKindOfWin2(cards),kindOfWin=$list(res,1),value=$list(res,2)
		if $increment(arr(kindOfWin)) set arr(kindOfWin,value)=$listbuild(cards,+bid)
	}
	if verbose write ! zwrite arr
	set kindOfWin="",rank=0,totalRank=0
	for  {
		set kindOfWin=$order(arr(kindOfWin),-1) quit:kindOfWin=""
		set key=""
		for  {
			set key=$order(arr(kindOfWin,key),-1) quit:key=""
			set data=arr(kindOfWin,key),cards=$list(data,1),bid=$list(data,2)
			set rank=rank+1
			set curRank=rank*bid
			set totalRank=curRank+totalRank
			if verbose write !,rank,?10,kindOfWin,?15,cards,?25,bid,?35,curRank,?50,totalRank
		}
	}
	set answer=totalRank
	quit answer
}

ClassMethod GetKindOfWin2(cards As %String) As %String
{
	set cardsVal=0,mul=15*15*15*15,cardSym=..GetCardSym2(),countJ=0
	for i=1:1:5 {
		set card=$extract(cards,i)
		set card(i)=card
		if card="J" set countJ=countJ+1
		set arr(card)=$get(arr(card))+1
		set cardVal=$find(cardSym,card)
		set cardsVal=cardVal*mul+cardsVal,mul=mul/15
	}
	//write !,cards,"=",cardsVal,"...",countJ," joker(s)"
	set card=""
	for  {
		set card=$order(arr(card)) quit:card=""
		set amount=arr(card)
		set arrA(amount,card)=""
	}
	if $data(arrA(5)) quit $listbuild(1,cardsVal)  //Five of a kind
	if cards'["J" {
		if $data(arrA(4)) quit $listbuild(2,cardsVal)  //Four of a kind
		if $data(arrA(3)),$data(arrA(2)) quit $listbuild(3,cardsVal)  //Full house
		if $data(arrA(3)) quit $listbuild(4,cardsVal)  //Three of a kind
		if '$data(arrA(2)) quit $listbuild(7,cardsVal)  //High card
		if $order(arrA(2,""))=$order(arrA(2,""),-1) quit $listbuild(6,cardsVal)  //One pair
		quit $listbuild(5,cardsVal)  //Two pair
	}
	if $data(arrA(4)) quit $listbuild(1,cardsVal)  //Five of a kind
	if $data(arrA(3)),$data(arrA(2)) quit $listbuild(1,cardsVal)  //Five of a kind
	if $data(arrA(3)) quit $listbuild(2,cardsVal)  //Four of a kind
	if $order(arrA(2,""))'=$order(arrA(2,""),-1),countJ=2 quit $listbuild(2,cardsVal)  //Four of a kind
	if $order(arrA(2,""))'=$order(arrA(2,""),-1) quit $listbuild(3,cardsVal)  //Full house
	if $data(arrA(2)) quit $listbuild(4,cardsVal)  //Three of a kind
	quit $listbuild(6,cardsVal)  //One pair
}

ClassMethod GetCardSym2() As %String
{
	quit "AKQT98765432J"
}

}

