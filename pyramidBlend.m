function finalImage = pyramidBlend(A,B,mask_A)
level = 5;
mrp_A = multiresolutionPyramid(A,level);
mrp_B = multiresolutionPyramid(B,level);
mrp_mask_A = multiresolutionPyramid(mask_A,level);

lap_A = laplacianPyramid(mrp_A);
lap_B = laplacianPyramid(mrp_B);
lap_blend = [];
for k = 1:length(lap_A)
    lap_blend{k} = (lap_A{k} .* mrp_mask_A{k}) + ...
        (lap_B{k} .* (1-mrp_mask_A{k}));
end

finalImage = reconstructFromLaplacianPyramid(lap_blend);



end