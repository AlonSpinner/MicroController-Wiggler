function load2nucleo_gui(file)
%
% 
if nargin<1 % demo
    [file,d]=uigetfile('*.hex');
    file=['"' d file '"'];
end
cDIR='"C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\';
%download from
%https://my.st.com/content/my_st_com/en/products/development-tools/software-development-tools/stm32-software-development-tools/stm32-programmers/stsw-link004.license=1529342578438.html

sCMD='ST-LINK_CLI.exe"';
sARGs=' -c SWD -P  '; % File.bin or File.hex
sARGs2=' -c SWD -p  ';
sARGs3=' -Rst -Run ';
cmd=[cDIR sCMD sARGs  file sARGs3];
dos(cmd)

