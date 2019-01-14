%% Reading RAW images
% close all;
clear all;

% set the following data:
file_type = 'h5'; % [raw or h5]
is_multispectral=true; %true when the data has NIR or false if it is just RGB
file_dir = 'dataset/'; % The four files are into dataset dir so leave as setted
% *** For the multispectral option just add N to RGB like 
% if is_multispectral true  in the *_file_names "RGBN" ***

if is_multispectral
    raw_file_name = 'TE3-RGBN-14_22-383.raw'; % into the dataset dir you will find 2 h5 files,
    % choice one of them and put it here
    h5_file_name ='RGBNC_296.h5'; % into the dataset dir you will 
    % find 2 raw files, choice one of them and put it here
else
    h5_file_name ='RGBR_296.h5';
    raw_file_name='TE3-RGB-14_22-383.raw';
end

if strcmp(file_type,'raw')
    file_path = strcat(file_dir,raw_file_name);
    rgbn =  open_raw(file_path,is_multispectral);

else
    file_path = strcat(file_dir,h5_file_name);
    rgbn = h5_reader(file_path);

end

[nir, rgb] = visualization_mat(rgbn,is_multispectral);
if is_multispectral
    disp(file_path);
    imshow(rgb) 
    figure;
    imshow(nir)
    pause;
else
    disp(file_path)
%     figure;
    imshow(rgb);
    pause;
    
end
% imwrite(rgb,'dataset/RGB.png');
return;

%% Reading the dataset saved in mat files
% download the dataset .mat from: https://xavysp.github.io/post/ssmid-dataset/

% path = 'OMSIV.mat';  % dataset name
% load(path);
n = length(OMSIV);
for i=1:n
    
    [nir,rgbn] = visualization_mat(OMSIV(i).rgbn, true);
    [n_, rgb] = visualization_mat(OMSIV(i).rgb, false);
    
    h = [];
    h(1) = subplot(1,3,1);
    image(rgb);
    title('RGB image');
    h(2) = subplot(1,3,2);
    image(rgbn);
    title('RGB+NIR image');
    h(3) = subplot(1,3,3);
    image(nir);
    title('NIR image');
    pause(0.25);
    
%     OMSIV(i).nir_imgs = nir;
%     OMSIV(i).rgb_imgs = rgb;
    

end
