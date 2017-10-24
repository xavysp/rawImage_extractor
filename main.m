%% Read files from a dir

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