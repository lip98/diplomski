% function PoseBasedOptimization()
poseGraph = poseGraph ;

% %Array containing all of the grayscale images used for mosaicing
%imgArray2 = loadImages();

 
% imshow(imgArray)
imgArray =[];
ctr = 1;
imgArray =cat(3,imgArray2(:,:,1));
for k = 1 : size(imgArray2,3)-1
img1 = imgArray2(:,:,ctr);
img2 = imgArray2(:,:,k+1);
measurement = estimateImageGeometryL(img1,img2);

if(abs(measurement(1,2))<(size(img1,2)/2) && abs(measurement(1,3))<(size(img1,1)/2) && abs(measurement(1,1))<30 )
imgArray =cat(3,imgArray,imgArray2(:,:,k+1));
ctr = ctr+1;
end
end
for k = 1 : size(imgArray,3)-1
img1 = imgArray(:,:,k);
img2 = imgArray(:,:,k+1);
measurement = estimateImageGeometryL(img1,img2);

%if(abs(measurement(1,2))<(size(img1,2)/2) && abs(measurement(1,3))<(size(img1,1)/2) && abs(measurement(1,1))<30 )
addRelativePose(poseGraph,measurement);
%ctr = ctr+1;
%end
 

end

for k = 1 : size(imgArray,3)-2

    img1 = imgArray(:,:,k);
    img2 = imgArray(:,:,k+2);
    measurement = estimateImageGeometryL(img1,img2);
    if(abs(measurement(1,2))<(size(img1,2)/2) && abs(measurement(1,3))<(size(img1,1)/2) && abs(measurement(1,1))<40 )
        addRelativePose(poseGraph,measurement,[1 0 0 1 0 1],k,k+2);
    end
end

for k = 1 : size(imgArray,3)-3

    img1 = imgArray(:,:,k);
    img2 = imgArray(:,:,k+3);
    measurement = estimateImageGeometryL(img1,img2);
if(abs(measurement(1,2))<(size(img1,2)/2) && abs(measurement(1,3))<(size(img1,1)/2) && abs(measurement(1,1))<45 )
        addRelativePose(poseGraph,measurement,[1 0 0 1 0 1],k,k+3);
end
end

for k = 1 : size(imgArray,3)-4

    img1 = imgArray(:,:,k);
    img2 = imgArray(:,:,k+4);
    measurement = estimateImageGeometryL(img1,img2);
if(abs(measurement(1,2))<(size(img1,2)/2) && abs(measurement(1,3))<(size(img1,1)/2) && abs(measurement(1,1))<45 )
        addRelativePose(poseGraph,measurement,[1 0 0 1 0 1],k,k+4);
end
end

for k = 1 : size(imgArray,3)-5

    img1 = imgArray(:,:,k);
    img2 = imgArray(:,:,k+5);
    measurement = estimateImageGeometryL(img1,img2);
if(abs(measurement(1,2))<(size(img1,2)/2) && abs(measurement(1,3))<(size(img1,1)/2) && abs(measurement(1,1))<45 )
        addRelativePose(poseGraph,measurement,[1 0 0 1 0 1],k,k+5);
end
end
for k = 1 : size(imgArray,3)-6

    img1 = imgArray(:,:,k);
    img2 = imgArray(:,:,k+6);
    measurement = estimateImageGeometryL(img1,img2);
if(abs(measurement(1,2))<(size(img1,2)/2) && abs(measurement(1,3))<(size(img1,1)/2) && abs(measurement(1,1))<45 )
        addRelativePose(poseGraph,measurement,[1 0 0 1 0 1],k,k+6);
end
end

% trimParams.MaxIterations = 100;
% trimParams.TruncationThreshold = 25;
% 
% solverOptions = poseGraphSolverOptions('builtin-trust-region');
% poseGraphUpdated = trimLoopClosures(poseGraph,trimParams,solverOptions)

updatedGraph = optimizePoseGraph(poseGraph)
removeEdges(updatedGraph,updatedGraph.LoopClosureEdgeIDs)
show(updatedGraph);

ere = edgeResidualErrors(updatedGraph)
%new coordinates
%newcoords = edgeConstraints(updatedgraph);
% have to fix adding conditions
