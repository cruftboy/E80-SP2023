fileData = load('coldtankFullmission1.log','-ascii');

batteryCapacity = fileData(:,1)' + 10;
timeSequenceInSeconds = 0:0.5:(length(batteryCapacity)-1)/2;
timeSequenceInHours = timeSequenceInSeconds/3600;

P = polyfit(timeSequenceInHours,batteryCapacity,1);
P(2) = P(2) + 10;

%% from lecture 2 file
x = [972, 705, 373, 2.9]; % Uncomment and add your own data
y = [0.1741935484 0.1037037037 0.05909090909 0.03279569892]; % Uncomment and add your own data
confLev = 0.95; % The confidence level
N = length(y); % The number of data points
xbar = mean(x);
ybar = mean(y);
Sxx = dot((x-xbar),(x-xbar));
%Sxx = (x-xbar)*transpose(x-xbar);
% beta1 is the estimated best slope of the best-fit line
beta1 = dot((x-xbar),(y-ybar))/Sxx
% beta1 = ((x-xbar)*transpose(y-ybar))/Sxx
% beta0 is the estimated best-fit y-intercept of the best fit line
beta0 = ybar - beta1*xbar
yfit = beta0 + beta1*x;
SSE = dot((y - yfit),(y - yfit)) % Sum of the squared residuals
% SSE = (y - yfit)*transpose(y - yfit) % Sum of the squared residuals
Se = sqrt(SSE/(N-2)) % The Root Mean Square Residual
Sbeta0 = Se*sqrt(1/N + xbar^2/Sxx)
Sbeta1 = Se/sqrt(Sxx)
% tinv defaults to 1-sided test. We need 2-sides, hence:(1-0.5*(1-confLev))
StdT = tinv((1-0.5*(1-confLev)),N-2) % The Student's t factor
lambdaBeta1 = StdT*Sbeta1 % The 1/2 confidence interval on beta1
lambdaBeta0 = StdT*Sbeta0 % The 1/2 confidence interval on beta0
range = max(x) - min(x);
xplot = min(x):range/30:max(x); % Generate array for plotting
yplot = beta0 + beta1*xplot; % Generate array for plotting
Syhat = Se*sqrt(1/N + (xplot - xbar).*(xplot - xbar)/Sxx);
lambdayhat = StdT*Syhat;
Sy = Se*sqrt(1+1/N + (xplot - xbar).*(xplot - xbar)/Sxx);
lambday = StdT*Sy;
figure(1)
plot(x,y,'x', "LineWidth", 2)
hold on
plot(xplot,yplot, "LineWidth", 2)
plot(xplot,yplot+lambday,'--m',xplot,yplot-lambday,'--m', "LineWidth", 2)
xlabel('Independent Variable')
ylabel('Dependent Variable')
if beta1 > 0 % Fix this
    location = 'northwest';
else
    location = 'northeast';
end

xlabel('Turbidity', 'FontSize', 20);
ylabel('Transmitted to Reflected Ratio','FontSize', 20);
title('Calibrated Turbidity vs. IR Ratio','FontSize', 25);

hold off


out = 53+beta1*4
dout1 = out-(52+beta1*4)
dout2 = out-(53+(beta1-lambdaBeta1)*4)

err = sqrt(dout1^2 + dout2^2)

