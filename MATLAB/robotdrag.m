A = 0.00164; % frontal area, m2
l = 0.0931; % characteristic length (diameter), m
Va = [0.214 3.2434 4.7428 6.3187 7.9558,11.0464,14.0452]; % air speeds, m/s
Vw = [0.004123392351 0.06249444276 0.09138516468 0.121749903 0.1532938545, 0.5, 1]; %water speed, m/s

Fa = [0 0.0784532 0.1765197 0.55897905 0.97085835,1.6082906,2.5105024]; % real
Fw = [8.0661e-5, 0.010546, 0.031373, 0.054116, 0.0837, 0.76102, 2.7433]


rhow = 997; % density of water, kg/m3
nuw = 1.11e-6; % nu of water

rhoa = 1.225; % density of air, kg/m3
nua = 1.46e-5; % nu of air

%Fd2 = 0.5*rho*V.^2*0.82*A % find theoretical values

Rea = l*Va/nua % reynolds number air
Cda = 2*Fa ./ (rhoa*A*Va.^2) % drag coeff air

Rew = l*Vw/nuw % reynolds number water
Cdw = 2*Fw ./ (rhow*A*Vw.^2) % drag coeff water



figure(1)

plot(Rea, Fa)
hold on
plot(Rew, Fw)
title("E80 Robot, Simulated and Real Drag", FontSize=20)
xlabel("Reynold's Number", FontSize=15)
ylabel("Drag Force [N]", FontSize=15)
legend('Real', 'Simulated', 'Location', 'southeast', FontSize=12)

figure(2)

plot(Rea, Cda)
hold on
plot(Rew, Cdw)
title("E80 Robot, Simulated and Real Drag Coefficient", FontSize=20)
xlabel("Reynold's Number", FontSize=15)
legend('Real', 'Simulated', 'Location', 'southeast', FontSize=12)
ylabel("Drag Coefficient", FontSize=15)