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
      y = get_wiggler_sine(s,30,50,3.8);
      plot(y), shg
          set(gcf,'rend','painter')
%%

fclose(s);
delete(s);

%%
