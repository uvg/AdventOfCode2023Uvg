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
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set pos=$piece(record," @ ",1),delta=$piece(record," @ ",2)
		set tx=+$zstrip($piece(pos,", ",1),"*w"),ty=+$zstrip($piece(pos,", ",2),"*w"),tz=+$zstrip($piece(pos,", ",3),"*w")
		set tdx=+$zstrip($piece(delta,", ",1),"*w"),tdy=+$zstrip($piece(delta,", ",2),"*w"),tdz=+$zstrip($piece(delta,", ",3),"*w")
		set x(line)=tx,y(line)=ty,z(line)=tz,dx(line)=tdx,dy(line)=tdy,dz(line)=tdz
		quit:line>3
	}
	if verbose zwrite x,y,z,dx,dy,dz
	set d24Solve=##class(%SYS.Python).Import("d24")
	set answer=d24Solve.calc(x(1),y(1),z(1),dx(1),dy(1),dz(1),x(2),y(2),z(2),dx(2),dy(2),dz(2),x(3),y(3),z(3),dx(3),dy(3),dz(3))
	quit answer
}

// ClassMethod Calc(x0 As %Integer, y0 As %Integer, z0 As %Integer, dx0 As %Integer, dy0 As %Integer, dz0 As %Integer, x1 As %Integer, y1 As %Integer, z1 As %Integer, dx1 As %Integer, dy1 As %Integer, dz1 As %Integer, x2 As %Integer, y2 As %Integer, z2 As %Integer, dx2 As %Integer, dy2 As %Integer, dz2 As %Integer) As %Integer [ Language = python ]

/*ClassMethod Calc() As %Integer [ Language = python ]
{
import z3
from z3 import Ints
from z3 import Solver
from z3 import CheckSatResult
from z3 import unsat
from z3 import unknown

#rx, ry, rz = Ints('rx ry rz')
#rvx, rvy, rvz = Ints('rvx rvy rvz')
#t0, t1, t2 = Ints('t0 t1 t2')
#answer = Ints('answer')



x0=171178400007298
y0=165283791547432
z0=246565404194007
dx0=190
dy0=186
dz0=60

x1=250314870325177
y1=283762496814661
z1=272019235409859
dx1=45
dy1=15
dz1=8

x2=192727134181171
y2=456146317292988
z2=246796112051543
dx2=22
dy2=-541
dz2=-70


rx = Ints('rx')
ry = Ints('ry')
rz = Ints('rz')
rvx = Ints('rvx')
rvy = Ints('rvy')
rvz = Ints('rvz')
t0 = Ints('t0')
t1 = Ints('t1')
t2 = Ints('t2')
answer = Ints('answer')


#print((x0, y0, z0, dx0, dy0, dz0, x1, y1, z1, dx1, dy1, dz1, x2, y2, z2, dx2, dy2, dz2))
#print((type(x0),type(x1),type(x2),type(dx0),type(dx1),type(dx2),type(y0),type(y1),type(y2),type(dy0),type(dy1),type(dy2),type(z0),type(z1),type(z2),type(dz0),type(dz1),type(dz2)))
s=Solver()

'''
x0=171178400007298
y0=165283791547432
z0=246565404194007
dx0=190
dy0=186
dz0=60

x1=250314870325177
y1=283762496814661
z1=272019235409859
dx1=45
dy1=15
dz1=8

x2=192727134181171
y2=456146317292988
z2=246796112051543
dx2=22
dy2=-541
dz2=-70
'''

print("before adding")
'''
s.add(
    rx+t0*rvx==171178400007298+t0*190,
    ry+t0*rvy==165283791547432+t0*186,
    rz+t0*rvz==246565404194007+t0*60,
    rx+t1*rvx==250314870325177+t1*5,
    ry+t1*rvy==283762496814661+t1*15,
    rz+t1*rvz==272019235409859+t1*8,
    rx+t2*rvx==192727134181171+t2*22,
    ry+t2*rvy==456146317292988+t2*-541,
    rz+t2*rvz==246796112051543+t2*-70,
    answer==rx+ry+rz,
)
'''
s.add(
    rx + t0 * rvx == x0 + t0 * dx0,
    ry == 200,
    answer == rx + ry,
)

print("after adding")
r=s.check()
#print(s.model())
if r==unsat or r==unknown:
    return -1
else:
    return s.model()[answer]
}
*/
}

