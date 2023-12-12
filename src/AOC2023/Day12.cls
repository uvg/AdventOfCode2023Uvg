Class AOC2023.Day12 Extends AOC2023.Base
{

Parameter InputFile = "d12.txt";

// d ##class(AOC2023.Day12).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set layout=$piece(record," ",1),size=$piece(record," ",2)
		set combo=..GetCombinations(layout,size,0)
		set total=total+combo
		if verbose write !,record,?40,combo
	}
	set answer=total
	quit answer
}

ClassMethod GetCombinations(layout As %String, size As %String, inside As %Integer, ByRef arr) As %Integer
{
	if 'size,inside quit 0
	if '$length(layout) {
		quit:$length(size,",")>1 0
		quit inside=+size
	}
	set (tot,dmg)=0
	for i=1:1:$length(layout) {
		set:$extract(layout,i)'="." dmg=dmg+1
	}
	for i=1:1:$length(size,",") {
		set tot=tot+$piece(size,",",i)
	}
	quit:dmg+inside<tot 0
	//i layout="???.###",size="1,1,3" w dmg,";",inside,";",tot,!
	if $length(size),$data(arr(layout,size,inside)) quit arr(layout,size,inside)
	set total=0
	set ltr=$extract(layout)
	if ltr=".",inside {
		if inside'=+size quit 0
		set total=total+..GetCombinations($extract(layout,2,*),$piece(size,",",2,*),0,.arr)
	}
	if ltr="?",inside,inside=+size set total=total+..GetCombinations($extract(layout,2,*),$piece(size,",",2,*),0,.arr)
	if "?#"[ltr set total=total+..GetCombinations($extract(layout,2,*),size,inside+1,.arr)
	if "?."[ltr,'inside set total=total+..GetCombinations($extract(layout,2,*),size,0,.arr)
	set:$length(size) arr(layout,size,inside)=total
	quit total
}

/*
ClassMethod GetCombinations(layout As %String, size As %String, ByRef arr) As %Integer
{
	set total=0
	for i=1:1:$length(layout) {
		continue:$extract(layout,i)'="?"
		set (tLayout1,tLayout2)=layout,$extract(tLayout1,i)=".",$extract(tLayout2,i)="#"
		if '$data(arr(tLayout1)) set arr(tLayout1)="",total=total+..GetCombinations(tLayout1,size,.arr)
		if '$data(arr(tLayout2)) set arr(tLayout2)="",total=total+..GetCombinations(tLayout2,size,.arr)
	}
	quit:layout["?" total
	set state=0,start=1,arrParts=0
	for i=1:1:$length(layout) {
		set ltr=$extract(layout,i)
		if state=0,ltr'="." {
			set start=i,state=1
			continue
		}
		if state=1,ltr="." {
			set str=$extract(layout,start,i-1)
			set arrParts($increment(arrParts))=str
			set state=0
			continue
		}
	}
	if state=1 {
		set str=$extract(layout,start,*)
		set arrParts($increment(arrParts))=str
	}
	if arrParts'=$length(size,",") quit 0
	for i=1:1:arrParts {
		if $length(arrParts(i))'=$piece(size,",",i) return 0
	}
	//write !!! zwrite layout,arrParts,size hang 1
	quit 1
}
*/
ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set layout=$piece(record," ",1),size=$piece(record," ",2)
		set (newLayout,newSize)=""
		for i=1:1:5 {
			set newLayout=newLayout_"?"_layout
			set newSize=newSize_","_size
		}
		set $extract(newLayout)="",$extract(newSize)=""
		set combo=..GetCombinations(newLayout,newSize,0)
		set total=total+combo
		if verbose write !,record,?40,combo
	}
	set answer=total
	quit answer
}

}

