function [v] = read_stm32_bin_data(data, fmt)

% find 1st packet:
Header = [126 126];
Terminator = [3 3];

cdata = char(data)';
ii = strfind(cdata, char(Header));
cdata(1:ii(1)-1) = []; % cut before 1st full packet

jj = strfind(cdata, char(Terminator));
cdata(jj(end)+2:end)=[]; % cut after end of last full packet
ii = strfind(cdata, char(Header));

if ii(1) ~= 1
    error('inconsistent data\n');
end

expected_length = parse_stm32_fmt_bin_data([], fmt);
% fprintf(1, 'expected lengt = %d\n', expected_length);

n = length(ii);

v = zeros(n,length(fmt));

err_marker=[];
for q=1:n
    
    hind = [ii(q) ii(q)+length(Header)-1];
    h = double(cdata(hind(1):hind(2))); % get header
    
    % get terminator location
    jj = strfind(cdata(hind(1):end), char(Terminator));
    tind = [hind(1)+jj(1)-1 hind(1)+jj(1)+length(Terminator)-2];
    t =  double(cdata(tind(1):tind(2))); % get terminator
    
    
    dataind = [hind(2)+1 tind(1)-1];
    data_packet = double(cdata(dataind(1):dataind(2))); % get packed data
    
    %     disp(double(cdata( hind(1):tind(2))))
    %     disp(h)
    %     disp(t)
    %     disp(data_packet)
    
    % validate package:
    if h(1) == Header(1) && h(2) == Header(2) ... % check header
            && t(1) == Terminator(1) && t(2) == Terminator(2) ... % check terminator
            && expected_length == length(data_packet)
        
        data = parse_stm32_fmt_bin_data(data_packet, fmt);
        v(q,:) = data(:).';
        
    else
        %         fprintf(1,'Terminator=%d %d\n',t(1), t(2));
        %         fprintf(1,'Header=%d %d\n',h(1), h(2));
        err_marker = [err_marker; q]; %#ok
    end
    
    
end
v(err_marker,:) = [];

