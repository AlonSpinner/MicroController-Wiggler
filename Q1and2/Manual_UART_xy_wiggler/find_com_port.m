function s=find_com_port
%find available com port
% if there's more than one, take the last one
% since COM1 is usally part of the hardwaare (old PCs)
%
%Izhak Bucher May-2015
% for the "Microprocessor based product design" course

 
s=instrfind;
if ~isempty(s)
    fclose(s);
    delete(s);
end


S=instrhwinfo('serial');
 s1=S.SerialPorts ;
  
   s1=s1{end};
  
 
 
s = serial(s1);
s.Terminator='CR/LF';
s.BaudRate=115200;
s.InputBufferSize = 2^20;

fopen(s);