function [rotationAngle, xoffSet,yoffSet] = ImageRegistration(image1, image2)

%%We use the mask to ged rid of unwanted high frequencies
% image1 = ImageMaskingBeforeFFT(image1);
% image2 = ImageMaskingBeforeFFT(image2);
image1 = rgb2gray(image1);
image2 = rgb2gray(image2);
image1 =imtranslate(image1,[10 0]);
image2 =imtranslate(image2,[-60 0]);

%Searching for the IFFT Cross-Power spectrum peak and it's coordinates
%C = normxcorr2(image1,image2);
I2 = fft2(image2);
I2C = conj(I2);
I1 = fft2(image1);
FFTR = I1.*I2C;
magFFTR = abs(FFTR) + 1;
C = (FFTR./magFFTR);
fc = gradientDescentPSR(C);
f = figure(1);
surf(abs(C))
shading interp;
colormap(f,hot);
%Optimal frequency search-Butterworth filter
f = linspace(0.01,0.5,50);
optimalFrequency=0;
maxValue=0;

% for i = 1:50
%     fc = f(i);
%     PSR=PSRValue(C,fc);
%     if (maxValue<PSR)
%         maxValue=PSR;
%         optimalFrequency = fc;
%     end
% end

%C = ButterworthFilter(C,optimalFrequency);
t = ifft2(C);
t(3:size(t,1),3:size(t,2))=0;
f2 = figure(2);
surf(abs(t));
shading interp;
colormap(f2,hot)
[ypeak,xpeak] = findMaxValueCoords(t);
% yoffSet = ypeak-size(image1,1)
% xoffSet = xpeak-size(image1,2)
yoffSet = ypeak-1;
xoffSet = xpeak-1;
s = size(image1);
% base = exp((log(s(1)/2)/siz));
% scale = base^xp;
% rotationAngle = ((xp-1)/s(2))*360
% rotationAngle = (-180*yp)/s(2)
% rotationAngle = atan2(yp,xp)
rotationAngle = -360*(yoffSet)/s(2)
%After calculating the rotation, we perform rotation on the second image
image2rot = imrotate(image2,rotationAngle,'crop');
% image2rot = imresize(image2rot,scale);
%imshow(image2rot)

% We have to adjust first image size accordig to the second one 
% s1 = size(image1);
% s2 = size(image2rot);
% We calculate the difference between rows and columns of the two pictures
% deltaSY = abs(s2(1)-s1(1));
% deltaSX = abs(s2(2)-s1(2));
% Columns added
% A = zeros(int16(s1(1)),int16(deltaSX));
% image1Concatenated = horzcat(image1,A);
% Rows added
% A = zeros(int16(deltaSY),int16(s1(2)+deltaSX));
% image1Concatenated = vertcat(image1Concatenated,A);
%     
% s3=size(image1Concatenated);
% image1nn = image1Concatenated.*0;
% Here we perform translation of the image which we concatenated
%     for i=1:s3(1)
%         for j=1:s3(2)
%             
%             if(i+int16(deltaSY/2)<=s3(1) && j+int16(deltaSX/2)<=s3(2) )
%                 
%                 image1nn(i+int16(deltaSY/2),j+int16(deltaSX/2))=image1Concatenated(i,j);
%             
%             end
%         end
%     end
% image1Translated=image1nn;
% imshow(image1Translated)
% I2 = fft2(image2rot);
% I2C = conj(I2);
% I1 = fft2(image1Translated);
% FFTR = I1.*I2C;
% magFFTR = abs(FFTR) + 1;
% C = (FFTR./magFFTR);
% 
% optimalFrequency=0;
% maxValue=0;
% for i = 1:50
%     fc = f(i);
%     PSR=PSRValue(C,fc);
%     if (maxValue<PSR)
%         maxValue = PSR;
%         optimalFrequency = fc;
%     end
% end
% o=optimalFrequency
% 
% C = ButterworthFilter(C,fc);
% t = ifft2(C);
% surf(abs(t));
%C = normxcorr2(image1,image2rot);

%C = ButterworthFilter(C,fc);
%t = ifft2(C);
%t=abs(t);
%surf(t);
[ypeak,xpeak] = findMaxValueCoords(t);
% yoffSet = ypeak-size(image1,1)
% xoffSet = xpeak-size(image1,2)
yoffSet = ypeak-1
xoffSet = xpeak-1
end
