%% NIR image processing
% nir_processing
function N = nir_processing(rgbn)
    
    if length(size(rgbn))==3 && size(rgbn,3)>=3
        [w,h,d]=size(rgbn);
        if max(max(max(rgbn)))>1
            rgbn = ((rgbn-min(min(min(rgbn)))).*1)./(max(max(max(rgbn)))-min(min(min(rgbn))));
        end
        N = reshape(rgbn(:,:,4),[h,w]);
%         N = reshape(rgbn(:,:,4),[h,w]);
    elseif length(size(rgbn))==4 && size(rgbn,4)>=3
        [w,h,d]=size(reshape(rgbn,[size(rgbn,2),size(rgbn,3),size(rgbn,4)]));
        rgbn = reshape(rgbn,[size(rgbn,2),size(rgbn,3),size(rgbn,4)]);
        if max(max(max(rgbn)))>1
            rgbn = ((rgbn-min(min(min(rgbn)))).*1)./(max(max(max(rgbn)))-min(min(min(rgbn))));
        end
        N = reshape(rgbn(:,:,4),[h,w]);
        
    elseif length(size(rgbn))==2 && size(rgbn,3)<=1
        [w,h]=size(rgbn);
        if max(max(max(rgbn)))>1
            rgbn = ((rgbn-min(min(min(rgbn)))).*1)./(max(max(max(rgbn)))-min(min(min(rgbn))));
        end
        N=rgbn;
    else
        disp('Error double check your input data, it should be nxmx4');
    end
    
    %Linear streatch NIR channel.
    N = imadjust(N, stretchlim(N, [0.02 0.98]),[]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Simple white balance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Simple gamma correction
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gamma = 0.4545;
    N = N.^gamma;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Demosaic
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Convert to uint8 (range [0, 255]).
    N = uint8(round(N*255));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Shrink size of RGB image for reducing demosaic artifacts.
% %     imshow(imVis);
% %     pause(0.5);
% %     imshow(N);
% %     pause(0.5);
%     close all;
end