function  [y ]=get_wiggler_sine(s,Ax,Ay,f)


err=0;
Data=zeros(100,4);
 
for q=1:4  % try 4 times max
send_cmd(s,'Ax',Ax); % Ax*sin(2*pi*f*t)
send_cmd(s,'fx',f); % frequency Hz

send_cmd(s,'Ay',Ay); % Ay*sine
send_cmd(s,'fy',f); % frequency Hz

%send_cmd(s,'laser',100); % laser off
pause(1)
flushinput(s) % make sure we have no leftovers in the serial (PC) buffer
%%
pause(3);

%% record
send_d_cmd(s,'flag',1); % start recording
pause(4); % delay
send_d_cmd(s,'flag',2);  % start transmitting data
x=-1;
while (x~=s.BytesAvailable),
    x=s.BytesAvailable;
    S=sprintf('acquired %d bytes ',x);
    title(S),shg
    pause(1),
    set(gcf,'rend','painter')
end

%%
send_cmd(s,'Ax',0); %  zero amplitude
send_cmd(s,'Ay',0); %  zero amplitude
pause(.3);
send_d_cmd(s,'flag',2);
err=0;
% while err==0
try
    v=fread(s, s.BytesAvailable);  % read what is available
    Data=read_stm32_bin_data_vec(v, {'single','single','single','single'});
catch
    err=1;y=0;
    title(sprintf('error, attempt #%d',q)), shg, pause(5)
    disp 'NOTE: there was a problem transferring data via UART'
end

if err==0, break
end
end

y=Data(2:end-1,:);



%%
function send_cmd(s,A,x)
cmd=sprintf('%s=%f',A,x); % command A, number x
fwrite(s,[cmd 13 10]);

function send_d_cmd(s,A,x)
cmd=sprintf('%s=%d',A,x); % command A, number x
fwrite(s,[cmd 13 10]);