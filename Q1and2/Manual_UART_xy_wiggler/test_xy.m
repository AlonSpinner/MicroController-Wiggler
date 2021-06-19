vx=100; 
vy=100;
for pp=1:10
for ii=-100:10:100
    for jj=-100:10:100 
cmd=sprintf('vcx=%f',ii); % move x
            fwrite(s,[cmd 13 10]);
            
 cmd=sprintf('vcy=%f',jj); % move x
            fwrite(s,[cmd 13 10]);
            
            pause(.03)
    end
            
end
end


%%
xi=0;
yi=0;
s=find_com_port;
%%
xi=xi+1;
cmd=sprintf('vcx=%f',xi); % move x
            fwrite(s,[cmd 13 10]);
xi
yi
%%
xi=xi-1;
cmd=sprintf('vcx=%f',xi); % move x
            fwrite(s,[cmd 13 10]);
xi
yi
%%
yi=yi+1;
cmd=sprintf('vcy=%f',yi); % move x
            fwrite(s,[cmd 13 10]);
xi
yi
%%
yi=yi-1;
cmd=sprintf('vcy=%f',yi); % move x
            fwrite(s,[cmd 13 10]);
xi
yi
%%            
            
            
            
            
% cmd=sprintf('vcy=%f',100); % move x
%            fwrite(s,[cmd 13 10]);
%%
s=find_com_port;
 cmd=sprintf('CircleFlag=%f',1); % move x
            fwrite(s,[cmd 13 10]);
            s=find_com_port;
            %%
            s=find_com_port;
 cmd=sprintf('CircleFlag=%f',2); % move x
            fwrite(s,[cmd 13 10]);
%%
             cmd=sprintf('CircleR=%f',1.6); % move x
            fwrite(s,[cmd 13 10]);
            %%
             cmd=sprintf('CircleFrequency=%f',0.1); % move x
            fwrite(s,[cmd 13 10]);
             %%
            fwrite(s,[cmd 13 10]);
                         cmd=sprintf('Ay=%f',1.25); % move x
            fwrite(s,[cmd 13 10]);
            
                       %%
            fwrite(s,[cmd 13 10]);
                         cmd=sprintf('LissaFreq=%f',0.3); % move x
            fwrite(s,[cmd 13 10]);  
            