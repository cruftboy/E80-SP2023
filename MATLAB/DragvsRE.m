A = pi*(25/1000)^2; % frontal area, m2
l = 50/1000; % characteristic length (diameter), m
V = [5,15,25,35,45]; % air speeds, m/s
Fd1 = [0.02362, 0.21163, 0.58734, 1.1508, 1.9019]; % drag forces, nose 1
Fd2 = [0.016037, 0.14345, 0.39794, 0.77957, 1.2880]; % nose 2
Fd3 = [0.011055, 0.0985, 0.27298, 0.53454, 0.88344]; % nose 3
Fdld = [0.0072646, 0.064409, 0.17842, 0.34929, 0.57738] % low drag


rho = 1.225; % density of air, kg/m3
nu = 1.46e-5; % nu of air

%Fd2 = 0.5*rho*V.^2*0.82*A % find theoretical values

Re = l*V/nu % reynolds number
Cd1 = 2*Fd1 ./ (rho*A*V.^2) % drag coeff
Cd2 = 2*Fd2 ./ (rho*A*V.^2) % drag coeff
Cd3 = 2*Fd3 ./ (rho*A*V.^2) % drag coeff
Cdld = 2*Fdld ./ (rho*A*V.^2) % drag coeff



figure(1)

plot(Re, Fd1)
hold on
plot(Re, Fd2)
plot(Re, Fd3)
plot(Re, Fdld)
title("Drag vs Reynold's Number")
legend('Nose 1', 'Nose 2', 'Nose 3', 'Low Drag Body', 'Location', 'southeast')
xlabel("Reynold's Number")
ylabel("Drag Force [N]")

figure(2)


plot(Re, Cd1)
hold on
plot(Re, Cd2)
plot(Re, Cd3)
plot(Re, Cdld)
title("Drag Coefficient vs Reynold's Number")
legend('Nose 1', 'Nose 2', 'Nose 3', 'Low Drag Body', 'Location', 'southeast')
xlabel("Reynold's Number")
ylabel("Drag Coefficient")