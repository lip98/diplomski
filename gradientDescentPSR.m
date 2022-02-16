function fcOptimal = gradientDescentPSR(C)
%Used for finding the optimal cut-off frequency to maximize the PSR
%relation
fc = 0;
grad = 0.01;
ni = 1;
firstPass = 0;
PSRMax = 0;
PSRPast=0;

while(any(ni))
   %if( fc+ni*grad <0.5)
   fc = fc+ni*grad 
   CB = ButterworthFilter(C,fc);
   PSR = PSRValue(CB);
   
   if(PSRMax>PSR)
       PSRMax = PSR;
       PSRPast = PSR;
   end
   
   if(firstPass==0)
       firstPass=1;
       ni = 0.99;
   else
       ni = (PSR-PSRPast)/PSR;
   end
%    else
%     ni = -0.2*ni;
%    end
       
end
fcOptimal = fc;
end