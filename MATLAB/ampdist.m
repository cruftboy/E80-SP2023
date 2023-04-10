ninedists = [50, 60, 70, 80, 90, 100, 120, 140, 160, 180, 200]/1000; % m from speaker
nineamps = [5,4.375, 1.875, 0.625, 0, 0, -0.625, -3.125, -3.75, -5, -5.825]; % VdB

nineV = 10.^(nineamps/20);
nineinvdists = 1./ninedists;

nineFit = fitlm(nineinvdists,nineV,'Intercept',false);
beta = nineFit.Coefficients.Estimate;

plot(ninedists, nineV)
hold on
r = (50:10:200)/1000;
plot(r, beta*(1./r))
title('Relationship Between Voltage and Distance for 9kHz Signal')
xlabel('Radius [m]')
ylabel('Voltage [V]')