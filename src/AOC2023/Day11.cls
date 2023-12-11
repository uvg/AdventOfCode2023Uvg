Class AOC2023.Day11 Extends AOC2023.Base
{

Parameter InputFile = "d11.txt";

// d ##class(AOC2023.Day11).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	do ..ExpandRows(.recordsArr,.grid)
	do ..ExpandColumns(.grid,.newGrid)
	if verbose zwrite newGrid
	set line=""
	for {
		set line=$order(newGrid(line)) quit:line=""
		set record=newGrid(line)
		continue:'$length($translate(record,"."))
		for i=1:1:$length(record) {
			if $extract(record,i)="#" set arr($increment(arr))=$listbuild(line,i)
		}
	}
	if verbose zwrite arr
	set galaxy="",totalDist=0
	for  {
		set galaxy=$order(arr(galaxy)) quit:galaxy=""
		set data=arr(galaxy),fromY=$list(data,1),fromX=$list(data,2)
		set nextGalaxy=galaxy
		for  {
			set nextGalaxy=$order(arr(nextGalaxy)) quit:nextGalaxy=""
			set nextData=arr(nextGalaxy),toY=$list(nextData,1),toX=$list(nextData,2)
			set dist=$zabs(fromY-toY)+$zabs(fromX-toX)
			//if verbose write !! zwrite arr(galaxy),arr(nextGalaxy),dist
			set totalDist=totalDist+dist
		}
	}
	set answer=totalDist
	quit answer
}

ClassMethod ExpandRows(ByRef fromGrid, Output toGrid)
{
	set line=""
	for {
		set line=$order(fromGrid(line)) quit:line=""
		set record=fromGrid(line),nextGridLine=$order(toGrid(""),-1)+1
		set toGrid(nextGridLine)=record
		continue:$length($translate(record,"."))
		set toGrid(nextGridLine+1)=record
	}
}

ClassMethod ExpandColumns(ByRef fromGrid, Output toGrid)
{
	set toX=$length(fromGrid(1)),toY=$order(fromGrid(""),-1),newToX=0
	for x=1:1:toX {
		set newToX=newToX+1,found=0
		for y=1:1:toY {
			if $extract(fromGrid(y),x)'="." {
				set found=1
				quit
			}
		}
		for y=1:1:toY {
			set $extract(toGrid(y),newToX)=$extract(fromGrid(y),x)
		}
		if 'found {
			set newToX=newToX+1
			for y=1:1:toY {
				set $extract(toGrid(y),newToX)=$extract(fromGrid(y),x)
			}
		}
	}
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:'$length($translate(record,"."))
		for i=1:1:$length(record) {
			if $extract(record,i)="#" set arr($increment(arr))=$listbuild(line,i)
		}
	}
	do ..GetEmptySpacesArr(.recordsArr,.emptyR,.emptyC)
	if verbose zwrite arr,emptyR,emptyC
	set galaxy="",totalDist=0,expansionRatio=1000000-1 //=10 //=100 //=1000000
	for  {
		set galaxy=$order(arr(galaxy)) quit:galaxy=""
		set data=arr(galaxy),fromY=$list(data,1),fromX=$list(data,2)
		set nextGalaxy=galaxy
		for  {
			set nextGalaxy=$order(arr(nextGalaxy)) quit:nextGalaxy=""
			set nextData=arr(nextGalaxy),toY=$list(nextData,1),toX=$list(nextData,2)
			set dist=$zabs(fromY-toY)+$zabs(fromX-toX),emptySpaces=..GetEmptySpaces(fromX,toX,fromY,toY,.recordsArr,.emptyR,.emptyC)
			set dist=emptySpaces*expansionRatio+dist
			//if verbose write !! zwrite arr(galaxy),arr(nextGalaxy),dist,emptySpaces
			set totalDist=totalDist+dist
		}
	}
	set answer=totalDist
	quit answer
}

ClassMethod GetEmptySpacesArr(ByRef grid, Output emptyR, Output emptyC)
{
	do ..GetEmptyRows(.grid,.emptyR)
	do ..GetEmptyColumns(.grid,.emptyC)
}

ClassMethod GetEmptyRows(ByRef grid, Output arr)
{
	for y=1:1:$order(grid(""),-1) {
		set:'$length($translate(grid(y),".")) arr(y)=""
	}
}

ClassMethod GetEmptyColumns(ByRef grid, Output arr)
{
	set lastLine=$order(grid(""),-1)
	for x=1:1:$length(grid(1)) {
		set found=0
		for y=1:1:lastLine {
			if $extract(grid(y),x)'="." {
				set found=1
				quit
			}
		}
		set:'found arr(x)=""
	}
}

ClassMethod GetEmptySpaces(fromX As %Integer, toX As %Integer, fromY As %Integer, toY As %Integer, ByRef grid, ByRef emptyR, ByRef emptyC)
{
	set countR=0,countC=0,lastY=$order(grid(""),-1)
	if fromY>toY {
		set y=fromY,fromY=toY,toY=y
	}
	if fromX>toX {
		set x=fromX,fromX=toX,toX=x
	}
	for y=fromY:1:toY {
		set:$data(emptyR(y)) countR=countR+1
	}
	for x=fromX:1:toX {
		set:$data(emptyC(x)) countC=countC+1
	}
	quit countR+countC
}

}

