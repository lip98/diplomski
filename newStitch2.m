function imgout = newStitch2(img1,img2,tform)
H = transpose(tform.T);

img3 = imwarp(img2,tform);
stitchedImage = img1;
xleft = 0;
xright = size(stitchedImage,2);
yup = 0;
ydown = size(stitchedImage,1);

for i = 1:size(stitchedImage, 2)
    for j = 1:size(stitchedImage, 1)
        p2 = H * [i; j; 1];
        p2 = p2 ./ p2(3);

        x2 = floor(p2(1));
        y2 = floor(p2(2));
                 
       if(x2<xleft)
           xleft=x2;
       end
       if(x2>xright)
            xright=x2;
       end
       if(y2<yup)
            yup=y2;
       end
       if(y2>ydown)
            ydown = y2;
       end
        
    end
end

%%padding the images so they can fit in size
xleft=-1*xleft;
yup = -1*yup;
xleft = double(xleft);
yup = double(yup);
xright = double(xright-size(stitchedImage,2));
ydown = double(ydown-size(stitchedImage,1));
stitchedImage = padarray(stitchedImage, [0 xleft], 0, 'pre');
stitchedImage = padarray(stitchedImage, [yup 0], 0, 'pre');
stitchedImage = padarray(stitchedImage, [0 xright], 0, 'post');
stitchedImage = padarray(stitchedImage, [ydown 0], 0, 'post');
 s= size(stitchedImage);
 sdiff = size(stitchedImage) -size(img3);
  tx = H(2,3);
 ty= H(1,3);
if(sdiff(1)>0 )
if(ty<0)
    img3 = padarray(img3, [sdiff(1) 0], 0, 'post');
else
    img3 = padarray(img3, [sdiff(1) 0], 0, 'pre');
end
else
    if(sdiff(1)<0)
        sdiff(1)= -1*sdiff(1);
        stitchedImage = padarray(stitchedImage, [sdiff(1) 0], 0, 'post');
    end
    
    
end
 if(sdiff(2)>0)
     if(tx>0)
    img3 = padarray(img3, [0 sdiff(2)], 0, 'pre');
else
    img3 = padarray(img3, [0 sdiff(2)], 0, 'post');
end
 else
     if(sdiff(2)<0)
        sdiff(2)= -1*sdiff(2);
        stitchedImage = padarray(stitchedImage, [0 sdiff(2)], 0, 'post');
    end
 end
 %imshow(imfuse(img3,stitchedImage,'blend','Scaling','joint'));
  %u = stitchedImage;
  img1 = stitchedImage;
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
imnew = imlincomb(0.5, img1, 0.5, img3);
imnew = imnew.*mask;
for i = 1:size(stitchedImage, 1)
    for j = 1:size(stitchedImage, 2)
            
             if(mask(i,j,:)==1)
               stitchedImage(i,j,:) = imnew(i,j,:);
            end
                    
        
    end
end
% im_out = PoissonEquation( stitchedImage,img3,mask,0,0 )
%result = poissonSeamlessCloning(img3, stitchedImage, mask,mask, [0 0]);

[top,bottom,left,right] = cropBoundaries2(stitchedImage);
stitchedImage = stitchedImage(top:bottom,left:right,:);
imgout = stitchedImage;
end