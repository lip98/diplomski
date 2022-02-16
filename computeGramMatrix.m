%%The computeGramMatrix helper function is used by the styleLoss helper function to 
%compute the Gram matrix of a feature map.
function gramMatrix = computeGramMatrix(featureMap)
    [H,W,C] = size(featureMap);
    reshapedFeatures = reshape(featureMap,H*W,C);
    gramMatrix = reshapedFeatures' * reshapedFeatures;
end