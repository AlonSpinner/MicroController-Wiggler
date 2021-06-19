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
flushinput(s)


pause(1)
cmd=sprintf('EN=%d',1);  % reset queue buffer
fwrite(s,[cmd 13 10]);
pause(1)
flushinput(s) % make sure we have no leftovers in the serial (PC) buffer
%%
 cmd=sprintf('flag=%d',1); % start recording
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
     if x>10000, break, end
  end
 
  cmd=sprintf('flag=%d',0); % reset buffer
fwrite(s,[cmd 13 10]);
if 01
 cmd=sprintf('flag=%d',3); % reset buffer
fwrite(s,[cmd 13 10]);
 pause(3);
 end

 v=fread(s, s.BytesAvailable);  % read what is available
Data=read_stm32_bin_data_vec(v, {'int16','int16'});

 
%%
plot([Data(:,1)  Data(:,2) ],'.')
shg
 
 
%%
fclose(s);
delete(s);

 
%%
shg