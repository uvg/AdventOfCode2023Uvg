Class AOC2023.Day01 Extends AOC2023.Base
{

Parameter InputFile = "d01.txt";

// d ##class(AOC2023.Day01).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set num=$zstrip(record,"*A")
		set calibration=$extract(num)_$extract(num,*)
		set total=total+calibration
		if verbose write !,line,"=",calibration,";",total
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	kill sumArr
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set (first,last)=""
		for i=1:1:$length(record) {
			set first=..GetDigit(record,i)
			quit:first
		}
		for i=$length(record):-1:1 {
			set last=..GetDigit(record,i)
			quit:last
		}
		set calibration=first_last
		set total=total+calibration
		if verbose write !,line,"=",calibration,";",total
	}
	set answer=total
	quit answer
}

ClassMethod GetDigit(record As %String, position As %Integer) As %Integer
{
	set digit=$extract(record,position)
	if 123456789[digit quit digit
	for i=3:1:5 {
		if $extract(record,position,position+i-1)="one" return 1
		if $extract(record,position,position+i-1)="two" return 2
		if $extract(record,position,position+i-1)="three" return 3
		if $extract(record,position,position+i-1)="four" return 4
		if $extract(record,position,position+i-1)="five" return 5
		if $extract(record,position,position+i-1)="six" return 6
		if $extract(record,position,position+i-1)="seven" return 7
		if $extract(record,position,position+i-1)="eight" return 8
		if $extract(record,position,position+i-1)="nine" return 9
	}
	quit 0
}

}

