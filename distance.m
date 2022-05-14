function dis=distance(w,to_visit,n)
%     n=20;
    if mod(w,n)==0
        c1=n;
    else
        c1=mod(w,n);
    end
    r1=ceil(w/n);
    if mod(to_visit,n)==0
       c2=n;
    else
      c2=mod(to_visit,n);
    end
    r2=ceil(to_visit/n);
    dis=((c1-c2)^2+(r1-r2)^2)^(1/2);
