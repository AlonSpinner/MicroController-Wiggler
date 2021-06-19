s=instrfind;
if ~isempty(s)
    fclose(s);
    delete(s);
end


S=instrhwinfo('serial');
s1=S.SerialPorts;

if length(s1)>=1
    s1=s1{end};
else
    error 'no serial ports found'
end

s = serial(s1);
s.Terminator='CR/LF';
s.BaudRate=115200;
s.InputBufferSize = 2^20;

fopen(s);
pause(1)
cmd=sprintf('EN=%d',1);  % reset queue buffer
fwrite(s,[cmd 13 10]);
cmd=sprintf('vcflag=%d',2); % reset buffer
fwrite(s,[cmd 13 10]);

cmd=sprintf('laser=%f',99+1);fwrite(s,[cmd 13 10]); % laser off is pwm=100
 
pause(1)
flushinput(s) % make sure we have no leftovers in the serial (PC) buffer
%%
%Input parameters for square waves
Uinput=inputdlg({'vcy PWM amplitude','vcy PWM frequency','vcx PWM amplitude','vcy PWM frequency'},'',1,{'45','0.25','50','0.25'});

cmd=sprintf('vcyPWMamp=%d',str2num(Uinput{1}));
fwrite(s,[cmd 13 10]);
cmd=sprintf('vcyPWMfreq=%d',str2num(Uinput{2}));
fwrite(s,[cmd 13 10]);
cmd=sprintf('vcxPWMamp=%d',str2num(Uinput{3}));
fwrite(s,[cmd 13 10]);
cmd=sprintf('vcxPWMfreq=%d',str2num(Uinput{4}));
fwrite(s,[cmd 13 10]);



cmd=sprintf('flag=%d',1); % start recording
fwrite(s,[cmd 13 10]);
cmd=sprintf('vcflag=%d',0); % reset buffer
fwrite(s,[cmd 13 10]);
cmd=sprintf('vcflag2=%d',0); % reset buffer
fwrite(s,[cmd 13 10]);
 pause(10); % record time
 
 
cmd=sprintf('flag=%d',2); % start transmitting data
fwrite(s,[cmd 13 10]);
x=-1;
  while (x~=s.BytesAvailable), 
     x=s.BytesAvailable; 
      S=sprintf('acquired %d bytes ',x);
      title(S),shg
     pause(1), 
  end
 
  cmd=sprintf('flag=%d',2); % reset buffer
fwrite(s,[cmd 13 10]);

cmd=sprintf('vcflag2=%d',2); % reset buffer
fwrite(s,[cmd 13 10]);

if 0
 cmd=sprintf('flag=%d',3); % reset buffer
fwrite(s,[cmd 13 10]);
 pause(30);
 end
 cmd=sprintf('vcflag=%d',2); % reset buffer
fwrite(s,[cmd 13 10]);

 v=fread(s, s.BytesAvailable);  % read what is available
Data=read_stm32_bin_data_vec(v, {'single','single','single','single'});

 
%%
plot([Data(:,1)  Data(:,2)  Data(:,3:4)/10],'.')
shg
 set(gcf,'render','painter')
 
%%
fclose(s);
delete(s);

 
%%
shg