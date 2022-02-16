function lapp = laplacianPyramid(mrp)

% Steve Eddins
% MathWorks

lapp = cell(size(mrp));
num_levels = numel(mrp);
lapp{num_levels} = mrp{num_levels};
for k = 1:(num_levels - 1)
   A = mrp{k};
   B = imresize(mrp{k+1},2,'lanczos3');
   [M,N,~] = size(A);
   lapp{k} = A - B(1:M,1:N,:);
end
lapp{end} = mrp{end};

end