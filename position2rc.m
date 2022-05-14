function  [r,c]=position2rc(position,n)
%          n=20;
         if mod(position,n)==0
             c=n;
         else
             c=mod(position,n);
         end
         r=ceil(position/n);




