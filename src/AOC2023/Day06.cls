Class AOC2023.Day06 Extends AOC2023.Base
{

Parameter InputFile = "d06.txt";

// d ##class(AOC2023.Day06).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if record["Time: " {
			set times=$piece(record,"Time: ",2)
			for i=1:1:$length(times," ") {
				set time=$piece(times," ",i)
				if time set arr(1,$increment(cntTime))=time
			}
		}
		if record["Distance: " {
			set distances=$piece(record,"Distance: ",2)
			for i=1:1:$length(distances," ") {
				set distance=$piece(distances," ",i)
				if distance set arr(2,$increment(cntDistance))=distance
			}
		}
	}
	set i="",mul=1
	for  {
		set i=$order(arr(1,i)) quit:i=""
		set time=arr(1,i),dist=arr(2,i),counter=0
		for j=1:1:time {
			if j*(time-j)>dist set counter=time-j-j+1 quit  //write !,time,":",dist,":",j
		}
		if verbose write !,"time: ",time,", dist: ",dist,", options: ",counter
		set mul=mul*counter
	}
	set answer=mul
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set:record["Time: " time=$zstrip($piece(record,"Time: ",2),"*W")
		set:record["Distance: " dist=$zstrip($piece(record,"Distance: ",2),"*W")
	}
	if verbose write !,"time: ",time,", dist: ",dist
	set i="",counter=0
	for j=1:1:time {
		if j*(time-j)>dist set counter=time-j-j+1 quit  //write !,time,":",dist,":",j
	}
	set answer=counter
	quit answer
}

}

