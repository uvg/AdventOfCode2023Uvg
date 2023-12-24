from z3 import *

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

def calc(x0,y0,z0,dx0,dy0,dz0,x1,y1,z1,dx1,dy1,dz1,x2,y2,z2,dx2,dy2,dz2):
    rx, ry, rz = Ints('rx ry rz')
    rvx, rvy, rvz = Ints('rvx rvy rvz')
    t0, t1, t2 = Ints('t0 t1 t2')
    answer = Int('answer')

    s=Solver()
    s.add(
        rx + t0 * rvx == x0 + t0 * dx0,
        ry + t0 * rvy == y0 + t0 * dy0,
        rz + t0 * rvz == z0 + t0 * dz0,

        rx + t1 * rvx == x1 + t1 * dx1,
        ry + t1 * rvy == y1 + t1 * dy1,
        rz + t1 * rvz == z1 + t1 * dz1,

        rx + t2 * rvx == x2 + t2 * dx2,
        ry + t2 * rvy == y2 + t2 * dy2,
        rz + t2 * rvz == z2 + t2 * dz2,

        answer == rx + ry + rz,
    )

    r=s.check()
    if r==unsat or r==unknown:
        return -1
    else:
        return s.model()[answer].as_long()
