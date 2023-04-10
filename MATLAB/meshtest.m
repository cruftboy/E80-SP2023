mesh = [0,1,2];
%Tcube = ones(size(mesh)) * 4.0195;
%Fcube = [2.609, 2.5638, 2.7581, 3.931, 3.7324]

Tsphere = ones(size(mesh)) * 1.4131
Fsphere = [2.0869,1.9501]

plot(mesh, theory);
hold on
plot(mesh, F);

legend('theory', 'unrefined mesh', 'refined mesh')