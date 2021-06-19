function [S,f] = FourierSeriesDFT(s,Fs)
% [S,f] = FourierSeriesDFT(x,Fs)
%
% Compute the Complex Fourier series using the DFT.
%
% Limitations: this routine provides accurate results only when the
% sampling rate is such that there is an integer number of points per cycle
% for every frequency in the signal.
   N=length(s);
  Nn= ceil((N+1)/2);
  f=[0:Nn-1]'*Fs/N;
    S = fft(s);                    % fast way to compute the DFT
   S = S(1:Nn)*2/N;       % take only  positive frequencies
