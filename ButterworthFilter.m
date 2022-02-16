function C = ButterworthFilter(C,fc)
%%Here we apply Butterworth filter to a Cross-Power spectrum to get rid of 
%unwanted high amplitude cross-correlation signal

%%
%the higher the Butterworth filter order, the higher the number of cascaded stages
%there are within the filter design, and the closer the filter becomes to the ideal
%“brick wall” response.

n = 1; % one can change this value accordingly
[M, N] = size(C);
% Assign Cut-off Frequency
D0 = fc; % one can change this value accordingly
  
% Designing filter
u = 0:(M-1);
v = 0:(N-1);
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;
[V, U] = meshgrid(v, u);
% Calculating Euclidean Distance
D = sqrt(U.^2 + V.^2);
  
% determining the filtering mask
H = 1./(1 + (D./D0).^(2*n));

C=H.*C;
end