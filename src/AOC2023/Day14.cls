Class AOC2023.Day14 Extends AOC2023.Base
{

Parameter InputFile = "d14.txt";

// d ##class(AOC2023.Day14).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	merge grid=recordsArr
	if verbose write !,"before:",! zwrite grid
	do ..Slide(.grid,1)
	if verbose write !,"after:",! zwrite grid
	set answer="",line="",lastLine=$order(grid(""),-1),total=0
	for {
		set line=$order(grid(line)) quit:line=""
		set data=grid(line)
		set totalO=$length($translate(data,".#"))
		set load=(lastLine-line+1)*totalO
		set total=total+load
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	merge grid=recordsArr
	set gridNum=0
	for i=1:1:1000 {
		do ..Slide(.grid,1)
		do ..Slide(.grid,2)
		do ..Slide(.grid,3)
		do ..Slide(.grid,4)
		//write !,"After ",i," cycle(s):",! zwrite grid
		set gridNum=..GetGridNum(.grid,.gridCycles)
		quit:gridNum
		merge gridCycles(i)=grid
	}
	if verbose write !,"After ",i," cycle(s):",! zwrite grid
	set loopSize=i-gridNum
	set left=1000000000-gridNum
	set offset=left#loopSize
	set lastGridNum=offset+gridNum
	if verbose write !,i,",",gridNum,",",loopSize,",",left,",",offset,",",lastGridNum
	merge grid=gridCycles(lastGridNum)
	if verbose write !,"Last grid:",! zwrite grid
	set answer="",line="",lastLine=$order(grid(""),-1),total=0
	for {
		set line=$order(grid(line)) quit:line=""
		set data=grid(line)
		set totalO=$length($translate(data,".#"))
		set load=(lastLine-line+1)*totalO
		set total=total+load
	}
	set answer=total
	quit answer
}

ClassMethod GetGridNum(ByRef grid1, ByRef gridArr) As %Integer
{
	set lastLine=$order(grid1(""),-1),lastGrid=$order(gridArr(""),-1)
	for gridNum=1:1:lastGrid {
		set found=1
		for y=1:1:lastLine {
			if grid1(y)'=gridArr(gridNum,y) {
				set found=0
				quit
			}
		}
		return:found gridNum
	}
	quit 0
}

ClassMethod Slide(ByRef grid, dir As %Integer)
{
	set y="",len=$length(grid(1))
	set loopDir=$select(dir=3:-1,1:1)
	for  {
		set y=$order(grid(y),loopDir) quit:y=""
		set data=grid(y)
		set from=1,to=len,step=1
		if dir=4 set from=len,to=1,step=-1
		for x=from:step:to {
			set ltr=$extract(data,x)
			continue:ltr'="O"
			do:dir=1 ..SlideCellNorth(.grid,x,y)
			do:dir=2 ..SlideCellWest(.grid,x,y)
			do:dir=3 ..SlideCellSouth(.grid,x,y)
			do:dir=4 ..SlideCellEast(.grid,x,y)
		}
}
}

ClassMethod SlideCellNorth(ByRef grid, x As %Integer, y As %Integer)
{
	set lastLine=$order(grid(""),-1)
	for ty=y:1:lastLine {
		set newGrid(ty)=grid(ty)
	}
	for ty=y-1:-1:1 {
		set data=grid(ty)
		set ltr=$extract(data,x)
		if ltr'="." {
			set newGrid(ty)=grid(ty)
			quit
		}
	set $extract(newGrid(ty+1),x)="."
		set $extract(data,x)="O"
		set newGrid(ty)=data
	}
	for ty=ty-1:-1:1 {
		set newGrid(ty)=grid(ty)
	}
	kill grid
	merge grid=newGrid
}

ClassMethod SlideCellWest(ByRef grid, x As %Integer, y As %Integer)
{
	set data=grid(y)
	for tx=x-1:-1:1 {
		set ltr=$extract(data,tx)
		quit:ltr'="."
		set $extract(data,tx)="O"
		set $extract(data,tx+1)="."
	}
	set grid(y)=data
}

ClassMethod SlideCellSouth(ByRef grid, x As %Integer, y As %Integer)
{
	set lastLine=$order(grid(""),-1)
	for ty=y:-1:1 {
		set newGrid(ty)=grid(ty)
	}
	for ty=y+1:1:lastLine {
		set data=grid(ty)
		set ltr=$extract(data,x)
		if ltr'="." {
			set newGrid(ty)=grid(ty)
			quit
		}
	set $extract(newGrid(ty-1),x)="."
		set $extract(data,x)="O"
		set newGrid(ty)=data
	}
	for ty=ty+1:1:lastLine {
		set newGrid(ty)=grid(ty)
	}
	kill grid
	merge grid=newGrid
}

ClassMethod SlideCellEast(ByRef grid, x As %Integer, y As %Integer)
{
	set data=grid(y),len=$length(data)
	for tx=x+1:1:len {
		set ltr=$extract(data,tx)
		quit:ltr'="."
		set $extract(data,tx)="O"
		set $extract(data,tx-1)="."
	}
	set grid(y)=data
}

}

