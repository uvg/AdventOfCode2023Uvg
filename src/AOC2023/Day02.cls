Class AOC2023.Day02 Extends AOC2023.Base
{

Parameter InputFile = "d02.txt";

// d ##class(AOC2023.Day02).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",maxRed=12,maxGreen=13,maxBlue=14,sum=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set id=+$piece(record," ",2)
		set record=$piece(record,": ",2)
		set numOfSets=$length(record,"; ")
		set isOk=1
		for i=1:1:numOfSets {
			set curSet=$piece(record,"; ",i)
			for j=1:1:$length(curSet,", ") {
				set curCheck=$piece(curSet,", ",j)
				set numOfCubes=+curCheck
				set cubeColor=$piece(curCheck," ",2)
				if cubeColor="red",numOfCubes>maxRed set isOk=0 quit
				if cubeColor="green",numOfCubes>maxGreen set isOk=0 quit
				if cubeColor="blue",numOfCubes>maxBlue set isOk=0 quit
			}
			quit:'isOk
		}
		if isOk set sum=sum+id
		if verbose write !,id,?10,isOk,?20,sum
	}
	set answer=sum
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",sum=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line),(maxRed,maxGreen,maxBlue)=0
		set id=+$piece(record," ",2)
		set record=$piece(record,": ",2)
		set numOfSets=$length(record,"; ")
		for i=1:1:numOfSets {
			set curSet=$piece(record,"; ",i)
			for j=1:1:$length(curSet,", ") {
				set curCheck=$piece(curSet,", ",j)
				set numOfCubes=+curCheck
				set cubeColor=$piece(curCheck," ",2)
				if cubeColor="red",maxRed<numOfCubes set maxRed=numOfCubes
				if cubeColor="green",maxGreen<numOfCubes set maxGreen=numOfCubes
				if cubeColor="blue",maxBlue<numOfCubes set maxBlue=numOfCubes
			}
		}
		set power=maxRed*maxGreen*maxBlue
		set sum=sum+power
		if verbose write !,id,?10,power,?20,sum
	}
	set answer=sum
	quit answer
}

}

