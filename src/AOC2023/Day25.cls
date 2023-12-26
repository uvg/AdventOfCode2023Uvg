Class AOC2023.Day25 Extends AOC2023.Base
{

Parameter InputFile = "d25.txt";

// d ##class(AOC2023.Day25).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",arr=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set side1=$piece(record,": ",1),sides2=$piece(record,": ",2)
		set:'$data(arr(side1)) arr=arr+1
		for i=1:1:$length(sides2," ") {
			set side2=$piece(sides2," ",i)
			set:'$data(arr(side2)) arr=arr+1
			set arr(side1,side2)=1
			set arr(side2,side1)=1
		}
	}
	set total=arr
	set length=..GetLength(.arr)
	set answer=length*(total-length)
	quit answer
}

ClassMethod GetLength(ByRef arr) As %Integer
{
	set comp1=$order(arr(""))
	for  {
		set compR=$random(arr-1)+2
		set comp2=""
		for  {
			quit:'compR
			set comp2=$order(arr(comp2)) quit:comp2=""
			set compR=compR-1
		}
		//s comp1="qnr",comp2="rhn"
		set flow=..GetDinitzMaximumFlow(.arr,comp1,comp2,.arrCap)
		continue:flow'=3
		set comps(comp1)="",changed=1,comps=1
		for  {
			quit:'changed
			set changed=0
			set tcomp=""
			for  {
				set tcomp=$order(comps(tcomp)) quit:tcomp=""
				set ncomp=""
				for  {
					set ncomp=$order(arrCap(tcomp,ncomp)) quit:ncomp=""
					continue:$data(comps(ncomp))
					set cap=arrCap(tcomp,ncomp)
					continue:cap'>0
					set comps(ncomp)=""
					set changed=1,comps=comps+1
				}
			}
		}
		return comps
	}
	quit 0
}

ClassMethod GetDinitzMaximumFlow(ByRef arr, from As %String, to As %String, Output arrCap) As %Integer
{
	kill arrCap
	merge arrCap=arr
	set flow=0,comp1=from
	for  {
		kill Queue,level,valid
		set tcomp=""
		for  {
			set tcomp=$order(arr(tcomp)) quit:tcomp=""
			set level(tcomp)=-1
		}
		set Queue($increment(Queue))=comp1,level(comp1)=0,found=0
		for  {
			set key=$order(Queue("")) quit:'key
			set comp2=Queue(key) kill Queue(key)
			if comp2=to {
				set found=1
				quit
			}
			set tcomp=""
			for  {
				set tcomp=$order(arrCap(comp2,tcomp)) quit:tcomp=""
				set cap=arrCap(comp2,tcomp)
				continue:'cap
				if level(tcomp)=-1 {
					set level(tcomp)=level(comp2)+1
					set Queue($increment(Queue))=tcomp
				}
				if level(comp2)+1=level(tcomp) {
					set valid(comp2,tcomp)=""
				}
			}
		}
		return:'found flow
		set flowAugmenting=..AddAugmentingFlow(.valid,.arrCap,from,to,9999999999)
		set flow=flow+flowAugmenting
	}
	quit flow
}

ClassMethod AddAugmentingFlow(ByRef valid, ByRef arrCap, from As %String, to As %String, minUsed As %Integer) As %Integer
{
	quit:from=to minUsed
	set used=0
	for  {
		quit:'$data(valid(from))
		set next=$order(valid(from,""))
		kill valid(from,next)
		set cap=arrCap(from,next)
		set r=..AddAugmentingFlow(.valid,.arrCap,next,to,..Min(minUsed-used,cap))
		set used=used+r
		set arrCap(from,next)=arrCap(from,next)-r
		set arrCap(next,from)=arrCap(next,from)+r
		if r>0,r<cap set valid(from,next)=""
	}
	quit used
}

ClassMethod Min(Val1 As %Integer, Val2 As %Integer) As %Integer
{
	if Val1<Val2 quit Val1
	quit Val2
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	if verbose write !,"You made it to the last day"
	set answer="Finito la comedy"
	quit answer
}

}

