% function PoseBasedOptimization()
 %poseGraph = poseGraph ;
 vSet = imageviewset()
 rot = eye(3);
 trans = [0 0 0];
 r = rigid3d(rot,trans);
 o = [];
 %addRelativePose(poseGraph,measurement);
 vSet = addView(vSet,1,r);
% %Array containing all of the grayscale images used for mosaicing
imgArray = loadImages();

%Matrix containing all the transformation data, 
transformationMatrix = zeros(size(imgArray,3),3);
H = [];
% 
% 
% % imshow(imgArray)
for k = 1 : size(imgArray,3)-1
img1 = imgArray(:,:,k);
img2 = imgArray(:,:,k+1);
%T = estimateImageGeometryL(img1,img2);
f = imregcorr(img1,img2,'rigid');
T=f.T
T = T./T(1,1);
if(k==1) 
    H = transpose(T);
else
    o =H(:,:,k-1);
    o =o*transpose(T);
    H = cat(3,H,o);
end
E = transpose(T);
angleRotation = -(1/(2*pi))*360*asin(E(1,2));
xOffset = E(2,3);
yOffset = E(3,3);
if (k>1)
transformationMatrix(k,1)=angleRotation+transformationMatrix(k-1,1);
transformationMatrix(k,2)=xOffset+transformationMatrix(k-1,2);
transformationMatrix(k,3)=yOffset+transformationMatrix(k-1,3);

%tform = cat(1,tform,Tform);
else
transformationMatrix(k,1)=angleRotation;
transformationMatrix(k,2)=xOffset;
transformationMatrix(k,3)=yOffset;

end
measurement = [transformationMatrix(k,2) transformationMatrix(k,3) transformationMatrix(k,1)];
o = H(:,:,k);
%rot = [o(1,1) o(1,2) 0; o(2,1) o(2,2) 0;0 0 1]; 
trans = [o(1,3) o(2,3) 0];
 r.Rotation = rot;
 r.Translation = trans;
vSet = addView(vSet,k+1,r);
if(k==2)
vSet = addConnection(vSet,k-1,k);
elseif(k==3)
vSet = addConnection(vSet,k-1,k);
vSet = addConnection(vSet,k-2,k);
elseif(k>1)
vSet = addConnection(vSet,k-1,k);
vSet = addConnection(vSet,k-2,k);
vSet = addConnection(vSet,k-3,k);
end

    

end
vSet = addConnection(vSet,k,k+1);
vSet = addConnection(vSet,k-1,k+1);
vSet = addConnection(vSet,k-2,k+1);




% end