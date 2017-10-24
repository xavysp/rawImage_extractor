function [nir,rgbn]=open_raw(file_name, is_rgbn)
    % camera configuration
    width = 1280;
    height= 720;
    
    f= fopen(file_name, 'r');
    I = fread(f, [width,height], 'uint16');
    fclose(f);
    I = I';

    %Convert from range [0, 1023] range [0, 1] (working in double image format).
%     I = I/(2^10-1);
%     I = I/max(max(I));  % normalization [0,1]
    I = ((I-min(min(I)))*1)/(max(max(I))-min(min(I)));
    
    if is_rgbn
        rgbn = zeros(height/2,width/2,4);
        rgbn(:,:,3) = I(1:2:end, 1:2:end);
        rgbn(:,:,2) = I(1:2:end, 2:2:end);
        rgbn(:,:,1) = I(2:2:end, 2:2:end);
        rgbn(:,:,4) = I(2:2:end, 1:2:end);
%         B = I(1:2:end, 1:2:end);
%         G = I(1:2:end, 2:2:end);
%         R = I(2:2:end, 2:2:end);
        nir = I(2:2:end, 1:2:end);
    else
        rgbn = zeros(height/2,width/2,3);
        rgbn(:,:,3) = I(1:2:end, 1:2:end);
        rgbn(:,:,2) = I(1:2:end, 2:2:end);
        rgbn(:,:,1) = I(2:2:end, 2:2:end);
%         B = I(1:2:end, 1:2:end);
%         G = I(1:2:end, 2:2:end);
%         R = I(2:2:end, 2:2:end);
        nir = 'there is no nir';
    end
end