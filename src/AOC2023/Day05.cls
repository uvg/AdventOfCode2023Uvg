Class AOC2023.Day05 Extends AOC2023.Base
{

Parameter InputFile = "d05.txt";

// d ##class(AOC2023.Day05).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..InitializeData(.recordsArr,.arr)
	if verbose zwrite arr
	merge seeds=arr("seeds","part1")
	merge s2s=arr("s2s"),s2f=arr("s2f"),f2w=arr("f2w"),w2l=arr("w2l"),l2t=arr("l2t"),t2h=arr("t2h"),h2l=arr("h2l")
	set minLocation=999999999999999999
	set seed=""
	for  {
		set seed=$order(seeds(seed)) quit:seed=""
		set value=seed
		set value=..findInArr(value,.s2s)
		set value=..findInArr(value,.s2f)
		set value=..findInArr(value,.f2w)
		set value=..findInArr(value,.w2l)
		set value=..findInArr(value,.l2t)
		set value=..findInArr(value,.t2h)
		set value=..findInArr(value,.h2l)
		if value<minLocation set minLocation=value
	}
	set answer=minLocation
	quit answer
}

ClassMethod findInArr(value As %Integer, ByRef arr) As %Integer
{
	set key=""
	for  {
		set key=$order(arr(key)) quit:key=""
		set data=arr(key)
		set source=$list(data,2)
		continue:value<source
		set range=$list(data,3)
		continue:value>=(source+range)
		set dest=$list(data,1)+value-source
		return dest
	}
	quit value
}

ClassMethod InitializeData(ByRef recordsArr, ByRef arr)
{
	set line="",state=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) {
			set state=state+1
			continue
		}
		continue:record["map:"
		if state=0 {
			set seeds=$piece(record,"seeds: ",2)
			for i=1:2:$length(seeds," ") {
				set seedF=+$piece(seeds," ",i),offset=$piece(seeds," ",i+1),seedT=seedF+offset-1
				set arrS(seedF,seedT)=seedF,seeds(seedF)="",seeds(offset)=""
			}
		}
		set dest=+$piece(record," ",1),source=+$piece(record," ",2),range=+$piece(record," ",3)
		if state=1 set s2s($increment(s2s))=$listbuild(dest,source,range)
		if state=2 set s2f($increment(s2f))=$listbuild(dest,source,range)
		if state=3 set f2w($increment(f2w))=$listbuild(dest,source,range)
		if state=4 set w2l($increment(w2l))=$listbuild(dest,source,range)
		if state=5 set l2t($increment(l2t))=$listbuild(dest,source,range)
		if state=6 set t2h($increment(t2h))=$listbuild(dest,source,range)
		if state=7 set h2l($increment(h2l))=$listbuild(dest,source,range)
	}
	merge arr("seeds","part1")=seeds,arr("seeds","part2")=arrS
	merge arr("s2s")=s2s,arr("s2f")=s2f,arr("f2w")=f2w,arr("w2l")=w2l,arr("l2t")=l2t,arr("t2h")=t2h,arr("h2l")=h2l
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	do ..InitializeData(.recordsArr,.arr)
	if verbose zwrite arr
	merge arrS=arr("seeds","part2")
	merge s2s=arr("s2s"),s2f=arr("s2f"),f2w=arr("f2w"),w2l=arr("w2l"),l2t=arr("l2t"),t2h=arr("t2h"),h2l=arr("h2l")
	do ..findInArr2(.arrS,.s2s,.arrD),..changeArr(.arrD,.arrS) if verbose write !,"After s2s",! zwrite arrS
	do ..findInArr2(.arrS,.s2f,.arrD),..changeArr(.arrD,.arrS) if verbose write !,"After s2f",! zwrite arrS
	do ..findInArr2(.arrS,.f2w,.arrD),..changeArr(.arrD,.arrS) if verbose write !,"After f2w",! zwrite arrS
	do ..findInArr2(.arrS,.w2l,.arrD),..changeArr(.arrD,.arrS) if verbose write !,"After w2l",! zwrite arrS
	do ..findInArr2(.arrS,.l2t,.arrD),..changeArr(.arrD,.arrS) if verbose write !,"After l2t",! zwrite arrS
	do ..findInArr2(.arrS,.t2h,.arrD),..changeArr(.arrD,.arrS) if verbose write !,"After t2h",! zwrite arrS
	do ..findInArr2(.arrS,.h2l,.arrD),..changeArr(.arrD,.arrS) if verbose write !,"After h2l",! zwrite arrS
	set minLocation=$order(arrS(""))
	set answer=minLocation
	quit answer
}

ClassMethod changeArr(ByRef arrFrom, ByRef arrTo)
{
	kill arrTo
	set from=""
	for  {
		set from=$order(arrFrom(from)) quit:from=""
		set to=""
		for  {
			set to=$order(arrFrom(from,to)) quit:to=""
			set fromDest=arrFrom(from,to)
			set arrTo(fromDest,to-from+fromDest)=fromDest
		}
	}
}

ClassMethod findInArr2(ByRef arrS, ByRef arrT, ByRef arrD)
{
	kill arrD merge arrD=arrS
	set from="",change=0
	for  {
		set from=$order(arrS(from)) quit:from=""
		set to=""
		for  {
			set to=$order(arrS(from,to)) quit:to=""
			set fromDest=arrS(from,to)
			set key=""
			for  {
				set key=$order(arrT(key)) quit:key=""
				set data=arrT(key)
				set dest=$list(data,1),fromSource=$list(data,2),range=$list(data,3)
				set toSource=fromSource+range-1
				continue:toSource<from
				continue:fromSource>to
				//break "l+"
				kill arrD(from,to)
				if fromSource<=from {
					set newTo=$select(to<toSource:to,1:toSource)
					set arrD(from,newTo)=from-fromSource+dest
					if newTo=to,from-fromSource+dest=fromDest continue  //No change should be made
					if newTo<to set arrD(newTo+1,to)=fromDest-from+newTo+1
					set change=1
					quit
				}
				set change=1
				if toSource>=to {
					set arrD(from,fromSource-1)=fromDest
					set arrD(fromSource,to)=dest
					quit
				}
				set arrD(from,fromSource-1)=fromDest
				set arrD(fromSource,toSource)=dest
				set arrD(toSource+1,to)=fromDest-from+toSource+1
				quit
			}
			quit:change
		}
		quit:change
	}
	//write !!! zwrite arrD
	if change {
		do findInArr2(.arrD,.arrT,.arrDnew)
		kill arrD
		merge arrD=arrDnew
	}
	quit
}

}

