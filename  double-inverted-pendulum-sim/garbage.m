B = sqrt(l1^2+l2^2-2*l1*l2*cos(beta)); % origin-bar2tip distance
    zeta = asin(-l2*sin(beta)/(B)); % angle between bar1 and system COM
    C = 0.5*sqrt(l1^2+(B/2)^2-B*cos(zeta)); % origin-systemCOM distance
    COM_angle = (sin(zeta)*B)/(4*C)+t1A