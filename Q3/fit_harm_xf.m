function xf=fit_harm_xf(Au1,Au2,Ay1,Ay2)
%
% compute a 2x2 FRF at a single frequency given the amplitudes of the
% cosine and sine waves of input


   Cu1 = Au1(1,:)-1i*Au1(2,:);
   Cu2 = Au2(1,:)-1i*Au2(2,:);
   
   Cy1 = Ay1(1,:)-1i*Ay1(2,:);
   Cy2 = Ay2(1,:)-1i*Ay2(2,:);
   
   % Cy1 = H*Cu1
   % Cy2 = H*Cu2
   
   xf = [Cu1 ;  Cu2]\[Cy1;  Cy2];
   
   
   
   