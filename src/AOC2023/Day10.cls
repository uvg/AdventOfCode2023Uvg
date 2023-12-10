Class AOC2023.Day10 Extends AOC2023.Base
{

Parameter InputFile = "d10.txt";

// d ##class(AOC2023.Day10).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",fromX="",fromY=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:record'["S"
		set fromY=line,fromX=$find(record,"S")-1
		quit
	}
	if verbose write !,fromX,",",fromY
	set answer=..GetPipePathAndLength(fromX,fromY,.recordsArr)/2
	quit answer
}

ClassMethod GetPipePathAndLength(fromX As %Integer, fromY As %Integer, ByRef grid, Output visited) As %Integer
{
	kill visited
	set right=$extract(grid(fromY),fromX+1)
	set left=$extract(grid(fromY),fromX-1)
	set up=$extract($get(grid(fromY-1)),fromX)
	set down=$extract($get(grid(fromY+1)),fromX)
	if $length(left),"-LF"[left quit ..RunOnPath(1,fromX-1,fromY,.grid,.visited)+1
	if $length(right),"-J7"[right quit ..RunOnPath(2,fromX+1,fromY,.grid,.visited)+1
	if $length(up),"|7F"[up quit ..RunOnPath(3,fromX,fromY-1,.grid,.visited)+1
	if $length(down),"|LJ"[down quit ..RunOnPath(4,fromX,fromY+1,.grid,.visited)+1
	quit 0
}

ClassMethod RunOnPath(curDir As %Integer, fromX As %Integer, fromY As %Integer, ByRef grid, Output visited) As %Integer
{
	kill visited
	set steps=0,x=fromX,y=fromY
	for  {
		quit:$data(visited(x,y))
		set visited(x,y)=""
		set ltr=$extract(grid(y),x)
		if curDir=1,ltr="-" {
			set steps=steps+1,x=x-1
			continue
		}
		if curDir=1,ltr="L" {
			set steps=steps+1,y=y-1,curDir=3
			continue
		}
		if curDir=1,ltr="F" {
			set steps=steps+1,y=y+1,curDir=4
			continue
		}
		if curDir=2,ltr="-" {
			set steps=steps+1,x=x+1
			continue
		}
		if curDir=2,ltr="J" {
			set steps=steps+1,y=y-1,curDir=3
			continue
		}
		if curDir=2,ltr="7" {
			set steps=steps+1,y=y+1,curDir=4
			continue
		}
		if curDir=3,ltr="|" {
			set steps=steps+1,y=y-1
			continue
		}
		if curDir=3,ltr="7" {
			set steps=steps+1,x=x-1,curDir=1
			continue
		}
		if curDir=3,ltr="F" {
			set steps=steps+1,x=x+1,curDir=2
			continue
		}
		if curDir=4,ltr="|" {
			set steps=steps+1,y=y+1
			continue
		}
		if curDir=4,ltr="L" {
			set steps=steps+1,x=x+1,curDir=2
			continue
		}
		if curDir=4,ltr="J" {
			set steps=steps+1,x=x-1,curDir=1
			continue
		}
		quit
	}
	quit steps
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",fromX="",fromY=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:record'["S"
		set fromY=line,fromX=$find(record,"S")-1
		quit
	}
	if verbose write !,fromX,",",fromY
	do ..GetPipePathAndLength(fromX,fromY,.recordsArr,.visited)
	if verbose write !!,"Before cleaning:" do ..GridDisplay(.recordsArr)
	set y="",total=0
	for  {
		set y=$order(recordsArr(y)) quit:y=""
		set x=""
		for x=1:1:$length(recordsArr(y)) {
			continue:$data(visited(x,y))
			set $extract(recordsArr(y),x)="."
		}
	}
	if verbose write !!,"After cleaning:" do ..GridDisplay(.recordsArr)
	merge grid=recordsArr
	for  {
		set y=$order(recordsArr(y)) quit:y=""
		set x=""
		for x=1:1:$length(recordsArr(y)) {
			continue:$data(visited(x,y))
			set isInside=..IsInside(x,recordsArr(y))
			if 'isInside {
				set $extract(grid(y),x)="O"
				continue
			}
			//if verbose write:isInside !,x,",",y
			set total=total+1
			set $extract(grid(y),x)="I"
		}
	}
	if verbose write !!,"After analyzing:" do ..GridDisplay(.grid)
	set answer=total
	quit answer
}

ClassMethod GridDisplay(ByRef grid)
{
	//grid(y)=data
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		write !,grid(y)
	}
}

ClassMethod IsInside(x As %Integer, data As %String) As %Boolean
{
	set isOutside=1
	for tx=x+1:1:$length(data) {
		if $extract(data,tx)'="." set isOutside=0
	}
	quit:isOutside 0
	set count=0
	for tx=x-1:-1:1 {
		set ltr=$extract(data,tx)
		if "|JLS"[ltr set count=count+1
	}
	quit count#2
}

}

