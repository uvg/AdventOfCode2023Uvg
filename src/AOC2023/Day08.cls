Class AOC2023.Day08 Extends AOC2023.Base
{

Parameter InputFile = "d08.txt";

// d ##class(AOC2023.Day08).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",inst=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:'$length(record)
		if '$length(inst) {
			set inst=record
			continue
		}
		set from=$piece(record," = ",1),to=$piece(record," = ",2)
		set left=$piece($piece(to,", ",1),"(",2),right=$piece($piece(to,", ",2),")",1)
		set arr(from)=$listbuild(left,right)
	}
	if verbose zwrite arr,inst
	set from="AAA",to="ZZZ",steps=0,ip=1,lenInst=$length(inst)
	for  {
		quit:from=to
		set data=arr(from),curInst=$extract(inst,ip)
		set from=$list(data,$select(curInst="L":1,1:2))
		set steps=steps+1,ip=ip+1
		set:ip>lenInst ip=1
	}
	set answer=steps
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",inst=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:'$length(record)
		if '$length(inst) {
			set inst=record
			continue
		}
		set from=$piece(record," = ",1),to=$piece(record," = ",2)
		set left=$piece($piece(to,", ",1),"(",2),right=$piece($piece(to,", ",2),")",1)
		set arr(from)=$listbuild(left,right)
	}
	set from="" for  {
		set from=$order(arr(from)) quit:from=""
		if $extract(from,*)="A" set arrFrom(from)=""
	}
	set from="",lenInst=$length(inst)
	for  {
		set steps=0,ip=1
		set from=$order(arrFrom(from)) quit:from=""
		set next=from
		for  {
			if $extract(next,*)="Z" {
				set arrSteps(steps)=""
				kill divisors
				do ..GetDivisors(steps,.divisors)
				kill divisors(1),divisors(steps)
				merge arrDivs=divisors
				quit
			}
			set data=arr(next),curInst=$extract(inst,ip)
			set next=$list(data,$select(curInst="L":1,1:2))
			set steps=steps+1,ip=ip+1
			set:ip>lenInst ip=1
		}
	}
	if verbose zwrite arr,inst,arrFrom,arrSteps,arrDivs
	set mul=1,div=""
	for  {
		set div=$order(arrDivs(div)) quit:div=""
		set mul=mul*div
	}
	set answer=mul
	quit answer
}

ClassMethod GetDivisors(Number As %Integer, Output DivisorsArray) As %Integer
{
	kill DivisorsArray
	set DivisorsArray(1)="",DivisorsArray(Number)=""
	if Number=1 {
		quit 1
	}
	set to=Number**.5\1,totalDiv=2
	for i=2:1:to {
		if Number'=i,'(Number#i) {
			set DivisorsArray(i)="",totalDiv=totalDiv+1
			if Number/i>i {
				set DivisorsArray(Number/i)="",totalDiv=totalDiv+1
			}
		}
	}
	quit totalDiv
}

}

