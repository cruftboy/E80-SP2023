A = pi*(25/1000)^2; % frontal area, m2
l = 50/1000; % characteristic length (diameter), m
V = [5,15,25,35,45]; % sim air speeds, m/s

Fd1 = [0.02362, 0.21163, 0.58734, 1.1508, 1.9019]; % drag forces, nose 1
Fd2 = [0.016037, 0.14345, 0.39794, 0.77957, 1.2880]; % nose 2
Fd3 = [0.011055, 0.0985, 0.27298, 0.53454, 0.88344]; % nose 3

V1R = [3.2281 4.8346 6.3034 7.9252 9.4399 10.924 12.5611 13.9993]; % air speeds, m/s
F1R = [0.1176786 0.1372917 0.42168165 0.89239605 1.5298218 2.06918205 1.9416969 2.55950955]; % drag forces, N

V2R = [3.2587 4.8499 6.4411 7.9558 9.2869 11.0158 12.4234 14.1982]; % air speeds, m/s
F2R = [0.06864655 0.1176798 0.14709975 1.36312435 1.3533177 1.4121576 1.0198916 1.2944778]; % drag forces, N

V3R = [3.3199 4.8652 6.2575 7.864 9.547 11.1535 12.5458 14.2441]; % air speeds, m/s
F3R = [0.0588393 0.1176786 0.1569048 0.7060716 0.85316985 0.65703885 0.24516375 0.55897335]; % drag forces, N



rho = 1.225; % density of air, kg/m3
nu = 1.46e-5; % nu of air

%Fd2 = 0.5*rho*V.^2*0.82*A % find theoretical values

Re = l*V/nu; % reynolds number
Cd1 = 2*Fd1 ./ (rho*A*V.^2); % drag coeff
Cd2 = 2*Fd2 ./ (rho*A*V.^2); % drag coeff
Cd3 = 2*Fd3 ./ (rho*A*V.^2); % drag coeff

ReR1 = l*V1R/nu;
ReR2 = l*V2R/nu;
ReR3 = l*V3R/nu;

Cd1R = 2*F1R ./ (rho*A*V1R.^2); % drag coeff
Cd2R = 2*F2R ./ (rho*A*V2R.^2); % drag coeff
Cd3R = 2*F3R ./ (rho*A*V3R.^2); % drag coeff

clf

figure(1)

plot(ReR1, F1R, 'r')
hold on
plot(Re, Fd1, 'r--')

plot(ReR2, F2R, 'g')
plot(Re, Fd2, 'g--')

plot(ReR3, F3R, 'b')
plot(Re, Fd3, 'b--')

title("Drag vs Reynold's Number", 'FontSize', 20)
legend('Nose 1 Real', 'Nose 1 Simulated','Nose 2 Real', 'Nose 2 Simulated','Nose 3 Real', 'Nose 3 Simulated', 'Location', 'northeast', 'FontSize', 12)
xlabel("Reynold's Number", 'FontSize', 15)
ylabel("Drag Force [N]", 'FontSize', 15)



figure(2)

plot(ReR1, Cd1R, 'r')
hold on
plot(Re, Cd1, 'r--')

plot(ReR2, Cd2R, 'g')
plot(Re, Cd2, 'g--')

plot(ReR3, Cd3R, 'b')
plot(Re, Cd3, 'b--')


title("Drag Coefficient vs Reynold's Number", FontSize=20)
legend('Nose 1 Real','Nose 1 Simulated', 'Nose 2 Real', 'Nose 2 Simulated', 'Nose 3 Real', 'Nose 3 Simulated', 'Location', 'northeastg', FontSize=12)
xlabel("Reynold's Number", FontSize=15)
ylabel("Drag Coefficient", FontSize=15)