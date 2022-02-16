function  img = ImageMaskingBeforeFFT(img)
imgCropped = img(1:600,50:750,:);
%imgCropped = img(1:900,50:750,:);
binary = im2bw(imgCropped,0.01);

se = strel('line',15,90);
binary = imerode(binary,se);
binary = imdilate(binary,se);

imgDilated = imgCropped.*0;
imgMask = imgDilated;
s = size(imgDilated);
for i = 1:s(1)
    for j = 1:s(2)
        if(binary(i,j) == 1)
            imgDilated(i,j,:)=imgCropped(i,j,:);
            imgMask(i,j,:)=255;
        end
    end
end

imgMask = imerode(imgMask,se);


kernel = fspecial('gaussian', [50 50],10);
binary = imfilter(imgMask, kernel);

imgFinal = imgCropped.*0;

s = size(binary);
for i = 1:s(1)
    for j = 1:s(2)
        if(imgMask(i,j)>0)
          imgFinal(i,j,:) = imgDilated(i,j,:).*(imgMask(i,j)/255.0);
        else
          imgFinal(i,j,:) = 0;
        end        
    end
end


img = imgFinal;
end

% subplot(1,3,1)
% imagesc(img)
% subplot(1,3,2)
% imagesc(binary)
% subplot(1,3,3)
% imagesc(imgFinal)
% subplot(4,1,3)
% imshow(binary)
% subplot(4,1,4)
% imshow(img2)

