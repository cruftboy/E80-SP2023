% logreader.m
% Use this script to read data from your micro SD card

clear;
%clf;

filenum = '033'; % file number for the data you want to read
infofile = strcat('INF', filenum, '.TXT');
datafile = strcat('LOG', filenum, '.BIN');

%% map from datatype to length in bytes
dataSizes.('float') = 4;
dataSizes.('ulong') = 4;
dataSizes.('int') = 4;
dataSizes.('int32') = 4;
dataSizes.('uint8') = 1;
dataSizes.('uint16') = 2;
dataSizes.('char') = 1;
dataSizes.('bool') = 1;

%% read from info file to get log file structure
fileID = fopen(infofile);
items = textscan(fileID,'%s','Delimiter',',','EndOfLine','\r\n');
fclose(fileID);
[ncols,~] = size(items{1});
ncols = ncols/2;
varNames = items{1}(1:ncols)';
varTypes = items{1}(ncols+1:end)';
varLengths = zeros(size(varTypes));
colLength = 256;
for i = 1:numel(varTypes)
    varLengths(i) = dataSizes.(varTypes{i});
end
R = cell(1,numel(varNames));

%% read column-by-column from datafile
fid = fopen(datafile,'rb');
for i=1:numel(varTypes)
    %# seek to the first field of the first record
    fseek(fid, sum(varLengths(1:i-1)), 'bof');
    
    %# % read column with specified format, skipping required number of bytes
    R{i} = fread(fid, Inf, ['*' varTypes{i}], colLength-varLengths(i));
    eval(strcat(varNames{i},'=','R{',num2str(i),'};'));
end
fclose(fid);

%% Process your data here

confLev = 0.95;

z_bar = mean(accelZ);
x_bar = mean(accelX);
y_bar = mean(accelY);
S_z = std(accelZ);
N_z = length(accelZ);
ESE_z = S_z/sqrt(N_z);

stdT = tinv((1-0.5*(1-confLev)), N_z-1);
lambda = stdT*ESE_z;

accelX = accelX/100;
accelY = accelY/100;
accelZ = -accelZ/100;
motorA = motorA/255 + 8;
motorB = motorB/255 + 8;
motorC = motorC/255 + 8;

accelX = accelX(340:785);
accelY = accelY(340:785);
accelZ = accelZ(340:785);
motorA = motorA(340:785);
motorB = motorB(340:785);
motorC = motorC(340:785);

accelX = movmean(accelX, 3);
accelY = movmean(accelY, 3);
accelZ = movmean(accelZ, 3);

vZ = cumtrapz(accelZ+9.8);
vX = cumtrapz(accelX);
vY = cumtrapz(accelY);

pX = cumtrapz(vX);
pY = cumtrapz(vY);
pZ = cumtrapz(vZ);

t = 0:1:length(accelX)-1;
t = t/10;


plot(t, pX, '-', "LineWidth", 2);
hold on
plot(t, pY, '--', "LineWidth", 2);
plot(t, pZ, '-.', "LineWidth", 2);
title('Position vs Time', 'FontSize', 20);
xlabel('Time [s]', 'FontSize', 15);
ylabel('Position [m]', 'FontSize', 15);
legend({'X Position','Y Position', 'Z Position'},'Location','northwest', 'FontSize', 15);

ax = gca;
ax.FontSize = 13;
xticks(0:10:length(vX)-1);
hold off;



plot(t, accelX, '-', "LineWidth", 2);
hold on
plot(t, accelY, '-', "LineWidth", 2);
plot(t, accelZ, '-', "LineWidth", 2);
title('Acceleration vs Time', 'FontSize', 20);
xlabel('Time [s]', 'FontSize', 15) 
ylabel('Acceleration [m/s^2]', 'FontSize', 15);
legend({'X Acceleration','Y Acceleration', 'Z Acceleration'},'Location','northeast', 'FontSize', 15);

ax = gca;
ax.FontSize = 13;

hold off;



plot(t,sqrt(accelX.^2+accelY.^2+accelZ.^2), '-', "LineWidth", 2);
hold on
plot(t, motorC, "r:", "LineWidth", 2);

plot(t, motorA, "k-.", "LineWidth", 2);

title('Acceleration and Motor Activation vs Time', 'FontSize', 20);
xlabel('Time [s]', 'FontSize', 15) 
ylabel({'Acceleration [m/s^2]';'Motor Activation'}, 'FontSize', 15);
legend({'Total Acceleration', 'Vertical Motor', 'Horizontal Motors'},'Location','northeast', 'FontSize', 15);

ax = gca;
ax.FontSize = 13;

xticks(0:5:length(accelX)-1);

%}

