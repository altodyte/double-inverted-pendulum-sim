%Victoria Preston - Dynamics - Double Bar Pendulum

function double_bar_pendulum
clf;

%Parameters
g = 9.81;
m1 = 1;
m2 = 1;
l1 = 1;
l2 = 1;
I1 = 1/3;
I1COM = 1/12*m1*l1^2;
I2 = 1/12;
I2COM = 1/12*m2*l2^2;

%Opening
theta1 = pi;
theta2 = pi+0.1;
theta1dot = 0;
theta2dot = 0;

states = [theta1, theta2, theta1dot, theta2dot, 0, 0, 0, 0];
time = 0:0.01:1.4;
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9);

[T,X] = ode45(@swing, time, states, options);
x1 = l1*sin(X(:,1));
y1 = -l1*cos(X(:,1));

x1dot = l1/2*X(:,3).*cos(X(:,1));
y1dot = l1/2*X(:,3).*sin(X(:,1));

x2 = x1+l2*sin(X(:,2));
y2 = y1-l2*cos(X(:,2));

x2dot = l1*X(:,3).*cos(X(:,1)) + l2/2*X(:,4).*cos(X(:,2));
y2dot = l1*X(:,3).*sin(X(:,1)) + l2/2*X(:,4).*sin(X(:,2));

stuff = [x1, y1, x2, y2];
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
% kinetic = 0.5*I1COM*(X(:,3).^2) + 0.5*I2COM*X(:,4).^2 + 0.5*m1*(x1dot.^2 + y1dot.^2) + 0.5*m2*(x2dot.^2 + y2dot.^2);
% potential = m1*g*(-l1/2*cos(X(:,1))) + m2*g*(-l1*cos(X(:,1))-l2/2*cos(X(:,2)));
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

function states = swing(T,Z)
    t1 = Z(1);
    t2 = Z(2);
    td1 = Z(3);
    td2 = Z(4);
    
    M = [I1 0 -l1*cos(t1) l1*sin(t1) 0 0; 0 I2 -l2/2*cos(t2) l2/2*sin(t2) 0 0; -m2*l1*cos(t1) -m2*l2/2*cos(t2) -1 0 0 0; m2*l1*sin(t1) m2*l2/2*sin(t2) 0 -1 0 0; -m1*l1/2*cos(t1) 0 1 0 1 0; 0 -m1*l1/2*sin(t1) 0 1 0 1];
    b = [(-l1/2*m1*g*sin(t1)); 0; (-m1*l1*td1^2*sin(t1) -  m2*l2/2*td2^2*sin(t2)); (-m2*g - m2*l1*td1^2*cos(t1) - m2*l2/2*td2^2*cos(t2)); (-m1*l1/2*td1^2*sin(t1)); (m1*g + m1*l1/2*td1^2*cos(t1))];
    
    solver = M\b;
    states = [td1; td2; solver];

end

function animate_func(T,M)
    
for i=1:length(T)
clf;
X1 = [0, M(i,1)];
Y1 = [0, M(i,2)];
X2 = [M(i,1), M(i,3)];
Y2 = [M(i,2), M(i,4)];
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

