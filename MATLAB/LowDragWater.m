A = pi*(25/1000)^2; % frontal area, m2
l = 50/1000; % characteristic length (diameter), m
V = [0.09634094278, 0.2890228283, 0.4817047139, 0.6743865995, 0.867068485]; % water speeds, m/s

Fdld = [0.002351, 0.020174, 0.055522, 0.10838, 0.17872] % low drag


rho = 997; % density of water, kg/m3
nu = 1.11e-6; % nu of water

%Fd2 = 0.5*rho*V.^2*0.82*A % find theoretical values

Re = l*V/nu % reynolds number
Cdld = 2*Fdld ./ (rho*A*V.^2) % drag coeff



figure(1)

plot(Re, Fdld)
title("Low Drag Body, Drag vs Reynold's Number in Water")
xlabel("Reynold's Number")
ylabel("Drag Force [N]")

figure(2)

plot(Re, Cdld)
title("Low Drag Body, Drag Coefficient vs Reynold's Number in Water")
xlabel("Reynold's Number")
ylabel("Drag Coefficient")