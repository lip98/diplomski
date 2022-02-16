function mosaicNew = createMosaic(tgImg,srcImg)
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
%% Image phase correlation method;
%[xy]= nccp(tgImgGray,srcImgGray);
% tform = imregcorr(tgImgGray, srcImgGray,'rigid','Window',1);
 %tform = imregcorr(tgImgGray, srcImgGray,'rigid');
%% SURF feature matching method
% points1 = detectSURFFeatures(tgImgGray, 'MetricThreshold', 1000);
% points2 = detectSURFFeatures(srcImgGray, 'MetricThreshold', 1000);
% points1 = detectORBFeatures(tgImgGray,'ScaleFactor' ,1.1,'NumLevels',12);
% points2 = detectORBFeatures(srcImgGray,'ScaleFactor' ,1.1,'NumLevels',12);
% points1 = detectBRISKFeatures(tgImgGray);
% points2 = detectBRISKeatures(srcImgGray);
points1 = detectSURFFeatures(tgImgGray, 'MetricThreshold', 1000,'NumScaleLevels',4,'NumOctaves',5);
points2 = detectSURFFeatures(srcImgGray, 'MetricThreshold', 1000,'NumScaleLevels',4,'NumOctaves',5);

% Extract the features.
[f1,vpts1] = extractFeatures(tgImgGray, points1);
[f2,vpts2] = extractFeatures(srcImgGray, points2);

% Match points and retrieve the locations of matched points.
indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));
pts1 = matchedPoints1.Location;
pts2 = matchedPoints2.Location;
% 
% figure; ax = axes;
% showMatchedFeatures(tgImg,srcImg,matchedPoints1,matchedPoints2,'Parent',ax);
% title(ax, 'Candidate point matches');
% legend(ax, 'Matched points 1','Matched points 2');
[tform,inlierIdx1] = estimateGeometricTransform2D(pts2,pts1,'rigid');



%[bestHomography, bestInlierCount] = RANSAC(transpose(pts1),transpose(pts2));
%%
% Stitch 
 %mosIm2 = stitch (tgImg,srcImg,tform);
 mosIm2 = newStitch2(tgImg,srcImg,tform);
%%
% perc = inlierIdx*100/size(pts1,2);


%% Cylindrical Mapping

 %mosImCyl = stitch_cylinder (tgImgGray,srcImgGray,H,mosIm2);
% imshow(mosImCyl)
% figure(1);
% clf;
% imagesc(mosImCyl);
% axis image off ;
% title('Mosaic') ;
% colormap gray;
%%Blend
%   blended = stitch_blend(tgImg,srcImg,H,mask1,mask2,mosIm2);
%imshow(blended)
% figure(1);
% clf;
% imagesc(blended);
% axis image off ;
% title('Blended') ;
% colormap gray;
 mosaicNew = mosIm2;
end

