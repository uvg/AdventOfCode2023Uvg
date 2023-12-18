Class AOC2023.Day18 Extends AOC2023.Base
{

Parameter InputFile = "d18.txt";

// d ##class(AOC2023.Day18).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",fromX=1,fromY=1
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set dir=$piece(record," ",1),len=$piece(record," ",2) //,color=$piece($piece(record,"#",2),")",1)
		do ..SetGrid(.grid,.fromX,.fromY,dir,len)
	}
	do ..MakeGridView(.grid,.gridView)
	do ..FillGridView(.gridView,.gridFill)
	if verbose {
		write !!!,"No fill:" do ..GridDisplay(.gridView)
		write !!!,"With fill:" do ..GridDisplay(.gridFill)
	}
	set answer=..CountFilled(.gridFill)
	quit answer
}

ClassMethod SetGrid(ByRef grid, ByRef fromX As %Integer, ByRef fromY As %Integer, dir As %String, len As %Integer)
{
	set x=fromX,y=fromY
	set grid(y,x)=""
	if dir="R" {
		for x=fromX+1:1:fromX+len {
			set grid(y,x)=""
		}
	}
	if dir="L" {
		for x=fromX-1:-1:fromX-len {
			set grid(y,x)=""
		}
	}
	if dir="D" {
		for y=fromY+1:1:fromY+len {
			set grid(y,x)=""
		}
	}
	if dir="U" {
		for y=fromY-1:-1:fromY-len {
			set grid(y,x)=""
		}
	}
	set fromX=x,fromY=y
}

ClassMethod MakeGridView(ByRef grid, Output newGrid)
{
	set fromY=$order(grid("")),toY=$order(grid(""),-1),minX=9999999,maxX=-minX
	for y=fromY:1:toY {
		continue:'$data(grid(y))
		set fromX=$order(grid(y,"")),toX=$order(grid(y,""),-1)
		set:minX>fromX minX=fromX
		set:maxX<toX maxX=toX
	}
	set $piece(filler,".",maxX-minX+2)="",cntY=1
	for y=fromY:1:toY {
		if '$data(grid(y)) {
			set newGrid(cntY)=filler
			set cntY=cntY+1
			continue
		}
		set cntX=1
		for x=minX:1:maxX {
			set ltr="."
			set:$data(grid(y,x)) ltr="#"
			set $extract(newGrid(cntY),cntX)=ltr
			set cntX=cntX+1
		}
		set cntY=cntY+1
	}
}

ClassMethod FillGridView(ByRef gridView, Output gridFill)
{
	do ..FoundStartPoint(.gridView,.startX,.startY)
	//zwrite startX,startY
	merge gridFill=gridView
	set Queue($increment(Queue))=$listbuild(startX,startY)
	for  {
		set key=$order(Queue("")) quit:'$length(key)
		set data=Queue(key) kill Queue(key)
		set x=$list(data,1),y=$list(data,2)
		set ltr=$extract($get(gridFill(y)),x)
		continue:ltr'="."
		set $extract(gridFill(y),x)="#"
		set Queue($increment(Queue))=$listbuild(x+1,y)
		set Queue($increment(Queue))=$listbuild(x-1,y)
		set Queue($increment(Queue))=$listbuild(x,y+1)
		set Queue($increment(Queue))=$listbuild(x,y-1)
	}
}

ClassMethod FoundStartPoint(ByRef grid, Output startX As %Integer, Output startY As %Integer)
{
	set y=1,len=$length(grid(1)),startX=0,startY=0
	for  {
		set y=$order(grid(y)) quit:'$length(y)
		set fromX=0,toX=0
		for x=1:1:len {
			set ltr=$extract(grid(y),x)
			if ltr="#" {
				set fromX=x
				quit
			}
		}
		continue:'fromX
		for x=len:-1:1 {
			set ltr=$extract(grid(y),x)
			if ltr="#" {
				set toX=x
				quit
			}
		}
		for x=fromX+1:1:toX-1 {
			set ltr=$extract(grid(y),x)
			if ltr="." {
				set startX=x,startY=y
				quit
			}
		}
		quit:startX
	}
}

ClassMethod CountFilled(ByRef grid)
{
	set count=0,y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		set count=count+$length($translate(grid(y),"."))
	}
	quit count
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

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",x=0,y=0,totLen=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set inst=$piece($piece(record,"#",2),")",1)
		set len=$zhex($extract(inst,1,5)),dir=$extract(inst,6)
		//write len,",",dir,!
		set totLen=totLen+len
		set:23[dir len=-len
		set:20[dir x=x+len
		set:13[dir y=y+len
		set arr($increment(arr))=$listbuild(x,y)
	}
	if verbose zwrite arr,totLen
	set answer=totLen\2+1+..ComputePoligonArea(.arr)
	quit answer
}

ClassMethod ComputePoligonArea(ByRef arr)
{
	set area=0
	for i=1:1:arr {
		set point=arr(i)
		set nextPoint=arr($select(i+1>arr:1,1:i+1))
		set x1=$list(point,1),y1=$list(point,2)
		set x2=$list(nextPoint,1),y2=$list(nextPoint,2)
		set area=(x1*y2)-(x2*y1)+area
	}
	quit $zabs(area)\2
}

}

