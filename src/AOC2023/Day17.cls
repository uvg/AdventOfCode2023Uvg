Class AOC2023.Day17 Extends AOC2023.Base
{

Parameter InputFile = "d17.txt";

// d ##class(AOC2023.Day17).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
	}
	set answer=..FindShortestPathPriorityQueue(.recordsArr,1,1,$length(recordsArr(1)),$order(recordsArr(""),-1),0,.visited,.path,,,3,0)
	if verbose zwrite path //,visited
	quit answer
}

ClassMethod FindShortestPathPriorityQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps = 0, Output visited, ByRef path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces, maxConsecutive As %Integer, minConsecutive As %Integer)
{
	//$$FindShortestPathPriorityQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
	//grid(y)=data
	//There should be no holes in the grid so if y=5..10 then there should be grid(5),grid(6),grid(7),,,grid(10)
	set minSteps=999999
	if maxsteps,steps>maxsteps quit 999999
	quit:$data(noVisitPlaces(fromX,fromY)) 999999
	if fromX=toX,fromY=toY quit steps
	do ..AddQueue(1,steps+$extract($get(grid(1)),2),2,1,$listbuild($listbuild(1,2,1)),.Queue)
	do ..AddQueue(3,steps+$extract($get(grid(2)),1),1,2,$listbuild($listbuild(3,1,2)),.Queue)
	for  {
		set steps=$order(Queue("")) quit:'$length(steps)
		set key=$order(Queue(steps,"")),data=Queue(steps,key)
		//kill visited merge visited=Queue(steps,value,"v")
		kill Queue(steps,key)
		set dir=$list(data,1),fromX=$list(data,2),fromY=$list(data,3),path=$list(data,4)
		if maxsteps,steps>maxsteps continue
		continue:$data(noVisitPlaces(fromX,fromY))
		set type=$extract($get(grid(fromY)),fromX)
		continue:'$length(type)
		set countDir=0
		if $length(path) for p=$listlength(path):-1:$listlength(path)-maxConsecutive if p>0 quit:$list($list(path,p),1)'=dir  set countDir=countDir+1
		continue:countDir>maxConsecutive
		if fromX=toX,fromY=toY,countDir>=minConsecutive {
			set:steps<minSteps minSteps=steps
			quit
		}
		if $listlength(path)>1 {
			continue:$data(visited(dir,fromX,fromY,$list(path,*-countDir+1,*)))
			set visited(dir,fromX,fromY,$list(path,*-countDir+1,*))=steps
		}
		//w !! zw steps,path,dir,countDir // h 1
		/*if $listlength(path)>=4 {
			set last3Steps=$list(path,*-3,*)
			set dir1=$list($list(last3Steps,1),1)
			if dir1=$list($list(last3Steps,2),1),dir1=$list($list(last3Steps,3),1),dir1=$list($list(last3Steps,4),1) continue
		}*/
		if minConsecutive,countDir<minConsecutive {
			set dx=$case(dir,1:1,2:-1,:0)
			set dy=$case(dir,3:1,4:-1,:0)
			set newStep=$extract($get(grid(fromY+dy)),fromX+dx) if newStep do ..AddQueue(dir,steps+newStep,fromX+dx,fromY+dy,path_$listbuild($listbuild(dir,fromX+dx,fromY+dy)),.Queue)
			continue
		}
		if dir'=2 set newStep=$extract($get(grid(fromY)),fromX+1) if newStep do ..AddQueue(1,steps+newStep,fromX+1,fromY,path_$listbuild($listbuild(1,fromX+1,fromY)),.Queue)
		if dir'=1 set newStep=$extract($get(grid(fromY)),fromX-1) if newStep do ..AddQueue(2,steps+newStep,fromX-1,fromY,path_$listbuild($listbuild(2,fromX-1,fromY)),.Queue)
		if dir'=4 set newStep=$extract($get(grid(fromY+1)),fromX) if newStep do ..AddQueue(3,steps+newStep,fromX,fromY+1,path_$listbuild($listbuild(3,fromX,fromY+1)),.Queue)
		if dir'=3 set newStep=$extract($get(grid(fromY-1)),fromX) if newStep do ..AddQueue(4,steps+newStep,fromX,fromY-1,path_$listbuild($listbuild(4,fromX,fromY-1)),.Queue)
		//i dir=3,fromX=9,fromY=3 w !!! zw steps,Queue
	}
	quit minSteps
}

ClassMethod AddQueue(dir, steps, fromX, fromY, path, ByRef Queue)
{
	set key=$order(Queue(steps,""),-1)+1
	set Queue(steps,key)=$listbuild(dir,fromX,fromY,path)
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
	}
	set answer=..FindShortestPathPriorityQueue(.recordsArr,1,1,$length(recordsArr(1)),$order(recordsArr(""),-1),0,.visited,.path,,,10,4)
	i verbose zwrite path //,visited
	quit answer
}

}

