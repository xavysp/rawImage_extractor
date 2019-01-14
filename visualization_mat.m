%function for RGB/RGBN and/or NIR image visualization from a *.mat file

function [nir,img]=visualization_mat(img, is_rgbn)
    if is_rgbn
        if length(size(img))==3 && size(img,3)>=3
            [w,h,d]=size(img);
            if max(max(max(img)))>1
                img = ((-min(min(min(img)))).*1)./(max(max(max(img)))-min(min(min(img))));
            end
            R = reshape(img(:,:,1),[w,h]);
            G = reshape(img(:,:,2),[w,h]);
            B = reshape(img(:,:,3),[w,h]);
            N = reshape(img(:,:,4),[w,h]);
        elseif length(size(img))==4 && size(img,4)>=3
            
            img = reshape(img,[size(img,2),size(img,3),size(img,4)]);
            [w,h,d]=size(img);
            if max(max(max(img)))>1
                img = ((-min(min(min(img)))).*1)./(max(max(max(img)))-min(min(min(img))));
            end
            R = reshape(img(:,:,1),[w,h]);
            G = reshape(img(:,:,2),[w,h]);
            B = reshape(img(:,:,3),[w,h]);
            N = reshape(img(:,:,4),[w,h]);
        
%         elseif length(size(rgbn))==2 && size(rgbn,3)<=1
%             imVis = nir_processing(img);
%             return;
        
        else
            disp('Error double check your input data, it should be nxmx4');
        end
        
        % ************ for RGB images ************
    else
        if length(size(img))==3 && size(img,3)>=3
            [w,h,d]=size(img);
            if max(max(max(img)))>1
                img = ((-min(min(min(img)))).*1)./(max(max(max(img)))-min(min(min(img))));
            end
            R = reshape(img(:,:,1),[w,h]);
            G = reshape(img(:,:,2),[w,h]);
            B = reshape(img(:,:,3),[w,h]);
%             N = reshape(img(:,:,4),[w,h]);
        elseif length(size(img))==4 && size(img,4)>=3
            
            img = reshape(img,[size(img,2),size(img,3),size(img,4)]);
            [w,h,d]=size(img);
            if max(max(max(img)))>1
                img = ((-min(min(min(img)))).*1)./(max(max(max(img)))-min(min(min(img))));
            end
            R = reshape(img(:,:,1),[w,h]);
            G = reshape(img(:,:,2),[w,h]);
            B = reshape(img(:,:,3),[w,h]);
%             N = reshape(img(:,:,4),[w,h]);
        
%         elseif length(size(rgbn))==2 && size(rgbn,3)<=1
%             imVis = nir_processing(img);
%             return;
        
        else
            disp('Error double check your input data, it should be nxmx4');
        end
    end
    
%   *********** image post-processing ***************
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Linear streatch blue color channel.
    B = imadjust(B, stretchlim(B, [0.02 0.98]),[]);

    %Linear streatch green channel.
    G = imadjust(G, stretchlim(G, [0.02 0.98]),[]);

    %Linear streatch red color channel.
    R = imadjust(R, stretchlim(R, [0.02 0.98]),[]);
    %Linear streatch NIR channel.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Simple white balance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Median or R, G and B.
    rgb_med = [mean2(R(:)), mean2(G(:)), mean2(B(:))];
    rgb_scale = max(rgb_med)./rgb_med;
    %Scale each color channel, to have the same median.
    R = R*rgb_scale(1);
    G = G*rgb_scale(2);
    B = B*rgb_scale(3);
    %Restore Bayer mosaic.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Insert streached color channnels back into I.
    % without matrix color correction
    I= zeros(w*2,h*2); % heigthxwidth
    I(1:2:end, 1:2:end) = B;
    I(1:2:end, 2:2:end) = G;
    I(2:2:end, 2:2:end) = R;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Replace IR with green - resize green to full size of image first.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T = imresize(mat2gray(G), [w*2, h*2]); %T - temporary green, size 1280x720
    I(2:2:end, 1:2:end) = T(2:2:end, 1:2:end); %Replace IR with Green.
    I = max(min(I, 1), 0); %Limit I to range [0, 1].
    %I=imresize(I,[360, 640]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Simple gamma correction
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gamma = 0.4545;
    I = I.^gamma;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Demosaic
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Convert to uint8 (range [0, 255]).
    I = uint8(round(I*255));
    RGB = demosaic(I, 'bggr');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    img = imresize(RGB, size(I)/2); %Shrink size of RGB image for reducing demosaic artifacts.
    if is_rgbn
        
        nir = nir_processing(N);
    else
        nir=0;
    end

end