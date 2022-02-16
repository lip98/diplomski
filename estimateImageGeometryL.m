function measurement =estimateImageGeometryL(img1,img2)
%Matrix containing all the transformation data, 
% transformationMatrix = zeros(1,3);
% H = [];
% points1 = detectSURFFeatures(img1, 'MetricThreshold', 200);
% points2 = detectSURFFeatures(img2, 'MetricThreshold', 200);
% % Extract the features.
% [f1,vpts1] = extractFeatures(img1, points1);
% [f2,vpts2] = extractFeatures(img2, points2);
% 
% % Match points and retrieve the locations of matched points.
% indexPairs = matchFeatures(f1,f2) ;
% matchedPoints1 = vpts1(indexPairs(:,1));
% matchedPoints2 = vpts2(indexPairs(:,2));
% pts1 = matchedPoints1.Location;
% pts2 = matchedPoints2.Location;
% 
%[tform,inlierIdx1] = estimateGeometricTransform2D(pts1,pts2,'similarity');
tgImg = img1;
srcImg = img2;
if(size(tgImg,3)>1)
    tgImgGray = rgb2gray(tgImg);
else
    tgImgGray = tgImg;
end
if(size(srcImg,3)>1)
    srcImgGray = rgb2gray(srcImg);
else
    srcImgGray = srcImg;
end
tgImgGray = adapthisteq(tgImgGray);
srcImgGray = adapthisteq(srcImgGray);
 tform = imregcorr(tgImgGray, srcImgGray,'rigid');

E = transpose(tform.T);
angleRotation = -(1/(2*pi))*360*asin(E(1,2));
xOffset = E(2,3);
yOffset = E(3,3);

transformationMatrix(1,1)=angleRotation;
transformationMatrix(1,2)=xOffset;
transformationMatrix(1,3)=yOffset;

measurement = [transformationMatrix(1,2) transformationMatrix(1,3) transformationMatrix(1,1)];
end