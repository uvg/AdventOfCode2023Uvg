Class AOC2023.Day16 Extends AOC2023.Base
{

Parameter InputFile = "d16.txt";

// d ##class(AOC2023.Day16).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	if verbose write !,"Layout:" do GridDisplay(.recordsArr)
	set answer=""
	do ..MoveBeam(1,1,1,.recordsArr,.visited)
	if verbose write !!,"Eneregized:" do ..ChangeGrid(.recordsArr,.visited),..GridDisplay(.recordsArr)
	set answer=..CountEnergized(.visited)
	quit answer
}

ClassMethod MoveBeam(fromX As %Integer, fromY As %Integer, dir As %Integer, ByRef grid, Output visited)
{
	set Queue($increment(Queue))=$listbuild(fromX,fromY,dir)
	for  {
		set curQ=$order(Queue("")) quit:'$length(curQ)
		set data=Queue(curQ)
		kill Queue(curQ)
		set fromX=$list(data,1),fromY=$list(data,2),dir=$list(data,3)
		continue:fromX<1  continue:fromY<1  continue:fromX>$length(grid(1))  continue:fromY>$order(grid(""),-1)
		continue:$data(visited(fromY,fromX,dir))
		//
		set visited(fromY,fromX,dir)=""
		set ltr=$extract(grid(fromY),fromX)
		if (ltr=".")||((ltr="-")&&(12[dir))||((ltr="|")&&(34[dir)) {
			set dx=$case(dir,1:1,2:-1,:0)
			set dy=$case(dir,3:1,4:-1,:0)
			set Queue($increment(Queue))=$listbuild(fromX+dx,fromY+dy,dir)
			continue
		}
		if ltr="-" {
			set Queue($increment(Queue))=$listbuild(fromX+1,fromY,1)
			set Queue($increment(Queue))=$listbuild(fromX-1,fromY,2)
			continue
		}
		if ltr="|" {
			set Queue($increment(Queue))=$listbuild(fromX,fromY+1,3)
			set Queue($increment(Queue))=$listbuild(fromX,fromY-1,4)
			continue
		}
		if ltr="/" {
			set dx=$case(dir,3:-1,4:1,:0)
			set dy=$case(dir,1:-1,2:1,:0)
			set dir=$case(dir,1:4,2:3,3:2,4:1)
		}
		if ltr="\" {
			set dx=$case(dir,3:1,4:-1,:0)
			set dy=$case(dir,1:1,2:-1,:0)
			set dir=$case(dir,1:3,2:4,3:1,4:2)
		}
		set Queue($increment(Queue))=$listbuild(fromX+dx,fromY+dy,dir)
	}
}

ClassMethod CountEnergized(ByRef visited) As %Integer
{
	set count=0,line=""
	for  {
		set line=$order(visited(line)) quit:'$length(line)
		set x=""
		for  {
			set x=$order(visited(line,x)) quit:'$length(x)
			set count=count+1
		}
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

ClassMethod ChangeGrid(ByRef grid, ByRef visited)
{
	set y="",len=$length(grid(1)),$piece(filler,".",len+1)=""
	for  {
		set y=$order(grid(y)) quit:y=""
		set grid(y)=filler
	}
	for  {
		set y=$order(visited(y)) quit:y=""
		set x=""
		for  {
			set x=$order(visited(y,x)) quit:x=""
			set $extract(grid(y),x)="#"
		}
	}
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	if verbose write !,"Layout:" do ..GridDisplay(.recordsArr)
	set answer="",maxEnergized=0,lastY=$order(recordsArr(""),-1),len=$length(recordsArr(1)),(maxX,maxY,maxDir)=0
	for x=1:1:len {
		kill visited do ..MoveBeam(x,1,3,.recordsArr,.visited)
		set energized=..CountEnergized(.visited)
		if energized>maxEnergized {
			set maxEnergized=energized
			set maxX=x,maxY=1,maxDir=3
		}
		kill visited do ..MoveBeam(x,lastY,4,.recordsArr,.visited)
		set energized=..CountEnergized(.visited)
		if energized>maxEnergized {
			set maxEnergized=energized
			set maxX=x,maxY=lastY,maxDir=4
		}
	}
	for y=1:1:lastY {
		kill visited do ..MoveBeam(1,y,1,.recordsArr,.visited)
		set energized=..CountEnergized(.visited)
		if energized>maxEnergized {
			set maxEnergized=energized
			set maxX=1,maxY=y,maxDir=1
		}
		kill visited do ..MoveBeam(len,y,2,.recordsArr,.visited)
		set energized=..CountEnergized(.visited)
		if energized>maxEnergized {
			set maxEnergized=energized
			set maxX=len,maxY=y,maxDir=2
		}
	}
	if verbose {
		write !!!!,"Max eneregized:",! zwrite maxX,maxY,maxDir
		kill visited do ..MoveBeam(maxX,maxY,maxDir,.recordsArr,.visited),..ChangeGrid(.recordsArr,.visited),..GridDisplay(.recordsArr)
	}
	set answer=maxEnergized
	quit answer
}

}

