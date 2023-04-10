d = load("scope_7.csv");

t = d(:, 1);
sig = 20*log10(d(:, 2));
sig = d(:, 2);

plot(t, sig);

k = [1,3,5,7,9];
1.5./(k*pi)


Fs = 1/(t(2)-t(1));

N = length(sig);

h = 1;
[S, f] = fdomain(sig.*h, Fs);

f=f./1e3;

stem(f,abs(S))
title('FFT of 11 kHz Square Wave Data From Oscilloscope', FontSize=20)
xlabel('Frequency [kHz]', FontSize=15)
ylabel('Coefficient Magnitude [V]', FontSize=15)
axis([-5, 150, 0, 0.75])
xticks(0:11:150)

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