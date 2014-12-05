%Victoria Preston & Bill Warner - Control of a Double Bar Pendulum
%based on "Victoria Preston - Dynamics - Double Bar Pendulum"

function no_cart
clf;

%% System & Simulation Parameters
% System Parameters
g = 9.81;
m1 = 1;
m2 = 1;
l1 = 1;
l2 = 1;
I1 = 1/3*m1*l1^2;
%I1COM = 1/12*m1*l1^2;
I2 = 1/12*m2*l2^2;
I2COM = 1/12*m2*l2^2;
% Simulation Parameters
time = 0:0.01:20;
% Initial conditions
theta1 = pi;
theta2 = pi+0.01;
theta1dot = 0;
theta2dot = 0;

%% Numeric Simulation
states = [theta1, theta2, theta1dot, theta2dot, 0, 0, 0, 0];
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9);
[T,X] = ode45(@swing, time, states, options);

%% Extract State Variables
x1 = l1*sin(X(:,1));
y1 = -l1*cos(X(:,1));

x1dot = l1/2*X(:,3).*cos(X(:,1));
y1dot = l1/2*X(:,3).*sin(X(:,1));

x2 = x1+l2*sin(X(:,2));
y2 = y1-l2*cos(X(:,2));

x2dot = l1*X(:,3).*cos(X(:,1)) + l2/2*X(:,4).*cos(X(:,2));
y2dot = l1*X(:,3).*sin(X(:,1)) + l2/2*X(:,4).*sin(X(:,2));

%% Animate
stuff = [x1, y1, x2, y2];
animate_func(T, stuff)

% figure;
clf;
hold on;
plot(x1, y1, 'g-')
plot(x2, y2, 'r-')

figure;
hold on;
plot(T,rem(X(:,1),2*pi), 'g-');
plot(T,rem(X(:,2),2*pi), 'r-');

figure;
hold on;
plot(T,X(:,1), 'g-')
plot(T, X(:,2), 'r-')
legend('Top Bar', 'Bottom Bar')
title('Angular Displacement over time')
xlabel('Time')
ylabel('Radians')

%% Simulation Functions
function states = swing(T,Z)
    t1 = Z(1); % Angle of closer bar
    t2 = Z(2); % Angle of farther bar
    td1 = Z(3);
    td2 = Z(4);
    
    M = [I1 0 -l1*cos(t1) l1*sin(t1) 0 0; ...
        0 I2 -l2/2*cos(t2) l2/2*sin(t2) 0 0; ...
        -m2*l1*cos(t1) -m2*l2/2*cos(t2) -1 0 0 0; ... % control here?
        m2*l1*sin(t1) m2*l2/2*sin(t2) 0 -1 0 0; ...
        -m1*l1/2*cos(t1) 0 1 0 1 0; ...
        0 -m1*l1/2*sin(t1) 0 1 0 1]
    b = [(-l1/2*m1*g*sin(t1)); ...
        0; ...
        (-m1*l1*td1^2*sin(t1) -  m2*l2/2*td2^2*sin(t2)); ...
        (-m2*g - m2*l1*td1^2*cos(t1) - m2*l2/2*td2^2*cos(t2)); ...
        (-m1*l1/2*td1^2*sin(t1)); ...
        (m1*g + m1*l1/2*td1^2*cos(t1))];
    
    solver = M\b;
    solver = solver + [control(Z); 0; 0; 0; 0; 0];
    % states = [positions; velocities; accelerations; reaction forces];
    states = [td1; td2; solver];
end

function alpha = control(Z)
    t1 = Z(1); % Angle of first bar
    t1A = rem(t1,2*pi); % 0 to 2pi angle
    t2 = Z(2); % Angle of second bar
    t2A = rem(t2,2*pi); % 0 to 2pi angle
%     td1 = Z(3);
%     td2 = Z(4);
    p = 0.01;
    beta = pi + t1A - t2A; % Angle between bars
    C = 0.5*sqrt(l1^2+l2^2-2*l1*l2*cos(beta));
    zeta = asin(-l2*sin(beta)/(2*C));
    OC = sqrt((l1/2)^2+(C/2)^2-2*(l1/2)*(C/2)*cos(zeta));
    COM_angle = -l2*sin(beta)/(4*OC);
    error = pi-t1A;
%     error = pi-COM_angle;
    torque = p*error;
    % Converty to angular acceleration for simulation
    r = sqrt(l1^2 + (l2/2)^2 - 2*l1*(l2/2)*cos(t1A+t2A)); % radius to second bar
    I_system = I2COM + m2*r^2; % Unrotated Moment of Inertia about origin
    alpha = torque/I_system;
end

function alpha2 = control2(Z)
    t1 = Z(1); % Angle of first bar
    t1A = rem(t1,2*pi); % 0 to 2pi angle
    t2 = Z(2); % Angle of second bar
    t2A = rem(t2,2*pi); % 0 to 2pi angle
    td1 = Z(3);
    td2 = Z(4);
    p = -10;
    torque = p*(pi-t2A);
    % Converty to angular acceleration for simulation
    I_system = I2; % Unrotated Moment of Inertia about origin
    alpha2 = torque/I_system;
end

%% Animation Functions
function animate_func(T,M)   
    for i=1:length(T)
        clf;
        X1 = [0, M(i,1)];
        Y1 = [0, M(i,2)];
        X2 = [M(i,1), M(i,3)];
        Y2 = [M(i,2), M(i,4)];
        axis([-2 2 -2 2]);
        axis square
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

%% VALIDATION FIGURES (preserved for posterity)

% figure;
% hold on;
% plot(T,X(:,3), 'g-')
% plot(T, X(:,4), 'r-')
% legend('Top Bar', 'Bottom Bar')
% title('Angular Velocity over time')
% xlabel('Time')
% ylabel('Radians/second')
% 
% for j = 1:length(T)-1
% theta1ddot(j) = (X(j+1,3)-X(j,3))/(T(j+1)-T(j));
% theta2ddot(j) = (X(j+1,4)-X(j,4))/(T(j+1)-T(j));
% t(j) = T(j);
% end
% 
% figure;
% hold on;
% plot(t,theta1ddot, 'g-')
% plot(t, theta2ddot, 'r-')
% legend('Top Bar', 'Bottom Bar')
% title('Angular Acceleration over time')
% xlabel('Time')
% ylabel('Radians per second squared')
% 
% kinetic = 0.5*I1COM*(X(:,3).^2) + ...
%     0.5*I2COM*X(:,4).^2 + 0.5*m1*(x1dot.^2 + y1dot.^2) + ...
%     0.5*m2*(x2dot.^2 + y2dot.^2);
% potential = m1*g*(-l1/2*cos(X(:,1))) + ...
%     m2*g*(-l1*cos(X(:,1))-l2/2*cos(X(:,2)));
% total = kinetic+potential;
% 
% figure;
% hold on;
% plot(T,kinetic, 'g-')
% plot(T, potential, 'r-')
% plot(T, total, 'k-')
% legend('Kinetic', 'Potential', 'Total')
% title('Energy over time')
% xlabel('Time')
% ylabel('Energy')
% 
% figure;
% hold on;
% plot(T, X(:,5), 'b-')
% plot(T, X(:,6), 'm-')
% plot(T, X(:,7), 'k-')
% plot(T, X(:,8), 'r-')
% legend('Ax', 'Ay', 'Ox', 'Oy')
% xlabel('Time')
% ylabel('Force, N')
