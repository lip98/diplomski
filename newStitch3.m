function imgout = newStitch3(img1,img2,tform)
H = transpose(tform.T);
tform2= tform;
tform2.T(3,1)=0;
tform2.T(3,2)=0;
angle = (1/(2*pi))*360*acos(H(1,1));
img3 = imwarp(img2,tform2);
%img3 = imrotate(img2,angle);
% dangle = atan2(size(img1,1),size(img1,2))*(1/(2*pi))*360;
% angle = (1/(2*pi))*360*acos(H(1,1));
diff = size(img3)-size(img1);
stitchedImage = img1;
dx = double(ceil(diff(2)/2));
stitchedImage = padarray(stitchedImage, [0 dx], 0, 'pre');
stitchedImage = padarray(stitchedImage, [0 diff(2)-dx], 0, 'post');
dy = double(ceil(diff(1)/2));
stitchedImage = padarray(stitchedImage, [dy 0], 0, 'pre');
stitchedImage = padarray(stitchedImage, [diff(1)-dy 0], 0, 'post');
tx = double(ceil(H(2,3)));
ty = double(ceil(H(1,3)));
tform.T = eye(3);
tform.T(3,1)= ty;
tform.T(3,2)= tx;
img4 = imtranslate(img3,[ty tx],'OutputView','full');
%img4 = imwarp(img3,tform);


diff = size(img4)-size(stitchedImage);
dx = double(ceil(diff(2)));
if(tx>0)
    stitchedImage = padarray(stitchedImage, [0 dx], 0, 'post');
else
    tx = -tx;
    stitchedImage = padarray(stitchedImage, [0 dx], 0, 'pre');
end
dy = double(ceil(diff(1)));
if(ty>0)
    stitchedImage = padarray(stitchedImage, [dy 0], 0, 'post');
else
    ty =-ty;
    stitchedImage = padarray(stitchedImage, [dy 0], 0, 'pre');
end
img3 = img4;

  %u = stitchedImage;
  mask = stitchedImage(:,:,1).*0;
for i = 1:size(stitchedImage, 1)
    for j = 1:size(stitchedImage, 2)
            
             if(stitchedImage(i, j,:)>0)
                if(img3(i,j,:)>0)
%                     u(i,j,:) = stitchedImage(i, j,:) + img3(i,j,:);
%                     u(i,j,:) = ceil(u(i,j,:)./2);
%                     stitchedImage(i,j,:)= u(i,j,:) ;
                      mask(i,j,:)=1;
                end
            end
                 
            
            if(stitchedImage(i, j,:)==0)
                stitchedImage(i, j,:) = img3(i,j,:);            
            end
%             if(img3(i, j,:)>70)
%                 stitchedImage(i, j,:) = img3(i,j,:);            
%             end
%             
        
    end
end

%stitchedImage = pyramidBlend(img3,stitchedImage,mask)
%newimg = blendPoisson(img3 ,mask,stitchedImage );
% imnew = imfuse(img3,stitchedImage,'blend','Scaling','joint');
% imnew = imnew.*mask;
% for i = 1:size(stitchedImage, 1)
%     for j = 1:size(stitchedImage, 2)
%             
%              if(mask(i,j,:)==1)
%                stitchedImage(i,j,:) = imnew(i,j,:);
%             end
%                     
%         
%     end
% end
%im_out = PoissonEquation( stitchedImage,img3,mask,0,0 )

[top,bottom,left,right] = cropBoundaries2(stitchedImage);
stitchedImage = stitchedImage(top:bottom,left:right,:);
imgout = stitchedImage;
end