function [A ufit cs]= fit_sine(u,f,Fs)

N=length(u);
t=[0:N-1]'*1/Fs;
wt = 2*pi*f*t;

cs=[cos(wt) sin(wt) ones(N,1)];
A=cs\u;
ufit=cs*A;
plot(t,u,'.',t,ufit,t,u-ufit,'--')
legend u_{1-meas} u_{2-meas} u_{1-fit} u_{2-fit} \Deltau_1 \Deltau_2 
drawnow
