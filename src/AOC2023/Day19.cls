Class AOC2023.Day19 Extends AOC2023.Base
{

Parameter InputFile = "d19.txt";

// d ##class(AOC2023.Day19).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	do ..AnalayzeData(.recordsArr,.arrWf,.arrParts)
	if verbose zwrite arrWf,arrParts
	set answer=..GetAccepted(.arrParts,.arrWf)
	quit answer
}

ClassMethod AnalayzeData(ByRef recordsArr, Output arrWf, Output arrParts)
{
	set line="",state=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if state=0,'$length(record) {
			set state=1
			continue
		}
		if state=0 {
			set name=$piece(record,"{",1),wfs=$piece($piece(record,"{",2),"}",1)
			for i=1:1:$length(wfs,",") {
				set wf=$piece(wfs,",",i)
				set cond=$piece(wf,":",1),nwf=$piece(wf,":",2)
				set:'$length(nwf) nwf=cond,cond=""
				set arrWf(name,i)=$listbuild(cond,nwf)
			}
		}
		if state=1 {
			set x=+$piece(record,"x=",2),m=+$piece(record,"m=",2),a=+$piece(record,"a=",2),s=+$piece(record,"s=",2)
			set arrParts($increment(arrParts))=$listbuild(x,m,a,s)
		}
	}
}

ClassMethod GetAccepted(ByRef arrParts, ByRef arrWf)
{
	set part="",total=0
	for  {
		set part=$order(arrParts(part)) quit:part=""
		set partData=arrParts(part)
		continue:'..IsAccepted(partData,.arrWf,"in") 
		//zwrite partData
		set total=total+$list(partData,1)+$list(partData,2)+$list(partData,3)+$list(partData,4)
	}
	quit total
}

ClassMethod IsAccepted(partData As %String, ByRef arrWf, wf As %String) [ PublicList = (x, m, a, s) ]
{
	new x,m,a,s
	if wf="A" quit 1
	if wf="R" quit 0
	set wfPrio=""
	for  {
		set wfPrio=$order(arrWf(wf,wfPrio)) quit:'$length(wfPrio)
		set wfPrioData=arrWf(wf,wfPrio),cond=$list(wfPrioData,1),nwf=$list(wfPrioData,2)
		if '$length(cond) return ..IsAccepted(partData,.arrWf,nwf)
		set x=$list(partData,1),m=$list(partData,2),a=$list(partData,3),s=$list(partData,4)
		if @cond return ..IsAccepted(partData,.arrWf,nwf)
	}
	quit 0
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	do ..AnalayzeData(.recordsArr,.arrWf)
	set allCond=..GetAcceptedConds(.arrWf,"in")
	if verbose zwrite arrWf,allCond
	set cond="",total=0
	for cond=1:1:$listlength(allCond) {
		set data=$list(allCond,cond)
		set comb=1
		for i=1:1:$listlength(data) {
			set range=$list(data,i)
			set comb=($list(range,2)-$list(range,1)+1)*comb
		}
		set total=total+comb
	}
	set answer=total
	quit answer
}

ClassMethod GetAcceptedConds(ByRef arrWf, wf As %String) As %String
{
	//w !!!
	set inst="",prio=""
	for  {
		set prio=$order(arrWf(wf,prio)) quit:'$length(prio)
		//zwrite arrWf(wf,prio)
		set inst=inst_$listbuild(arrWf(wf,prio))
	}
	//zwrite inst
	quit ..GetAcceptedCondsLoop(.arrWf,inst)
}

ClassMethod GetAcceptedCondsLoop(ByRef arrWf, inst As %String) As %String
{
	set wfPrioData=$list(inst,1),cond=$list(wfPrioData,1),nwf=$list(wfPrioData,2)
	if '$length(cond) {
		//                                             x        ,        m         ,      a           ,        s
		if nwf="A" quit $listbuild($listbuild($listbuild(1,4000),$listbuild(1,4000),$listbuild(1,4000),$listbuild(1,4000)))
		if nwf="R" quit ""
		quit ..GetAcceptedConds(.arrWf,nwf)
	}
	set gt=1,val=$piece(cond,">",2)
	set:cond["<" gt=0,val=$piece(cond,"<",2)
	set ltr=$extract(cond)
	set falseVals=$select(gt:val+1,1:val-1)
	set trueRanges=..GetRanges(ltr,gt,val,..GetAcceptedCondsLoop(.arrWf,$listbuild($listbuild("",nwf))))
	set falseRanges=..GetRanges(ltr,'gt,falseVals,..GetAcceptedCondsLoop(.arrWf,$list(inst,2,*)))
	quit trueRanges_falseRanges
}

ClassMethod GetRanges(ltr As %String, gt As %Boolean, val As %Integer, ranges As %String) As %String
{
	set pos=$listfind($listbuild("x","m","a","s"),ltr)
	set ans=""
	for i=1:1:$listlength(ranges) {
		set range=$list(ranges,i)
		set data=$list(range,pos)
		set from=$list(data,1),to=$list(data,2)
		set:gt from=..Max(from,val+1)
		set:'gt to=..Min(to,val-1)
		continue:from>to
		set data=$listbuild(from,to)
		set $list(range,pos)=data
		set ans=ans_$listbuild(range)
	}
	quit ans
}

ClassMethod Min(Val1 As %Integer, Val2 As %Integer) As %Integer
{
	if Val1<Val2 quit Val1
	quit Val2
}

ClassMethod Max(Val1 As %Integer, Val2 As %Integer) As %Integer
{
	if Val1>Val2 quit Val1
	quit Val2
}

}

