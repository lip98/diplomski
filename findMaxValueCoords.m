function [y,x]=findMaxValueCoords(t)
        s = size(t);
        maxValue = 0;
        xp=0;
        yp=0;
        for i = 1:s(1)
            for j = 1:s(2)
                if(t(i,j)>maxValue)
                    maxValue = t(i,j);
                    yp=i;
                    xp=j;
                end
            end
        end
        x=xp;
        y=yp;
end