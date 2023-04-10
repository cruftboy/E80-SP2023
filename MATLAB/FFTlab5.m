clear

cycles = 50;
Fs = 1.4286e+06; %Hz
A = 1.5;
Ts = 1/Fs; %s

fsig0 = 11e3;
Tsig0 = 1/fsig0;

fsig = 11e3;
Tsig = 1/fsig;
t = 0:Ts:Tsig0*cycles;

sig = A*square(2*pi*fsig*t);


plot(t, sig);
figure(2)

N = length(sig);

h = 1;
[S, f] = fdomain(sig.*h', Fs);

stem(f,abs(S))
hold on
xlim([0 100e3])
hold off

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