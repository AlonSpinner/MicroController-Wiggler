
load frf_measured_1

nh=size(H,1);
ss=[];
figure(2),clf
 for q=1:nh
     
     T=reshape(H(q,:),[2 2]);
     
     s=svd(T);
     ss=[ss;s.'];
     [U S V]=svd(T);
     plot(U,'x-')
     axis equal
     shg
     pause(.1)
 end
 
 figure(1), clf
 plot(f1,ss)
 shg