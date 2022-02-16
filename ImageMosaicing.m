 folder = 'C:\Users\luka\Desktop\FLS_mosaicing\cnn4';
filePattern = fullfile(folder, '*.png');
myFiles = dir(filePattern); % Folder with the images

imageStart = imread(fullfile(folder, myFiles(1).name));
%imageStart = ImageMaskingBeforeFFT(imageStart);
%imageStart = imresize(imageStart,0.5);
   
for k = 2:(length(myFiles))
    imageNew = imread(fullfile(folder, myFiles(k).name));
    %imageNew = imresize(imageNew,0.5);
    %imageNew = ImageMaskingBeforeFFT(imageNew);
    imageStart = createMosaic(imageNew,imageStart);
       imshow(imageStart)
 end
 