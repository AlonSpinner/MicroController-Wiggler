close all
s= find_com_port;
pause(1)
cmd=sprintf('vcx=%f',0); % reset buffer
fwrite(s,[cmd 13 10]);

cmd=sprintf('vcy=%f',0); % reset buffer
fwrite(s,[cmd 13 10]);

cmd=sprintf('laser=%f',99+1);fwrite(s,[cmd 13 10]); % laser off is pwm=100

pause(1)
flushinput(s) % make sure we have no leftovers in the serial (PC) buffer
%%
NP=3;
xg=linspace(-100,100,NP);
yg=linspace(-100,100,NP);
[Xg Yg]=meshgrid(xg,yg);

[m n]=size(Xg);

cmd=sprintf('laser=%f',9+1);fwrite(s,[cmd 13 10]); % laser on
 
ii1=1;
while  ii1<=m
    jj1=1; 
    while jj1<=n
         
        err=0;
     disp([   ii1,jj1])
        while err==0
            cmd=sprintf('vcx=%f',Xg(ii1,jj1)); % move x
            fwrite(s,[cmd 13 10]);
            cmd=sprintf('vcy=%f',Yg(ii1,jj1)); % move y
            fwrite(s,[cmd 13 10]);
            pause(.3);
            
            %% record
            cmd=sprintf('flag=%d',1); % start recording
            fwrite(s,[cmd 13 10]);
            pause(7);
            
            cmd=sprintf('flag=%d',2); % start transmitting data
            fwrite(s,[cmd 13 10]);
            x=-1; 
            while (x~=s.BytesAvailable),
                x=s.BytesAvailable;
                
                S=sprintf('acquired %d bytes ',x);
                title(S),shg
                pause(1),
            end
    %        fprintf('gethered %d points \n\r',x)
            cmd=sprintf('flag=%d',2); % reset buffer
            fwrite(s,[cmd 13 10]);
        %    try
                v=fread(s, s.BytesAvailable);  % read what is available
                Data=read_stm32_bin_data_vec(v, {'single','single','single','single'});
         %   catch
          %      err=1 
           %     title 'error ', shg, pause 
            %end
            
            VX(ii1,jj1) = mean(Data(:,3));
            VY(ii1,jj1) = mean(Data(:,4));
            ADXL_X(ii1,jj1) = mean(Data(:,1));
            ADXL_Y(ii1,jj1) = mean(Data(:,2));
            plot(ADXL_X(ii1,jj1),ADXL_Y(ii1,jj1),'r.','markersize',32),
            title(sprintf(' i=%d, j=%d',ii1,jj1))
            axis equal, hold on, shg
        end % while err=0
        jj1=jj1+1;
    end %% ii1
    ii1=ii1+1;
end

%%
plot(ADXL_X(:),ADXL_Y(:),'b.','markersize',34);
axis equal
xlabel adxl-x,   ylabel adxl-y
hold off
shg

%%
fclose(s);
delete(s);
cmd=sprintf('laser=%f',99+1);fwrite(s,[cmd 13 10]); % laser off


%%
