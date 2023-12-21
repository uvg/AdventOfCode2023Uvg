Class AOC2023.Day21 Extends AOC2023.Base
{

Parameter InputFile = "d21.txt";

// d ##class(AOC2023.Day21).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",x=0,y=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:record'["S"
		set x=$find(record,"S")-1,y=line
		quit
	}
	merge grid=recordsArr //,emptyGrid=grid
	set $extract(grid(y),x)="."
	set lastY=$order(grid(""),-1),lastX=$length(grid(1))
	do ..GoOnPlots(.grid,x,y,64,.visited)
	if verbose zwrite grid,visited(1)
	set answer=visited(1)
	quit answer
}

ClassMethod GoOnPlots(ByRef grid, fromX As %Integer, fromY As %Integer, remainingSteps As %Integer, Output visited)
{
	do ..AddToQueue(.Queue,remainingSteps+1,fromX,fromY)
	for  {
		set remainingSteps=$order(Queue(""),-1) quit:'remainingSteps
		set key=$order(Queue(remainingSteps,""))
		if '$length(key) {
			kill Queue(remainingSteps)
			continue
		}
		set data=Queue(remainingSteps,key) kill Queue(remainingSteps,key)
		set x=$list(data,1),y=$list(data,2)
		set ltr=$extract($get(grid(y)),x)
		continue:ltr'="."
		continue:$data(visited(remainingSteps,x,y))
		set visited(remainingSteps,x,y)=""
		set visited(remainingSteps)=$get(visited(remainingSteps))+1
		do ..AddToQueue(.Queue,remainingSteps-1,x+1,y)
		do ..AddToQueue(.Queue,remainingSteps-1,x-1,y)
		do ..AddToQueue(.Queue,remainingSteps-1,x,y+1)
		do ..AddToQueue(.Queue,remainingSteps-1,x,y-1)
	}
	quit
}

ClassMethod AddToQueue(ByRef Queue, steps As %Integer, x As %Integer, y As %Integer)
{
	set Queue(steps,$increment(Queue))=$listbuild(x,y)
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",x=0,y=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:record'["S"
		set x=$find(record,"S")-1,y=line
		quit
	}
	merge grid=recordsArr //,emptyGrid=grid
	set $extract(grid(y),x)="."
	set lastY=$order(grid(""),-1),lastX=$length(grid(1))
	if lastY'=lastX write !,"This is not a square!! " quit 0
	do ..GetPlotsDistances(.grid,x,y,.distArr)
	set maxDist=26501365,total=0
	for y=0:1:lastY-1 {
		for x=0:1:lastX-1 {
			continue:'$data(distArr(0,0,x,y))
			for dv=-3:1:3 {
				for dh=-3:1:3 {
					//distArr(dv,dh,x,y)=dist
					set dist=distArr(dv,dh,x,y)
					if dist<=maxDist,(dist#2)=(maxDist#2) set total=total+1
					set corner=0,edge=0
					if dv[3,dh[3 set corner=1
					if 'corner,(dv[3)||(dh[3) set edge=1
					if edge set total=total+..ComputeDist(dist,0,maxDist,.arrCnt,lastX)
					if corner set total=total+..ComputeDist(dist,1,maxDist,.arrCnt,lastX)
				}
			}
		}
	}
	if verbose zwrite grid //,distArr
	set answer=total
	quit answer
}

ClassMethod ComputeDist(dist As %Integer, type As %Boolean, maxDist As %Integer, ByRef arrCnt, size As %Integer)
{
	if $data(arrCnt(type,dist)) quit arrCnt(type,dist)
	set diffDist=maxDist-dist
	set last=$select(diffDist'<0:diffDist\size,1:+$fnumber(diffDist/size,"",0))
	set cnt=0
	//w !,dist," ",type+1," ",last
	for x=1:1:last {
		set pos=size*x+dist
		continue:pos>maxDist
		continue:(pos#2)'=(maxDist#2)
		set cnt=cnt+1
		set:type cnt=cnt+x
	}
	set arrCnt(type,dist)=cnt
	quit cnt
}

ClassMethod GetPlotsDistances(ByRef grid, fromX As %Integer, fromY As %Integer, Output distArr)
{
	set lastY=$order(grid(""),-1),lastX=$length(grid(1))
	do ..AddToQueue2(.Queue,0,0,0,fromX,fromY)
	for  {
		set key=$order(Queue("")) quit:'$length(key)
		set data=Queue(key) kill Queue(key)
		set x=$list(data,1),y=$list(data,2),dv=$list(data,3),dh=$list(data,4),dist=$list(data,5)
		set gridY=y-1#lastY+1
		set gridX=x-1#lastX+1
		set ltr=$extract(grid(gridY),gridX)
		continue:ltr'="."
		set:x<1 x=gridX,dh=dh-1
		set:y<1 y=gridY,dv=dv-1
		set:x>lastX x=gridX,dh=dh+1
		set:y>lastY y=gridY,dv=dv+1
		continue:($zabs(dv)>3)||($zabs(dh)>3)
		continue:$data(distArr(dv,dh,x-1,y-1))
		set distArr(dv,dh,x-1,y-1)=dist
		do ..AddToQueue2(.Queue,dv,dh,dist+1,x+1,y)
		do ..AddToQueue2(.Queue,dv,dh,dist+1,x-1,y)
		do ..AddToQueue2(.Queue,dv,dh,dist+1,x,y+1)
		do ..AddToQueue2(.Queue,dv,dh,dist+1,x,y-1)
	}
	quit
}

ClassMethod AddToQueue2(ByRef Queue, diffVertical As %Integer, diffHorizontal As %Integer, distance As %Integer, x As %Integer, y As %Integer)
{
	set Queue($increment(Queue))=$listbuild(x,y,diffVertical,diffHorizontal,distance)
}

}

