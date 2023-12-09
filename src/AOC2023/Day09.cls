Class AOC2023.Day09 Extends AOC2023.Base
{

Parameter InputFile = "d09.txt";

// d ##class(AOC2023.Day09).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set nextValue=..GetNextValue(record)+$piece(record," ",*)
		if verbose write !,record," = ",nextValue
		set total=total+nextValue
	}
	set answer=total
	quit answer
}

ClassMethod GetNextValue(data As %String) As %Integer
{
	set nextData="",allZeros=1
	for i=1:1:$length(data," ")-1 {
		set num=$piece(data," ",i)
		set nextNum=$piece(data," ",i+1)
		set diff=nextNum-num
		set:diff allZeros=0
		set $piece(nextData," ",i)=diff
	}
	quit:allZeros 0
	quit ..GetNextValue(nextData)+$piece(nextData," ",*)
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set prevValue=$piece(record," ")-..GetPrevValue(record)
		if verbose write !,record," = ",prevValue
		set total=total+prevValue
	}
	set answer=total
	quit answer
}

ClassMethod GetPrevValue(data As %String) As %Integer
{
	set nextData="",allZeros=1
	for i=1:1:$length(data," ")-1 {
		set num=$piece(data," ",i)
		set nextNum=$piece(data," ",i+1)
		set diff=nextNum-num
		set:diff allZeros=0
		set $piece(nextData," ",i)=diff
	}
	quit:allZeros 0
	quit $piece(nextData," ")-..GetPrevValue(nextData)
}

}

