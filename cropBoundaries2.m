function [top,bottom,left,right] = cropBoundaries2(mosaicNew)

s = size(mosaicNew);

top = 0;
topCondition = 1;

bottom = 0;
bottomCondition = 0;
t = zeros(1,s(2),3);

for i = 1:s(1)
            
    %checking the top condition
    if (any(any(mosaicNew(i,:,:))))
        topCondition = 0;
        %Setting the bottom condition
        bottomCondition = 1;
    end    
        
    
    %Setting the top condition
    if(topCondition == 1)
        top = i-1;
    end
    
    %Checking the bottom condition
        if (bottomCondition == 1)
            
            if(mosaicNew(i,:,:) == t)
                bottom = i-1;
                bottomCondition = 0;
            end
            
        end
        
end

left = 0;
leftCondition = 1;

right = 0;
rightCondition = 0;

t = zeros(s(1),1,3);

for i = 1:s(2)
           
        %checking the left condition
        if (any(any(mosaicNew(:,i,:))))
            leftCondition = 0;
            %Setting the bottom condition
            rightCondition = 1;
        end    
        
   
    
    %Setting the top condition
    if(leftCondition == 1)
        left = i-1;
    end
    
    %Checking the bottom condition
        if (rightCondition == 1)
            
            if(mosaicNew(:,i,:) == t)
                right = i-1;
                rightCondition = 0;
            end
            
        end
        
end
if(left == 0)
    left =1;
end
if(top == 0)
    top =1;
end
if(right == 0)
    right =s(2);
end
if(bottom == 0)
    bottom =s(1);
end

end