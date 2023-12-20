Class AOC2023.Day20 Extends AOC2023.Base
{

Parameter InputFile = "d20.txt";

// d ##class(AOC2023.Day20).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set name=$piece(record," -> ",1),outputs=$piece(record," -> ",2),type=""
		if name'="broadcaster" set type=$extract(name,1),name=$extract(name,2,*)
		set arr(0,name)=$listbuild(type,0)
		for i=1:1:$length(outputs,", ") {
			set output=$piece(outputs,", ",i)
			set arr(0,name,output)=""
			set arr(1,output,name)=""
		}
	}
	if verbose zwrite arr
	set (totalLow,totalHigh)=0
	for i=1:1:1000 {
		//write !,"Loop #",i,":"
		do ..ProcessPulse(.arr,.totalLow,.totalHigh)
		//write ! zwrite totalLow,totalHigh
	}
	set answer=totalLow*totalHigh
	quit answer
}

ClassMethod ProcessPulse(ByRef arr, ByRef low, ByRef high, stopModuleInput As %String = "", stopModuleOutput As %String = "", stopOutputPulse As %Boolean = 0)
{
	do ..AddToQueue(.Queue,"broadcaster",0,"button")
	for  {
		set prio=$order(Queue("")) quit:'$length(prio)
		set key=$order(Queue(prio,"")),data=Queue(prio,key) kill Queue(prio,key)
		set name=$list(data,1),pulse=$list(data,2),from=$list(data,3)
		set:'pulse low=low+1
		set:pulse high=high+1
		if $length(stopModuleInput),name=stopModuleInput,'pulse return 1
		//write !,from," -",$select(pulse:"high",1:"low"),"-> ",name
		continue:'$data(arr(0,name))
		set moduleData=arr(0,name)
		set type=$list(moduleData,1),curOut=$list(moduleData,2)
		if type="%" {
			continue:pulse
			set curOut='curOut
		}
		if type="&" {
			set input="",allHigh=1
			for  {
				set input=$order(arr(1,name,input)) quit:input=""
				if '$list(arr(0,input),2) {
					set allHigh=0
					quit
				}
			}
			set curOut='allHigh
		}
		set $list(moduleData,2)=curOut
		set arr(0,name)=moduleData
		if $length(stopModuleOutput),name=stopModuleOutput,curOut=stopOutputPulse return 1
		//
		set output=""
		for  {
			set output=$order(arr(0,name,output)) quit:output=""
			do ..AddToQueue(.Queue,output,curOut,name)
		}
	}
	quit 0
}

ClassMethod AddToQueue(ByRef Queue, name As %String, pulse As %Boolean, from As %String)
{
	set prio=$increment(Queue)
	set key=$order(Queue(prio,""),-1)+1
	set Queue(prio,key)=$listbuild(name,pulse,from)
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set name=$piece(record," -> ",1),outputs=$piece(record," -> ",2),type=""
		if name'="broadcaster" set type=$extract(name,1),name=$extract(name,2,*)
		set arr(0,name)=$listbuild(type,0)
		for i=1:1:$length(outputs,", ") {
			set output=$piece(outputs,", ",i)
			set arr(0,name,output)=""
			set arr(1,output,name)=""
		}
	}
	if verbose zwrite arr
	merge OrigArr=arr
	do ..GetStopModules("rx",.arr,0,0,.stopModuleArr)
	if verbose zwrite stopModuleArr
	set lastLevel=$order(stopModuleArr(""),-1)
	set stopOutputPulse=stopModuleArr(lastLevel)
	set mul=1
	set stopModuleOutput=""
	for  {
		set stopModuleOutput=$order(stopModuleArr(lastLevel,stopModuleOutput)) quit:stopModuleOutput=""
		kill arr merge arr=OrigArr
		for i=1:1 {
			//write !,"Loop #",i,":"
			quit:..ProcessPulse(.arr,0,0,,stopModuleOutput,stopOutputPulse)
		}
		set mul=mul*i
		if verbose write !,stopModuleOutput,"=",i
	}
	set answer=mul
	quit answer
}

ClassMethod GetStopModules(stopModule As %String, ByRef modulesArr, stopPulse As %Boolean, level As %Integer, Output stopArr)
{
	set allCon=1
	for  {
		quit:'allCon
		set input="",ans=""
		for  {
			set input=$order(modulesArr(1,stopModule,input)) quit:input=""
			if $list(modulesArr(0,input),1)'="&" {
				set allCon=0
				quit
			}
		}
		if allCon {
			merge stopArr(level)=modulesArr(1,stopModule)
			set stopArr(level)=stopPulse
			for  {
				set input=$order(modulesArr(1,stopModule,input)) quit:input=""
				do ..GetStopModules(input,.modulesArr,'stopPulse,level+1,.stopArr)
			}
			quit
		}
	}
}

}

