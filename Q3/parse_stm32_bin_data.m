function [v] = parse_stm32_bin_data(data)

% find 1st packet:
Header = [126 126];
Terminator = [3 3];

cdata = char(data)';
ii = strfind(cdata, char(Header));
cdata(1:ii(1)-1) = []; % cut before 1st full packet

jj = strfind(cdata, char(Terminator));
cdata(jj(end)+2:end)=[]; % cut after end of last full packet
ii = strfind(cdata, char(Header));

n = length(ii);

v = zeros(n,2);

err_marker=[];
for q=1:n
    
%     disp(double(cdata( (ii(q):ii(q)+11))))
    
    h = cdata(ii(q):ii(q)+1);
    n1 = cdata(ii(q)+2:ii(q)+5);
    n2 = cdata(ii(q)+6:ii(q)+9);
    t =  cdata(ii(q)+10:ii(q)+11);
    
    % validate package:
    if h(1) == Header(1) && h(2) == Header(2) ... % check header
            && t(1) == Terminator(1) && t(2) == Terminator(2) % check terminator
        
        v(q,1) = bytes2single(double(n1));
        v(q,2) = bytes2uint32(double(n2));
        
    else
%         fprintf(1,'Terminator=%d %d\n',t(1), t(2));
%         fprintf(1,'Header=%d %d\n',h(1), h(2));
        err_marker = [err_marker; q]; %#ok
    end
    
    
end
v(err_marker,:) = [];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper functions
%

function val = bytes2single(d)

s = bitshift(bitand(d(4),hex2dec('80')),-7); %sign bit
m = d(1) + bitshift(d(2),8)+bitshift(bitand(d(3),hex2dec('7f')),16);% Significant
x = bitshift(bitand(d(4),hex2dec('7f')),1)+bitshift(d(3),-7); % Exponent
val = (-1)^s*(1+m*2^-23)*2^(x-127);
end

function val = bytes2uint32(d)

val = d(1) + bitshift(d(2),8)+bitshift(d(3),16)+bitshift(d(4),24);
end