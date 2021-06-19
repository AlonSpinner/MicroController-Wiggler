figure(1), clf
set(gcf,'color','w')
axis square
axis off
s=set_vx_vy('init');
 
fs='fontsize';

func1 = @(s1,cmd) set_vx_vy(s,1);
 h1 = uicontrol('style','edit','pos',[100 160 300 20],fs,18)
 set(h1,'Callback',func1,'string','0')
uicontrol('style','text','pos',[100 180 300 40],'string','vc-x',fs,18)

 
 func2 = @(s1,cmd) set_vx_vy(s,2);

 h2 = uicontrol('style','edit','pos',[100 40 300 20],fs,18)
 set(h2,'Callback',func2,'string','0')
uicontrol('style','text','pos',[100 60 300 40],'string','vc-y',fs,18)

 
  

 shg
 