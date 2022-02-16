function PSR = PSRValue(C)
%C = ifft2(C);
s = size(C);
sum = 0;

for i = 1:s(1)
    for j = 1:s(2)
        sum = sum + C(i,j);
    end
end
mean = sum/(s(1)*s(2));
peak = 0;
sum = 0;
for i = 1:s(1)
    for j = 1:s(2)
        sum = sum + (C(i,j)-mean)^2;
        if(C(i,j)>peak)
            peak = C(i,j);
        end
    end
end
%standard deviation
sd = sqrt(sum/(s(1)*s(2)-1));
PSR = (peak-mean)/sd;
end