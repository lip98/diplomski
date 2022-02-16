function out = reconstructFromLaplacianPyramid(lapp)
num_levels = numel(lapp);
out = lapp{end};
for k = (num_levels - 1) : -1 : 1
   out = imresize(out,2,'lanczos3');
   g = lapp{k};
   [M,N,~] = size(g);
   out = out(1:M,1:N,:) + g;
end
end