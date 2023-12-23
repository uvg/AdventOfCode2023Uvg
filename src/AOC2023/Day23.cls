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
	if $zstorage<(1024*1024) set $zstorage=1024*1024
	set answer=..FindLongestPathQueue(.recordsArr,fx,fy,tx,ty,,,,,,.path)
	if verbose zwrite path
	quit answer
}

ClassMethod FindLongestPathQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, Output visited, path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces, maxPath As %String, part2 As %Boolean = 0) As %Integer
{
	//$$FindLongestPathQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
	//grid(y)=data
	//I $e(data,x)="#" ==> can't visit there
	//There should be no holes in the grid so if y=5..10 then there should be grid(5),grid(6),grid(7),,,grid(10)
	set minSteps=999999
	if maxsteps,steps>maxsteps quit 999999
	quit:$data(noVisitPlaces(fromX,fromY)) 999999
	if fromX=toX,fromY=toY quit steps
	kill ^||Queue
	set ^||Queue(1)=$listbuild(steps,fromX,fromY,path)
	for  {
		set key=$order(^||Queue("")) quit:key=""
		set value=^||Queue(key) kill ^||Queue(key)
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
		if '$listfind(path,$listbuild(fromX+1,fromY)) set ^||Queue($increment(^||Queue))=$listbuild(steps+1,fromX+1,fromY,path_$listbuild($listbuild(fromX+1,fromY)))
		if part2||(type'=">"),'$listfind(path,$listbuild(fromX-1,fromY)) set ^||Queue($increment(^||Queue))=$listbuild(steps+1,fromX-1,fromY,path_$listbuild($listbuild(fromX-1,fromY)))
		if '$listfind(path,$listbuild(fromX,fromY+1)) set ^||Queue($increment(^||Queue))=$listbuild(steps+1,fromX,fromY+1,path_$listbuild($listbuild(fromX,fromY+1)))
		if part2||(type'="v"),'$listfind(path,$listbuild(fromX,fromY-1)) set ^||Queue($increment(^||Queue))=$listbuild(steps+1,fromX,fromY-1,path_$listbuild($listbuild(fromX,fromY-1)))
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
	//set answer=..FindLongestPathQueue(.recordsArr,fx,fy,tx,ty,,,,,,.path,1)
	//if verbose zwrite path
	do ..GetConnections(.recordsArr,.arrConn)
	do ..MinimizeConn(.arrConn,.arrTrails)
	if verbose zwrite arrTrails
	if $zstorage<(1024*1024) set $zstorage=1024*1024
	set answer=..GetMaxTrail(.arrTrails,fx,fy,tx,ty,.path)
	if verbose zwrite path
	quit answer
}

ClassMethod GetMaxTrail(ByRef arrTrails, fx As %Integer, fy As %Integer, tx As %Integer, ty As %Integer, maxPath As %String) As %Integer
{
	set fp=$listbuild(fx,fy),tp=$listbuild(tx,ty)
	set visited=$listbuild(fp),maxTrail=0
	kill ^||Queue
	set ^||Queue($increment(^||Queue))=$listbuild(fp,0,visited)
	for  {
		set key=$order(^||Queue("")) quit:'$length(key)
		set data=^||Queue(key) kill ^||Queue(key)
		set p=$list(data,1),trailLength=$list(data,2),visited=$list(data,3)
		/*if $get(visited(p))>trailLength continue
		set visited(p)=trailLength*/
		if p=tp {
			if trailLength>maxTrail {
				set maxTrail=trailLength,maxPath=visited
				//write !,maxTrail
			}
			continue
		}
		set dist=""
		for  {
			set dist=$order(arrTrails(p,dist)) quit:dist=""
			set np=""
			for  {
				set np=$order(arrTrails(p,dist,np)) quit:np=""
				if '$listfind(visited,np) set ^||Queue($increment(^||Queue))=$listbuild(np,dist+trailLength,visited_$listbuild(np))
			}
		}
	}
	quit maxTrail
}

ClassMethod GetConnections(ByRef grid, Output arrConn)
{
	set d=$listbuild($listbuild(1,0),$listbuild(-1,0),$listbuild(0,1),$listbuild(0,-1))
	for y=1:1:$order(grid(""),-1) {
		for x=1:1:$length(grid(1)) {
			set ltr=$extract(grid(y),x)
			continue:"#"[ltr
			set p=$listbuild(x,y)
			for i=1:1:$listlength(d) {
				set data=$list(d,i),dx=$list(data,1),dy=$list(data,2)
				set nx=x+dx,ny=y+dy
				set ltr=$extract($get(grid(ny)),nx)
				continue:"#"[ltr
				set arrConn(p,$increment(arrConn(p)))=$listbuild(nx,ny)
			}
		}
	}
}

ClassMethod MinimizeConn(ByRef arrF, Output arrT)
{
	set p=""
	for  {
		set p=$order(arrF(p)) quit:p=""
		set tot=arrF(p)
		continue:tot=2
		if $increment(arrT) set arrT(p)=tot
		for i=1:1:tot {
			set np=arrF(p,i)
			set trailData=..GetTrailEndAndLength(.arrF,p,np)
			set arrT(p,$list(trailData,1),$list(trailData,2))=""
		}
	}
}

ClassMethod GetTrailEndAndLength(ByRef arrConn, fp As %String, tp As %String) As %String
{
	set len=1
	for  {
		quit:arrConn(tp)'=2
		set len=len+1
		set np=arrConn(tp,1)
		if np=fp set np=arrConn(tp,2)
		set fp=tp,tp=np
	}
	quit $listbuild(len,tp)
}

}

