%% Lab 5 Interface

samplingFreq = 100E3; % Hz [100E3 max]
numSamples = 1000; % the higher this is the longer sampling will take

bytesPerSample = 2; % DO NOT CHANGE
micSignal = zeros(numSamples,1); % DO NOT CHANGE

% close and delete serial ports in case desired port is still open
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

% Modify first argument of serial to match Teensy port under Tools tab of Arduino IDE.  Second to match baud rate.
% Note that the timeout is set to 60 to accommodate long sampling times.
s = serial('/dev/cu.usbmodem107867201','BaudRate',115200); 
set(s,{'InputBufferSize','OutputBufferSize'},{numSamples*bytesPerSample,4});
s.Timeout = 60; 

fopen(s);
pause(2);
fwrite(s,[numSamples,samplingFreq/2],'uint16');
dat = fread(s,numSamples,'uint16');
fclose(s);

% Some convenience code to begin converting data for you.
micSignal = dat.*(3.3/1023); % convert from Teensy Units to Volts
samplingPeriod = 1/samplingFreq; % s
totalTime = numSamples*samplingPeriod; % s
t = linspace(0,totalTime,numSamples)'; % time vector of signal

figure(1)
plot(t, micSignal)
xlabel('Time [s]')
ylabel('Mic Voltage [V]')

title('Teensy Mic Recording at 100 kHz')


figure(2)
[S, f] = fdomain(micSignal, samplingFreq);

stem(f,abs(S))
xlabel('Frequency [Hz]')
ylabel('Fourier Coefficient Magnitude')

title('FFT of Teensy Mic Recording at 100 kHz')
 
function [X,f]=fdomain(x,Fs)
    % FDOMAIN Function to compute the Fourier coefficients from vector x
    %   and the corresponding frequencies (two-sided)
    % usage:
    %   [X,f]=fdomain(x,Fs)
    %         x=vector of time domain samples
    %         Fs=sampling rate (in Hz)
    %         X=vector of complex Fourier coefficients
    %         f=vector of corresponding frequencies (two-sided)
    
    N=length(x);
    
    if mod(N,2)==0
        k=-N/2:N/2-1; % N even
    else
        k=-(N-1)/2:(N-1)/2; % N odd
    end
    
    T0=N/Fs;    % Duration of signal
    f=k/T0;     % wavenumbers (k) divided by T0 = frequencies
    X=fft(x)/N; % Matlab's FFT uses a different convention without the 1/N so we put it in here.
    X=fftshift(X);
end