Class AOC2023.Day24 Extends AOC2023.Base
{

Parameter InputFile = "d24.txt";

// d ##class(AOC2023.Day24).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set pos=$piece(record," @ ",1),delta=$piece(record," @ ",2)
		set x=+$zstrip($piece(pos,", ",1),"*w"),y=+$zstrip($piece(pos,", ",2),"*w"),z=+$zstrip($piece(pos,", ",3),"*w")
		set dx=+$zstrip($piece(delta,", ",1),"*w"),dy=+$zstrip($piece(delta,", ",2),"*w"),dz=+$zstrip($piece(delta,", ",3),"*w")
		set arr($increment(arr))=$listbuild(x,y,z,dx,dy,dz)
	}
	if verbose zwrite arr
	set minPos=7,maxPos=27
	if arr>10 set minPos=200000000000000,maxPos=400000000000000
	set cnt=0
	for hailstoneCnt1=1:1:arr-1 {
		set hailstone1=arr(hailstoneCnt1)
		set x1=$list(hailstone1,1),y1=$list(hailstone1,2),z1=$list(hailstone1,3),dx1=$list(hailstone1,4),dy1=$list(hailstone1,5),dz1=$list(hailstone1,6)
		for hailstoneCnt2=hailstoneCnt1+1:1:arr {
			set hailstone2=arr(hailstoneCnt2)
			set x2=$list(hailstone2,1),y2=$list(hailstone2,2),z2=$list(hailstone2,3),dx2=$list(hailstone2,4),dy2=$list(hailstone2,5),dz2=$list(hailstone2,6)
			set t1=(dx1*-dy2)-(-dx2*dy1)
			continue:'t1
			set t2=1/t1
			set dx=x2-x1,dy=y2-y1
			set x=(t2*-dy2*dx)+(t2*dx2*dy)
			set y=(t2*-dy1*dx)+(t2*dx1*dy)
			set posx=dx1*x+x1,posy=dy1*x+y1
			set isInside=0,past=0
			if posx>=minPos,posx<=maxPos,posy>=minPos,posy<=maxPos set isInside=1
			if isInside,posx>x1,dx1<0 set isInside=0,past=1
			if isInside,posx<x1,dx1>0 set isInside=0,past=1
			if isInside,posy>y1,dy1<0 set isInside=0,past=1
			if isInside,posy<y1,dy1>0 set isInside=0,past=1
			if isInside,posx>x2,dx2<0 set isInside=0,past=2
			if isInside,posx<x2,dx2>0 set isInside=0,past=2
			if isInside,posy>y2,dy2<0 set isInside=0,past=2
			if isInside,posy<y2,dy2>0 set isInside=0,past=2
			if isInside set cnt=cnt+1
		} 
	}
	set answer=cnt
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",maxDelta=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set pos=$piece(record," @ ",1),delta=$piece(record," @ ",2)
		set tx=+$zstrip($piece(pos,", ",1),"*w"),ty=+$zstrip($piece(pos,", ",2),"*w"),tz=+$zstrip($piece(pos,", ",3),"*w")
		set tdx=+$zstrip($piece(delta,", ",1),"*w"),tdy=+$zstrip($piece(delta,", ",2),"*w"),tdz=+$zstrip($piece(delta,", ",3),"*w")
		set maxDelta=..Max(maxDelta,$zabs(tdx))
		set maxDelta=..Max(maxDelta,$zabs(tdy))
		set maxDelta=..Max(maxDelta,$zabs(tdz))
		continue:line>3
		set x(line)=tx,y(line)=ty,z(line)=tz,dx(line)=tdx,dy(line)=tdy,dz(line)=tdz
	}
	if verbose zwrite x,y,z,dx,dy,dz
	//set d24Solve=##class(%SYS.Python).Import("d24")
	//set answer=d24Solve.calc(x(1),y(1),z(1),dx(1),dy(1),dz(1),x(2),y(2),z(2),dx(2),dy(2),dz(2),x(3),y(3),z(3),dx(3),dy(3),dz(3))
	//set answer=..Calc(x(1),y(1),z(1),dx(1),dy(1),dz(1),x(2),y(2),z(2),dx(2),dy(2),dz(2),x(3),y(3),z(3),dx(3),dy(3),dz(3))
	set answer=..Calc(.x,.y,.z,.dx,.dy,.dz,maxDelta\2+1)
	quit answer
}

ClassMethod Calc(ByRef x, ByRef y, ByRef z, ByRef arrDx, ByRef arrDy, ByRef arrDz, maxDelta As %Integer) As %Integer
{
	for tdx=-maxDelta:1:maxDelta {
		for i=1:1:3 {
			set tdx(i)=arrDx(i)-tdx
		}
		continue:'tdx(1)
		continue:'tdx(3)
		for tdy=-maxDelta:1:maxDelta {
			for i=1:1:3 {
				set tdy(i)=arrDy(i)-tdy
			}
			/*from part 1:
			set t1=(dx1*-dy2)-(-dx2*dy1)
			continue:'t1 
			set t2=1/t1
			set dx=x2-x1,dy=y2-y1
			set x=(t2*-dy2*dx)+(t2*dx2*dy)
			*/
			//set t1=(tdx(1)*-tdy(2))-(-tdx(2)*tdy(1))
			//A*x=B
			//A^(-1)*A*x=A^(-1)*B
			//I*x=A^(-1)*B
			//x=A^(-1)*B
			set t1=tdy(1)*tdx(2)-(tdx(1)*tdy(2))
			continue:'t1  //Parallels
			//set t2=1/t1
			set dx=x(2)-x(1),dy=y(2)-y(1)
			//set t(2)=(t2*-tdy(2)*dx)+(t2*tdx(2)*dy)
			set t(2)=(tdx(1)*dy-(tdy(1)*dx))/t1
			continue:t(2)\1'=t(2)  //Not an integer
			set nx=t(2)*tdx(2)+x(2)-x(3)
			set t(3)=nx/tdx(3)
			continue:t(3)\1'=t(3)  //Not an integer
			set t(1)=(tdx(2)*t(2)+dx)/tdx(1)
			continue:t(1)\1'=t(1)  //Not an integer
			for tdz=-maxDelta:1:maxDelta {
				for i=1:1:3 {
					set tdz(i)=arrDz(i)+tdz
					set nx(i)=t(i)*tdx(i)+x(i)
					set ny(i)=t(i)*tdy(i)+y(i)
					set nz(i)=t(i)*tdz(i)+z(i)
				}
				//if $zabs(nx(1))=24,$zabs(nz(1))=10 zw nx,ny,nz,tdx,tdy,tdz
				if nx(2)=nx(1),nx(3)=nx(1),ny(2)=ny(1),ny(3)=ny(1),nz(2)=nz(1),nz(3)=nz(1) {
					return nx(1)+ny(1)+nz(1)
				}
			}
		}
	}
	quit 0
}

ClassMethod Max(Val1 As %Integer, Val2 As %Integer) As %Integer
{
	if Val1>Val2 quit Val1
	quit Val2
}

/*
ClassMethod Calc(x0 As %Integer, y0 As %Integer, z0 As %Integer, dx0 As %Integer, dy0 As %Integer, dz0 As %Integer, x1 As %Integer, y1 As %Integer, z1 As %Integer, dx1 As %Integer, dy1 As %Integer, dz1 As %Integer, x2 As %Integer, y2 As %Integer, z2 As %Integer, dx2 As %Integer, dy2 As %Integer, dz2 As %Integer) As %Integer [ Language = python ]
{
rx, ry, rz = Ints('rx ry rz')
rvx, rvy, rvz = Ints('rvx rvy rvz')
t0, t1, t2 = Ints('t0 t1 t2')
answer = Int('answer')

#Initiating a Z3 solver
s=Solver()

#Adding the equations to the solver
s.add(rx+t0*rvx == x0 + t0 * dx0)
s.add(ry+t0*rvy==y0+t0*dy0)
s.add(rz+t0*rvz==z0+t0*dz0)
s.add(rx+t1*rvx==x1+t1*dx1)
s.add(ry+t1*rvy==y1+t1*dy1)
s.add(rz+t1*rvz==z1+t1*dz1)
s.add(rx+t2*rvx==x2+t2*dx2)
s.add(ry+t2*rvy==y2+t2*dy2)
s.add(rz+t2*rvz==z2+t2*dz2)
s.add(answer==rx+ry+rz)

#Running the solver to check for an answer
r=s.check()

#Return the answer
if r==unsat or r==unknown:
    return -1
else:
    return s.model()[answer].as_long()
}

XData %import [ MimeType = application/python ]
{
from z3 import *
}
*/
}

