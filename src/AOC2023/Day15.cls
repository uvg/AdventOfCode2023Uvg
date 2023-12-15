Class AOC2023.Day15 Extends AOC2023.Base
{

Parameter InputFile = "d15.txt";

// d ##class(AOC2023.Day15).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",data=recordsArr(1),sum=0
	for i=1:1:$length(data,",") {
		set str=$piece(data,",",i)
		set hash=..Hash256(str)
		if verbose write !,str,?15,hash
		set sum=sum+hash
	}
	set answer=sum
	quit answer
}

ClassMethod Hash256(str As %String) As %Integer
{
	set hash=0
	for i=1:1:$length(str) {
		set hash=hash+$ascii(str,i)*17#256
	}
	quit hash
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",data=recordsArr(1),sum=0
	for i=1:1:$length(data,",") {
		set str=$piece(data,",",i)
		set label=$piece($piece(str,"-",1),"=",1)
		set operation="-" set:str["=" operation="="
		set value=$piece(str,operation,2)
		set position=..Hash256(label)
		do ..Operation(.arr,label,operation,value,position)
		if verbose write !,label,?10,operation,?15,value
	}
	if verbose write ! zwrite arr
	set box=""
	for  {
		set box=$order(arr(box)) quit:box=""
		set data=arr(box)
		for i=1:1:$listlength(data) {
			set sum=(box+1)*i*arr(box,$list(data,i))+sum
		}
	}
	set answer=sum
	quit answer
}

ClassMethod Operation(ByRef arr, label As %String, operation As %String, value As %Integer, position As %Integer)
{
	if operation="=" {
		if $data(arr(position,label)) {
			set arr(position,label)=value
			quit
		}
		set arr(position)=$select('$length($get(arr(position))):$listbuild(label),1:arr(position)_$listbuild(label))
		set arr(position,label)=value
		quit
	}
	if operation="-",$data(arr(position,label)) {
		kill arr(position,label)
		set find=$listfind(arr(position),label)
		set arr(position)=$list(arr(position),1,find-1)_$list(arr(position),find+1,*)
	}
}

}

