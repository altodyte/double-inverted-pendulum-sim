g = 9.81;
m1 = 1;
m2 = 1;
l1 = 1;
l2 = 1;
I1 = 1/3*m1*l1^2;
%I1COM = 1/12*m1*l1^2;
I2 = 1/12*m2*l2^2;
I2COM = 1/12*m2*l2^2;
syms t1 t2 td1 td2;
M = [I1 0 -l1*cos(t1) l1*sin(t1) 0 0; ...
    0 I2 -l2/2*cos(t2) l2/2*sin(t2) 0 0; ...
    -m2*l1*cos(t1) -m2*l2/2*cos(t2) -1 0 0 0; ...
    m2*l1*sin(t1) m2*l2/2*sin(t2) 0 -1 0 0; ...
    -m1*l1/2*cos(t1) 0 1 0 1 0; ...
    0 -m1*l1/2*sin(t1) 0 1 0 1];

b = [(-l1/2*m1*g*sin(t1)); ...
    0; ...
    (-m1*l1*td1^2*sin(t1) -  m2*l2/2*td2^2*sin(t2)); ...
    (-m2*g - m2*l1*td1^2*cos(t1) - m2*l2/2*td2^2*cos(t2)); ...
    (-m1*l1/2*td1^2*sin(t1)); ...
    (m1*g + m1*l1/2*td1^2*cos(t1))];

s = simple(inv(M)*b);
S = M\b;
s./S