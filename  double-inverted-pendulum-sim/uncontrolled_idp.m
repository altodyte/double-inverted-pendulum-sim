%VPreston, BWarner - November 21, 2014 - Inverted Double Pendulum

function uncontrolled_idp

%Parameters
mc = 1;

l1 = 1;
m1 = 1;
I1 = 1/3*m1*l1^2;

l2 = 1;
m2 = 1;
I2 = 1/12*m2*l2^2;

g = 9.81;

%Initial Conditions
xc = 0;
xcdot = 0;
theta1 = 0;
theta1dot = 0;
theta2 = 0.1;
theta2dot = 0;
Rx = 0;
Ry = 0;
Px = 0;
Py = 0;
inputs = [xc, theta1, theta2, xcdot, theta1dot, theta2dot, Rx, Ry, Px, Py];

%ODE
time = [0:0.01:10];
[T,X] = ode45(@swing, time, inputs);

xc_pos = X(:,1);
yc_pos = 0;
link1_end_x = -l1*sin(X(:,2)) + xc_pos;
link1_end_y = l1*cos(X(:,2));
link2_end_x = link1_end_x - l2*sin(X(:,3));
link2_end_y = link1_end_y + l2*cos(X(:,3));

positions = [xc_pos, link1_end_x, link1_end_y, link2_end_x, link2_end_y];
animate_func(T,positions);

figure;
hold on
plot(xc_pos, yc_pos, 'r-');
plot(link1_end_x, link1_end_y, 'b-');
plot(link2_end_x, link2_end_y, 'g-');

%Plotting

    function states = swing(T,Z)
        %inputs = [xc, theta1, theta2,   xcdot, theta1dot, theta2dot, Rx, Ry, Px, Py];
        pos_cart = Z(1);
        vel_cart = Z(4);
        t1 = Z(2);
        td1 = Z(5);
        t2 = Z(3);
        td2 = Z(6);
        %Rx = Z(7), Ry = Z(8), Px = Z(9), Py = Z(10)
         
        row1 = [-1 0 0 0 0 0 0];
        row2 = [0 -m1*l1/2*sin(t1) 0 1 0 1 0];
        row3 = [0 m1*l1/2*cos(t1) 0 0 1 0 1];
        row4 = [0 I1 0 0 0 l1*cos(t1) l1*sin(t1)];
        row5 = [0 -m2*l1*sin(t1) -m2*l2/2*sin(t2) 0 0 1 0];
        row6 = [0 -m2*l1*cos(t1) -m2*l2/2*cos(t2) 0 0 0 1];
        row7 = [0 0 -I2 0 0 -l2/2*cos(t2) -l2/2*sin(t2)];
        M = [row1; row2; row3; row4; row5; row6; row7];
        
        stuff = [0; 
            m1*l1/2*td1^2*cos(t1); 
            m1*g - m1*l1/2*td1^2*sin(t1); 
            l1/2*m1*g*sin(t1); 
            m2*(l1*td1^2*cos(t1) - l2/2*td2^2*cos(t2)); 
            -m2*g - m2*(l1*td1^2*sin(t1) - l2/2*td2^2*sin(t2));  
            0 ];
        
        solver = M\stuff;
        
        states = [vel_cart; td1; td2; solver];
    end

function animate_func(T,M)
    
for i=1:length(T)
clf;
X1 = [M(i,1), M(i,2)];
Y1 = [0, M(i,3)];
X2 = [M(i,2), M(i,4)];
Y2 = [M(i,3), M(i,5)];
axis([-2 2 -2 2]);
hold on;
draw_func(X1, Y1, X2, Y2);
drawnow;
end
end

function draw_func(x1, y1, x2, y2)
plot(x1, y1, 'r-');
plot(x2, y2, 'b-');
end




end

