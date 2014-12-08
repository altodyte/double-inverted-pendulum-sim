B = sqrt(l1^2+l2^2-2*l1*l2*cos(beta)); % origin-bar2tip distance
    zeta = asin(-l2*sin(beta)/(B)); % angle between bar1 and system COM
    C = 0.5*sqrt(l1^2+(B/2)^2-B*cos(zeta)); % origin-systemCOM distance
    COM_angle = (sin(zeta)*B)/(4*C)+t1A
    
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