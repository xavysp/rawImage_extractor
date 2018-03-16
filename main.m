%% Reading RAW images
clear all;

file_dir = 'dataset/';
file_names = dir(strcat(file_dir,'*.raw'));
disp(size(file_names,1));
disp('files found');
is_rgbnir=true;
if is_rgbnir
   [nir, rgbn] =  open_raw(strcat(file_dir,file_names(2).name),is_rgbnir);
end
imshow(uint8(rgbn(:,:,1:3).*255))
pause;

is_rgbnir=false;

if ~is_rgbnir
    [nir,rgb] = open_raw(strcat(file_dir,file_names(1).name), is_rgbnir);
end
figure;
imshow(uint8(rgb.*255))
pause;

return;

%% Reading the dataset saved in mat files
% download the dataset .mat from: https://xavysp.github.io/post/ssmid/

% path = 'OMSIV.mat';  % localitation of dataset

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
