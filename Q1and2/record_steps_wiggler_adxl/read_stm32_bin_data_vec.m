function [v] = read_stm32_bin_data_vec(data, fmt)

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

expected_length = parse_stm32_fmt_bin_data_vec([], fmt);

N = expected_length+length(Header)+length(Terminator);

rdata=reshape(cdata,N,[]);

vdata = double(rdata(length(Header)+1:N-length(Terminator),:));

data = parse_stm32_fmt_bin_data_vec(vdata, fmt);

v = data.';
