function imgArray = loadImages()
folder = 'C:\Users\luka\Desktop\FLS_mosaicing\flsImages3';
filePattern = fullfile(folder, '*.png');
myFiles = dir(filePattern); % Folder with the images

imgArray= [];

for k = 1 : (length(myFiles))
addImage = (imread(fullfile(folder, myFiles(k).name)));
addImage = ImageMaskingBeforeFFT(addImage);
addImage= rgb2gray(addImage);
addImage = adapthisteq(addImage);


imgArray =cat(3,imgArray,addImage);
end
end