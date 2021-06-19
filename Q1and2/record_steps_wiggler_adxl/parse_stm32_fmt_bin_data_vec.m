function data = parse_stm32_fmt_bin_data_vec(packed_data, fmt)
%
% Packet must be complete and woth correct length, no erorr handling here
% if data_packet is empty, returns the expected length of packet
%
% Ran, 3/2015
% double conversion fixed 10/5/2015
%

data_packet = packed_data;
nf = length(fmt);
data = zeros(nf,size(packed_data,2));
len = 0;

for q=1:nf
    switch fmt{q}
        case 'double'
            len = len+8;
            
            if ~isempty(packed_data)
                d = data_packet(1:8,:);
                data_packet(1:8,:)=[];
                
                s = bitshift(bitand(d(8,:),hex2dec('80')),-7); %sign bit
                
                m = d(1) + bitshift(d(2,:),8)+bitshift(d(3,:),16)+... % 52 bits of Significant
                    bitshift(d(4,:),24)+bitshift(d(5,:),32)+bitshift(d(6,:),40)+...
                    bitshift(bitand(d(7,:),hex2dec('0f')),48);
                
                x = bitshift(bitand(d(8,:),hex2dec('7f')),4)+bitshift(d(7,:),-4); % 11 bits of Exponent
                val = (-1).^s.*(1+m*2^-52).*2.^(x-1023);
            end
            
        case 'single'
            len = len+4;
            
            if ~isempty(packed_data)
                d = data_packet(1:4,:);
                data_packet(1:4,:)=[];
                
                s = bitshift(bitand(d(4,:),hex2dec('80')),-7); %sign bit
                m = d(1) + bitshift(d(2,:),8)+bitshift(bitand(d(3,:),hex2dec('7f')),16);% Significant
                x = bitshift(bitand(d(4,:),hex2dec('7f')),1)+bitshift(d(3,:),-7); % Exponent
                val = (-1).^s.*(1+m*2^-23).*2.^(x-127);
            end
        case 'int8'
            len = len+1;
            
            if ~isempty(packed_data)
                d = data_packet(1,:);
                data_packet(1,:)=[];
                
                s = bitshift(bitand(d,hex2dec('80')),-7); %sign bit
                
                val = d;
                val(s~=0) = val(s~=0)-256;

            end
            
        case 'uint8'
            len = len+1;
            
            if ~isempty(packed_data)
                d = data_packet(1,:);
                data_packet(1,:)=[];
                val = d(1,:);
            end
        case 'int16'
            len = len+2;
            
            if ~isempty(packed_data)
                d = data_packet(1:2,:);
                data_packet(1:2,:)=[];
                
                s = bitshift(bitand(d(2,:),hex2dec('80')),-7); %sign bit
                val = d(1,:) + bitshift(d(2,:),8);
                
                val(s==1) = val(s==1)-2^16;
                
            end
            
        case 'uint16'
            len = len+2;
            
            if ~isempty(packed_data)
                d = data_packet(1:2,:);
                data_packet(1:2,:)=[];
                val = d(1,:) + bitshift(d(2,:),8);
            end
            
        case 'int32'
            len = len+4;
            
            if ~isempty(packed_data)
                d = data_packet(1:4,:);
                data_packet(1:4,:)=[];
                
                s = bitshift(bitand(d(4,:),hex2dec('80')),-7); %sign bit
                
                val = d(1,:) + bitshift(d(2,:),8)+bitshift(d(3,:),16)+bitshift(d(4,:),24);
                
                val(s==1) = val(s==1)-2^32;
            end
            
        case 'uint32'
            len = len+4;
            
            if ~isempty(packed_data)
                d = data_packet(1:4,:);
                data_packet(1:4,:)=[];
                val = d(1,:) + bitshift(d(2,:),8)+bitshift(d(3,:),16)+bitshift(d(4,:),24);
            end
        otherwise
            error('Wrong data format %s\n', fmt{q});
    end
    
    if ~isempty(packed_data)
        data(q,:) = val;
    else
        data = len;
    end
end
