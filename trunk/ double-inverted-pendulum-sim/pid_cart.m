%Victoria Preston - Dynamics - Double Bar Pendulum

function pid_cart
clf;

%Parameters
g = 9.81;
m1 = 1;
m2 = 1;
mc = 1;
l1 = 1;
l2 = 1;
I1 = 1/3;
I1COM = 1/12*m1*l1^2;
I2 = 1/12;
I2COM = 1/12*m2*l2^2;

%Opening
xc = 0;
xcdot = 0;
theta1 = pi;
theta2 = pi+0.1;
theta1dot = 0;
theta2dot = 0;

states = [xc, theta1, theta2, xcdot, theta1dot, theta2dot, 0, 0, 0, 0];
time = 0:0.01:10;
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9);

[T,X] = ode45(@swing, time, states, options);
xcart = X(:,1);
yc = 0;

x1 = l1*sin(X(:,2))+xcart;
y1 = -l1*cos(X(:,2));

x2 = x1+l2*sin(X(:,3));
y2 = y1-l2*cos(X(:,3));


stuff = [xcart, x1, y1, x2, y2];
animate_func(T, stuff)

figure;
hold on;
plot(x1, y1, 'g-')
plot(x2, y2, 'r-')

figure;
hold on;
plot(T,X(:,1), 'g-')
plot(T, X(:,2), 'r-')
legend('Top Bar', 'Bottom Bar')
title('Angular Displacement over time')
xlabel('Time')
ylabel('Radians')


function states = swing(T,Z)
    x_pos = Z(1);
    t1 = Z(2);
    t2 = Z(3);
    x_vel = Z(4);
    td1 = Z(5);
    td2 = Z(6);
    
    M = [0 I1 0 -l1*cos(t1) l1*sin(t1) 0 0; 
        0 0 I2 -l2/2*cos(t2) l2/2*sin(t2) 0 0; 
        -m2 -m2*l1*cos(t1) -m2*l2/2*cos(t2) -1 0 0 0; 
        0 m2*l1*sin(t1) m2*l2/2*sin(t2) 0 -1 0 0; 
        -m1 -m1*l1/2*cos(t1) 0 1 0 1 0; 
        0 0 -m1*l1/2*sin(t1) 0 1 0 1; 
        -mc 0 0 0 0 -1 0];
    
    b = [(-l1/2*m1*g*sin(t1)); 
        0; 
        (-m1*l1*td1^2*sin(t1) -  m2*l2/2*td2^2*sin(t2)); 
        (-m2*g - m2*l1*td1^2*cos(t1) - m2*l2/2*td2^2*cos(t2)); 
        (-m1*l1/2*td1^2*sin(t1)); 
        (m1*g + m1*l1/2*td1^2*cos(t1));
        0];
    
    solver = M\b;
    states = [x_vel; td1; td2; solver] + [0; 0; 0; control(Z); 0; 0; 0; 0; 0; 0];

end

function accel = control(Z)
    t1 = Z(2); % Angle of first bar
    t1A = rem(t1,2*pi); % 0 to 2pi angle
    t2 = Z(3); % Angle of second bar
    t2A = rem(t2,2*pi); % 0 to 2pi angle
    p = 0.1;
    beta = pi + t1A - t2A; % Angle between bars
    C = 0.5*sqrt(l1^2+l2^2-2*l1*l2*cos(beta));
    zeta = asin(-l2*sin(beta)/(2*C));
    OC = sqrt((l1/2)^2+(C/2)^2-2*(l1/2)*(C/2)*cos(zeta));
    COM_angle = -l2*sin(beta)/(4*OC);
    %error = pi-t1A;
    error = pi-COM_angle;
    torque = p*error;
    % Converty to angular acceleration for simulation
    r = sqrt(l1^2 + (l2/2)^2 - 2*l1*(l2/2)*cos(t1A+t2A)); % radius to second bar
    I_system = I2COM + m2*r^2; % Unrotated Moment of Inertia about origin
    alpha = torque/I_system;
    % convert to linear acceleration of the cart
    accel = torque/r/(m1+m2);
end
        

function animate_func(T,M)
    
for i=1:length(T)
clf;
XC = [M(i,1) - 0.1, M(i,1) + 0.1];
YC = [0, 0];
X1 = [M(i,1), M(i,2)];
Y1 = [0, M(i,3)];
X2 = [M(i,2), M(i,4)];
Y2 = [M(i,3), M(i,5)];
axis([-2 2 -2 2]);
hold on;
draw_func(XC, YC, X1, Y1, X2, Y2);
drawnow;
end
end

function draw_func(xc, yc, x1, y1, x2, y2)
plot(xc, yc, 'k-')    
plot(x1, y1, 'r-');
plot(x2, y2, 'b-');
end


end

