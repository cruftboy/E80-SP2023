
dists = [10, 30, 50, 70, 90, 110, 130, 150, 170, 190]/1000; % m from speaker
amps = [4.375, 3.75, 3.5, 3.125, 1.875, 1.25, 0, -1.25, -3.75, -8.725]; % VdB

V = 10.^(amps/20);
invdists = 1./dists;

Fit = fitlm(invdists,V,'Intercept',false);
beta = Fit.Coefficients.Estimate;

plot(dists, V)
hold on
r = (10:10:200)/1000;
plot(r, beta*(1./r))
title('Relationship Between Voltage and Distance for 13kHz Signal')
xlabel('Radius [m]')
ylabel('Voltage [V]')
hold off