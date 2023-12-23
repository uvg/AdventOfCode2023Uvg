Class AOC2023.Day23 Extends AOC2023.Base
{

Parameter InputFile = "d23.txt";

// d ##class(AOC2023.Day23).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	set fy=1,ty=$order(recordsArr(""),-1),(fx,tx)=0
	for x=1:1:$length(recordsArr(fy)) {
		if $extract(recordsArr(fy),x)="." {
			set fx=x
			quit
		}
	}
	for x=1:1:$length(recordsArr(ty)) {
		if $extract(recordsArr(ty),x)="." {
			set tx=x
			quit
		}
	}
	set answer=..FindLongestPathQueue(.recordsArr,fx,fy,tx,ty,,,,,,.path)
	if verbose zwrite path
	quit answer
}

ClassMethod FindLongestPathQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, Output visited, path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces, maxPath As %String, part2 As %Boolean = 0) As %Integer
{
	//$$FindShortestPathQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
	//grid(y)=data
	//I $e(data,x)="#" ==> can't visit there
	//There should be no holes in the grid so if y=5..10 then there should be grid(5),grid(6),grid(7),,,grid(10)
	set minSteps=999999
	if maxsteps,steps>maxsteps quit 999999
	quit:$data(noVisitPlaces(fromX,fromY)) 999999
	if fromX=toX,fromY=toY quit steps
	set Queue(1)=$listbuild(steps,fromX,fromY,path),last=1
	for  {
		set key=$order(Queue("")) quit:key=""
		set value=Queue(key) kill Queue(key)
		quit:value=""
		set steps=$list(value,1),fromX=$list(value,2),fromY=$list(value,3),path=$list(value,4)
		//if maxsteps,steps>maxsteps continue
		continue:$data(noVisitPlaces(fromX,fromY))
		set type=$extract($get(grid(fromY)),fromX)
		if type="#"||'$length(type) continue
		if $data(visited(fromX,fromY)),visited(fromX,fromY)>steps {
			continue
		}
		set visited(fromX,fromY)=steps
		set visited(fromX,fromY,"path")=path
		if fromX=toX,fromY=toY {
			set:steps>maxsteps maxsteps=steps,maxPath=path
			continue
		}
		if '$listfind(path,$listbuild(fromX+1,fromY)) set Queue(last+1)=$listbuild(steps+1,fromX+1,fromY,path_$listbuild($listbuild(fromX+1,fromY)))
		if part2||(type'=">"),'$listfind(path,$listbuild(fromX-1,fromY)) set Queue(last+2)=$listbuild(steps+1,fromX-1,fromY,path_$listbuild($listbuild(fromX-1,fromY)))
		if '$listfind(path,$listbuild(fromX,fromY+1)) set Queue(last+3)=$listbuild(steps+1,fromX,fromY+1,path_$listbuild($listbuild(fromX,fromY+1)))
		if part2||(type'="v"),'$listfind(path,$listbuild(fromX,fromY-1)) set Queue(last+4)=$listbuild(steps+1,fromX,fromY-1,path_$listbuild($listbuild(fromX,fromY-1)))
		set last=last+4
	}
	quit maxsteps
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	set fy=1,ty=$order(recordsArr(""),-1),(fx,tx)=0
	for x=1:1:$length(recordsArr(fy)) {
		if $extract(recordsArr(fy),x)="." {
			set fx=x
			quit
		}
	}
	for x=1:1:$length(recordsArr(ty)) {
		if $extract(recordsArr(ty),x)="." {
			set tx=x
			quit
		}
	}
	set answer=..FindLongestPathQueue(.recordsArr,fx,fy,tx,ty,,,,,,.path,1)
	if verbose zwrite path
	quit answer
}

}

