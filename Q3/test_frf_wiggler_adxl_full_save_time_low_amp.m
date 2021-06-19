close all
s= find_com_port;
pause(1)
cmd=sprintf('Ax=%f',0); % reset VCx=0
fwrite(s,[cmd 13 10]);

cmd=sprintf('Ay=%f',0); % reset VCx=0
fwrite(s,[cmd 13 10]);

cmd=sprintf('laser=%f',99+1);fwrite(s,[cmd 13 10]); % laser off is pwm=100

pause(1)
flushinput(s) % make sure we have no leftovers in the serial (PC) buffer
%%
Fs=500*2;

f1 = linspace(1,12,120);
%f1=fliplr(f1);
%f1 = linspace(3.65,3.9,20);

%f1=[3 5.5];
p=1;
for f=f1;
    figure(1)
    %  set forces #1
    A1=14; A2=10;
    y = get_wiggler_sine(s,A1,A2,f);
    u=y(2:end-1,3:4);
    y=y(2:end-1,1:2);
    subplot(2,1,1)
    Au1=fit_sine(u, f,Fs);
    subplot(2,1,2)
    Ay1=fit_sine(y, f,Fs);
    shg,
    set(gcf,'rend','painter')
       U1{p} = u; Y1{p}=y;
    %  set forces #2
    A1=10; A2=-14;
      y = get_wiggler_sine(s,A1,A2,f);
         u=y(2:end-1,3:4);
         y=y(2:end-1,1:2);
         U2{p} = u; Y2{p}=y;
    
         
    subplot(2,1,1)
      Au2=fit_sine(u, f,Fs);
    subplot(2,1,2)
      Ay2=fit_sine(y, f,Fs);
    shg,
      set(gcf,'rend','painter')
    tmp = fit_harm_xf(Au1,Au2,Ay1,Ay2);
    H(p,:) = tmp(:).';
  
    if p>1
        figure(2)
        plot(f1(1:p),abs(H(1:p,:)),'.-');
        set(gcf,'rend','painter')
    end
    p=p+1;
    drawnow
end
%%

figure(2), clf
nh=size(H,1);
plot(f1(1:nh),abs(H),'.-','markersize',16)
set(gca,'fontsize',16), xlabel 'freq Hz', set(gcf,'color','w')

Fs=1000;
save wiggler_frf_low_amp
%%
fclose(s);
delete(s);

%%
