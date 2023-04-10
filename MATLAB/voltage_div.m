Vin = 0.5; %1 Vpp, 0.5 Vzp
w = f*2*pi; 

z1 = 1000;
z2 = 2000;

Vout = Vin*(z2./(z1+z2));

Vrms = abs(Vout)/sqrt(2);