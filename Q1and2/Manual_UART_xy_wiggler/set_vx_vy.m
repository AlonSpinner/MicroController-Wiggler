function  s=set_vx_vy(s,cmd,h)
% send a command to the UART/serial
% s=set_vx_vy('init') - initialize the port
% set_vx_vy(s,'vx',h)  - sends the command vx to the UART via s  and
% modifying the voltage sent to the Coice-coil #1
%  
% set_vx_vy(s,'vy',h)  - sends the command vx to the UART via s  and
% modifying the voltage sent to the Coice-coil #2

 
%
% (c) Izhak Bucher, June 2019
% Microprocessor based product design

if strcmp(s,'init')
    s=find_com_port;
else  % send a command
       S = get(gco,'string');
       try
          x= str2double(S);
       catch 
           x=0;
       end
       if x<-100, x=-100; end
       if x>100, x=100; end
        if cmd==1; Scmd = sprintf('vcx=%3.3f',x);end
        if cmd==2; Scmd = sprintf('vcy=%3.3f',x);end
               
         fwrite(s, [Scmd 13 10]);
  ht=title(Scmd);  set(ht,'fontsize',22,'color','b')
  
          
end