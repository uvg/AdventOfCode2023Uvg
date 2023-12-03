Class AOC2023.Day03 Extends AOC2023.Base
{

Parameter InputFile = "d03.txt";

// d ##class(AOC2023.Day03).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",recordLen=$length(recordsArr(1))
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set num=""
		for x=1:1:$length(record) {
			set ltr=$extract(record,x)
			if ltr="." {
				if num'="" {
					set numbers(num,$increment(numbers(num)))=$listbuild(line,x-$length(num),x-1)
					set num=""
				}
				continue
			}
			if ltr'=".",ltr'?1n {
				set symobls(line,x)=ltr
				if num'="" {
					set numbers(num,$increment(numbers(num)))=$listbuild(line,x-$length(num),x-1)
					set num=""
				}
				continue
			}
			if ltr?1n {
				if num="" {
					set num=ltr
					continue
				} else {
					set num=num_ltr
				}
			}
			if x=recordLen,num'="" {
				set numbers(num,$increment(numbers(num)))=$listbuild(line,x-$length(num)+1,x)
			}
		}
	}
	if verbose zwrite numbers,symobls
	set number="",total=0
	for  {
		set number=$order(numbers(number)) quit:number=""
		set cnt=""
		for  {
			set cnt=$order(numbers(number,cnt)) quit:cnt=""
			set data=numbers(number,cnt)
			set fromY=$list(data,1),fromX=$list(data,2),toX=$list(data,3)
			if ..IsSymbolAround(.symobls,fromX,toX,fromY) {
				set total=total+number
				if verbose write !,number
			}
		}
	}
	set answer=total
	quit answer
}

ClassMethod IsSymbolAround(ByRef symobls, fromX, toX, fromY)
{
	for x=fromX-1:1:toX+1 {
		for y=fromY-1:1:fromY+1 {
			if $data(symobls(y,x)) return 1
		}
	}
	quit 0
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",recordLen=$length(recordsArr(1))
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set num=""
		for x=1:1:$length(record) {
			set ltr=$extract(record,x)
			if ltr="." {
				if num'="" {
					set numbers(num,$increment(numbers(num)))=$listbuild(line,x-$length(num),x-1)
					set num=""
				}
				continue
			}
			if ltr'=".",ltr'?1n {
				if ltr="*" set symobls(line,x)=ltr
				if num'="" {
					set numbers(num,$increment(numbers(num)))=$listbuild(line,x-$length(num),x-1)
					set num=""
				}
				continue
			}
			if ltr?1n {
				if num="" {
					set num=ltr
					continue
				} else {
					set num=num_ltr
				}
			}
			if x=recordLen,num'="" {
				set numbers(num,$increment(numbers(num)))=$listbuild(line,x-$length(num)+1,x)
			}
		}
	}
	if verbose zwrite numbers,symobls
	set y="",total=0
	for  {
		set y=$order(symobls(y)) quit:y=""
		set x=""
		for  {
			set x=$order(symobls(y,x)) quit:x=""
			if ..GetNumbersAroundCount(x,y,.numbers)=2 {
				if verbose write y,",",x,!
				set total=total+..GetNumbersAroundTotal(x,y,.numbers)
			}
		}
	}
	set answer=total
	quit answer
}

ClassMethod GetNumbersAroundCount(x, y, ByRef numbers)
{
	set number="",count=0
	for  {
		set number=$order(numbers(number)) quit:number=""
		set cnt=""
		for  {
			set cnt=$order(numbers(number,cnt)) quit:cnt=""
			set data=numbers(number,cnt)
			set fromY=$list(data,1),fromX=$list(data,2),toX=$list(data,3)
			if $zabs(fromY-y)<=1,($zabs(fromX-x)<=1)||($zabs(toX-x)<=1) set count=count+1
		}
	}
	quit count
}

ClassMethod GetNumbersAroundTotal(x, y, ByRef numbers)
{
	set number="",total=1
	for  {
		set number=$order(numbers(number)) quit:number=""
		set cnt=""
		for  {
			set cnt=$order(numbers(number,cnt)) quit:cnt=""
			set data=numbers(number,cnt)
			set fromY=$list(data,1),fromX=$list(data,2),toX=$list(data,3)
			if $zabs(fromY-y)<=1,($zabs(fromX-x)<=1)||($zabs(toX-x)<=1) set total=total*number
		}
	}
	quit total
}

}

