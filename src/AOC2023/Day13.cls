Class AOC2023.Day13 Extends AOC2023.Base
{

Parameter InputFile = "d13.txt";

// d ##class(AOC2023.Day13).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",cnt=1
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) {
			set cnt=cnt+1
			continue
		}
		set arr(cnt,$increment(arr(cnt)))=record
	}
	set arr=cnt
	if verbose zwrite arr
	set cnt="",sum=0
	for  {
		set cnt=$order(arr(cnt)) quit:cnt=""
		kill tempArr
		merge tempArr=arr(cnt)
		set sum=sum+..GetReflectionValue(.tempArr)
	}
	set answer=sum
	quit answer
}

ClassMethod GetReflectionValue(ByRef arr, value As %Integer = 0) As %Integer
{
	set left=..GetReflectionValueLeft(.arr,value#100)
	set up=..GetReflectionValueUp(.arr,value\100)
	set ans=up*100+left
	quit ans
}

ClassMethod GetReflectionValueLeft(ByRef tempArr, value As %Integer = 0) As %Integer
{
	set found=1,len=$length(tempArr(1))
	for x=1:1:len-1 {
		continue:x=value  //"... NEW different reflection..."
		set found=1
		for y=1:1:tempArr {
			if $extract(tempArr(y),x)'=$extract(tempArr(y),x+1) {
				set found=0
				quit
			}
}
		if found {
			for dx=1:1 {
				quit:x-dx<1
				quit:x+dx+1>len
				for y=1:1:tempArr {
					if $extract(tempArr(y),x-dx)'=$extract(tempArr(y),x+dx+1) {
						set found=0
						quit
					}
				}
				quit:'found
			}
		}
		return:found x
	}
	quit 0
}

ClassMethod GetReflectionValueUp(ByRef tempArr, value As %Integer = 0) As %Integer
{
	for y=1:1:tempArr-1 {
		continue:y=value  //"... NEW different reflection..."
		continue:tempArr(y)'=tempArr(y+1) 
		set found=1
		for dy=1:1 {
			quit:y-dy<1
			quit:y+dy+1>tempArr
			if tempArr(y-dy)'=tempArr(y+dy+1) {
				set found=0
				quit
			}
		}
		return:found y
	}
	quit 0
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",cnt=1
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) {
			set cnt=cnt+1
			continue
		}
		set arr(cnt,$increment(arr(cnt)))=record
	}
	set arr=cnt
	if verbose zwrite arr
	set cnt="",sum=0
	for  {
		set cnt=$order(arr(cnt)) quit:cnt=""
		kill tempArr
		merge tempArr=arr(cnt)
		set value=..GetReflectionValueSmudge(.tempArr,.newArr)
		if verbose zwrite newArr
		set sum=sum+value
	}
	set answer=sum
	quit answer
}

ClassMethod GetReflectionValueSmudge(ByRef arr, Output newArr) As %Integer
{
	kill newArr
	set len=$length(arr(1))
	set origValue=..GetReflectionValue(.arr)
	for y=1:1:arr {
		for x=1:1:len {
			set ltr=$extract(arr(y),x)
			set $extract(arr(y),x)=$select(ltr="#":".",1:"#")
			set value=..GetReflectionValue(.arr,origValue)
			if value {
				merge newArr=arr
				return value
			}
			set $extract(arr(y),x)=ltr
		}
	}
	quit 0
}

}

