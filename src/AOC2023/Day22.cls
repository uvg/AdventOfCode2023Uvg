Class AOC2023.Day22 Extends AOC2023.Base
{

Parameter InputFile = "d22.txt";

// d ##class(AOC2023.Day22).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set x1=+$piece(record,",",1),y1=+$piece(record,",",2),z1=+$piece(record,",",3)
		set x2=+$piece(record,"~",2),y2=+$piece(record,",",4),z2=+$piece(record,",",5)
		if z1>z2 {
			set t=x1,x1=x2,x2=t
			set t=y1,y1=y2,y2=t
			set t=z1,z1=z2,z2=t
		}
		set arr($increment(arr))=$listbuild($listbuild(x1,y1,z1),$listbuild(x2,y2,z2))
	}
	if verbose write !,"Before:",! zwrite arr
	do ..ArrangeByZ(.arr)
	if verbose write !,"After aranging by z:",! zwrite arr
	for  {
		quit:'..GoDownOnZ(.arr)
	}
	if verbose write !,"After going down:",! zwrite arr
	set answer=..CountSafeBricks(.arr)
	quit answer
}

ClassMethod ArrangeByZ(ByRef arr)
{
	set brick=""
	for  {
		set brick=$order(arr(brick)) quit:brick=""
		set z1=$list($list(arr(brick),1),3)
		set zArr(z1,brick)=arr(brick)
	}
	kill arr
	set z1=""
	for  {
		set z1=$order(zArr(z1),-1) quit:z1=""
		set brick=""
		for  {
			set brick=$order(zArr(z1,brick)) quit:brick=""
			set arr($increment(arr))=zArr(z1,brick)
		}
	}
}

ClassMethod GoDownOnZ(ByRef arr) As %Boolean
{
	set brick="",ans=0
	for  {
		set brick=$order(arr(brick)) quit:brick=""
		continue:'..CanGoDownOnZ(.arr,brick)
		set ans=1
		set data=arr(brick)
		set from=$list(data,1),to=$list(data,2)
		set $list(from,3)=$list(from,3)-1
		set $list(to,3)=$list(to,3)-1
		set data=$listbuild(from,to)
		set arr(brick)=data
	}
	quit ans
}

ClassMethod CanGoDownOnZ(ByRef arr, brick As %Integer) As %Boolean
{
	set data=arr(brick),from=$list(data,1),to=$list(data,2)
	set x1=$list(from,1),y1=$list(from,2),z1=$list(from,3)
	set x2=$list(to,1),y2=$list(to,2),z2=$list(to,3)
	if (z1=1)||(z2=1) quit 0
	set z1=z1-1,z2=z2-1
	set ans=1
	set nextBrick=brick
	for  {
		set nextBrick=$order(arr(nextBrick)) quit:nextBrick=""
		set data=arr(nextBrick),from=$list(data,1),to=$list(data,2)
		set nx1=$list(from,1),ny1=$list(from,2),nz1=$list(from,3)
		set nx2=$list(to,1),ny2=$list(to,2),nz2=$list(to,3)
		continue:'..IsAxisColide(x1,x2,nx1,nx2)
		continue:'..IsAxisColide(y1,y2,ny1,ny2)
		continue:'..IsAxisColide(z1,z2,nz1,nz2)
		set ans=0
		quit
	}
	quit ans
}

ClassMethod IsAxisColide(f1 As %Integer, t1 As %Integer, f2 As %Integer, t2 As %Integer) As %Boolean
{
	if f1>t1 set t=f1,f1=t1,t1=t
	if f2>t2 set t=f2,f2=t2,t2=t
	if f1<=t2,t1>=f2 quit 1
	quit 0
}

ClassMethod CountSafeBricks(ByRef arr) As %Integer
{
	set brick="",cnt=0
	for  {
		set brick=$order(arr(brick)) quit:brick=""
		kill tempArr merge tempArr=arr
		kill tempArr(brick)
		set:'..GoDownOnZ(.tempArr) cnt=cnt+1
	}
	quit cnt
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set x1=+$piece(record,",",1),y1=+$piece(record,",",2),z1=+$piece(record,",",3)
		set x2=+$piece(record,"~",2),y2=+$piece(record,",",4),z2=+$piece(record,",",5)
		if z1>z2 {
			set t=x1,x1=x2,x2=t
			set t=y1,y1=y2,y2=t
			set t=z1,z1=z2,z2=t
		}
		set arr($increment(arr))=$listbuild($listbuild(x1,y1,z1),$listbuild(x2,y2,z2))
	}
	if verbose write !,"Before:",! zwrite arr
	do ..ArrangeByZ(.arr)
	if verbose write !,"After aranging by z:",! zwrite arr
	for  {
		quit:'..GoDownOnZ(.arr)
	}
	if verbose write !,"After going down:",! zwrite arr
	set answer=..CountFallingBricks(.arr)
	quit answer
}

ClassMethod CountFallingBricks(ByRef arr) As %Integer
{
	set brick="",cnt=0
	for  {
		set brick=$order(arr(brick)) quit:brick=""
		kill tempArr merge tempArr=arr
		kill tempArr(brick)
		kill befArr merge befArr=tempArr
		continue:'..GoDownOnZ(.tempArr)
		//w !,brick
		for  {
			quit:'..GoDownOnZ(.tempArr)
		}
		set cnt=cnt+..CountChangedZ(.befArr,.tempArr)
	}
	quit cnt
}

ClassMethod CountChangedZ(ByRef arr1, ByRef arr2) As %Integer
{
	set brick="",cnt=0
	for  {
		set brick=$order(arr1(brick)) quit:brick=""
		set data1=arr1(brick),data2=arr2(brick)
		if data1'=data2 set cnt=cnt+1
	}
	quit cnt
}

}

