%Load the style image and content image.
contentImage = im2double(imread('C:\Users\luka\Desktop\FLS_mosaicing\flsImages3\2019-10-01_145011_Frame_1424.png'));
%Implementing the mask for FLS images
contentImage = ImageMaskingBeforeFFT(contentImage);


styleImage = imread('C:\Users\luka\Desktop\FLS_mosaicing\flsImages3\lightBlue.jpg');
%%In this example, you use a modified pretrained VGG-19 deep neural network to 
%extract the features of the content and style image at various layers. These 
%multilayer features are used to compute respective content and style losses. 
%The network generates the stylized transfer image using the combined 
net = vgg19;
%net = vgg19('Weights','imagenet')

%% To make the VGG-19 network suitable for feature extraction, remove all
%of the fully connected layers from the network.
lastFeatureLayerIdx = 37;
layers = net.Layers;
layers = layers(1:lastFeatureLayerIdx);
%%The max pooling layers of the VGG-19 network cause a fading effect. To decrease 
%the fading effect and increase the gradient flow, replace all max pooling layers with average pooling layers 
for l = 1:lastFeatureLayerIdx
    layer = layers(l);
    if isa(layer,'nnet.cnn.layer.MaxPooling2DLayer')
        layers(l) = averagePooling2dLayer(layer.PoolSize,'Stride',layer.Stride,'Name',layer.Name);
    end
end
%% Create a layer graph with the modified layers.
lgraph = layerGraph(layers);
%% Visualize the feature extraction network in a plot. 
% plot(lgraph)
% title('Feature Extraction Network')
%% To train the network with a custom training loop and enable automatic 
%differentiation, convert the layer graph to a dlnetwork object.

dlnet = dlnetwork(lgraph);
%% Resize the style image and content image to a smaller size for faster processing.
imageSize = [384,512];
styleImg = imresize(styleImage,imageSize);
contentImg = imresize(contentImage,imageSize);
%% The pretrained VGG-19 network performs classification on a channel-wise mean 
%subtracted image. Get the channel-wise mean from the image input layer, which is 
%the first layer in the network.

imgInputLayer = lgraph.Layers(1);
meanVggNet = imgInputLayer.Mean(1,1,:);
%% The values of the channel-wise mean are appropriate for images of floating point
%data type with pixel values in the range [0, 255]. Convert the style image and
%content image to data type single with range [0, 255]. Then, subtract the 
%channel-wise mean from the style image and content image.
styleImg = rescale(single(styleImg),0,255) - meanVggNet;
contentImg = rescale(single(contentImg),0,255) - meanVggNet;


%% The transfer image is the output image as a result of style transfer. You can 
%initialize the transfer image with a style image, content image, or any random image.
%Initialization with a style image or content image biases the style transfer process 
%and produces a transfer image more similar to the input image. In contrast, 
%initialization with white noise removes the bias but takes longer to converge on the 
%stylized image. For better stylization and faster convergence, this example 
%initializes the output transfer image as a weighted combination of the content image 
%and a white noise image.
noiseRatio = 0;
randImage = randi([-20,20],[imageSize 3]);
transferImage = noiseRatio.*randImage + (1-noiseRatio).*contentImg;
%% Content Loss
styleTransferOptions.contentFeatureLayerNames = {'conv4_2'};
styleTransferOptions.contentFeatureLayerWeights = 1;
%% Style loss
styleTransferOptions.styleFeatureLayerNames = {'conv1_1','conv2_1','conv3_1','conv4_1','conv5_1'};
styleTransferOptions.styleFeatureLayerWeights = [1.0,1.0,1.0,1.0,2.0];
%% Total Loss
styleTransferOptions.alpha = 1; 
styleTransferOptions.beta = 1e3;
numIterations = 10
%% Specify options for Adam optimization. Set the learning rate to 2 for faster 
%convergence. You can experiment with the learning rate by observing your output image
%and losses. Initialize the trailing average gradient and trailing average
%gradient-square decay rates with [].
learningRate = 1;
trailingAvg = [];
trailingAvgSq = [];
%% Convert the style image, content image, and transfer image to dlarray 
%(Deep Learning Toolbox) objects with underlying type single and dimension labels 
%'SSC'.
dlStyle = dlarray(styleImg,'SSC');
dlContent = dlarray(contentImg,'SSC');
dlTransfer = dlarray(transferImage,'SSC');
if canUseGPU
    dlContent = gpuArray(dlContent);
    dlStyle = gpuArray(dlStyle);
    dlTransfer = gpuArray(dlTransfer);
end
%% Extract the content features from the content image.
numContentFeatureLayers = numel(styleTransferOptions.contentFeatureLayerNames);
contentFeatures = cell(1,numContentFeatureLayers);
[contentFeatures{:}] = forward(dlnet,dlContent,'Outputs',styleTransferOptions.contentFeatureLayerNames);
%% Extract the style features from the style image.
numStyleFeatureLayers = numel(styleTransferOptions.styleFeatureLayerNames);
styleFeatures = cell(1,numStyleFeatureLayers);
[styleFeatures{:}] = forward(dlnet,dlStyle,'Outputs',styleTransferOptions.styleFeatureLayerNames);
%% Train the model using a custom training loop. For each iteration:

    %Calculate the content loss and style loss using the features of the content image,
    %style image, and transfer image. To calculate the loss and gradients, use the
    %helper function imageGradients (defined in the Supporting Functions section of 
    %this example).

    %Update the transfer image using the adamupdate (Deep Learning Toolbox) function.

    %Select the best style transfer image as the final output image.

figure

minimumLoss = inf;

for iteration = 1:numIterations
    % Evaluate the transfer image gradients and state using dlfeval and the
    % imageGradients function listed at the end of the example. 
    [grad,losses] = dlfeval(@imageGradients,dlnet,dlTransfer,contentFeatures,styleFeatures,styleTransferOptions);
    [dlTransfer,trailingAvg,trailingAvgSq] = adamupdate(dlTransfer,grad,trailingAvg,trailingAvgSq,iteration,learningRate);
  
    if losses.totalLoss < minimumLoss
        minimumLoss = losses.totalLoss;
        dlOutput = dlTransfer;        
    end   
    
    % Display the transfer image on the first iteration and after every 50
    % iterations. The postprocessing steps are described in the "Postprocess
    % Transfer Image for Display" section of this example.
    if mod(iteration,1) == 0 || (iteration == 1)
        
        transferImage = gather(extractdata(dlTransfer));
        transferImage = transferImage + meanVggNet;
        transferImage = uint8(transferImage);
        transferImage = imresize(transferImage,size(contentImage,[1 2]));
        
        image(transferImage)
        title(['Transfer Image After Iteration ',num2str(iteration)])
        axis off image
        drawnow
    end   
    
end
%% Get the updated transfer image.
transferImage = gather(extractdata(dlOutput));
%% Add the network-trained mean to the transfer image.
transferImage = transferImage + meanVggNet;
%% Some pixel values can exceed the original range [0, 255] of the content and style 
%image. You can clip the values to the range [0, 255] by converting the data type to 
%uint8.
transferImage = uint8(transferImage);
%% Resize the transfer image to the original size of the content image.
transferImage = imresize(transferImage,size(contentImage,[1 2]));
%% Display the content image, transfer image, and style image in a montage.
imshow(imtile({contentImage,transferImage,styleImage}, ...
    'GridSize',[1 3],'BackgroundColor','w'));