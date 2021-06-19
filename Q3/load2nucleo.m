function load2nucleo(file)
%
% 
if nargin<1 % demo
    d='C:\Users\user\Dropbox (Technion Dropbox)\courses\Microprocessor_product_design\Spring_2018\lessons\Lesson_12\Final_2018\examples\home_demos\F446_recorder_fast_stm32f4\';
    file='F446_recorder_fast.hex';
    file=[d file];
end
cDIR='"C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\';
sCMD='ST-LINK_CLI.exe"';
sARGs=' -c SWD -P '; % File.bin
sARGs2=' -c SWD -p ';
sARGs3=' -Rst -Run';
cmd=[cDIR '\' sCMD sARGs2 sARGs3 file];
dos(cmd)

