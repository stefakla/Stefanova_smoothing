function a = auto_check(cos,lenghts,elengths)
a = 0;
if lenghts(:,1)<3.2
    a = a+1;
end
if lenghts(:,2)>3.4
    a = a+1;
end
if min(cos)<0.95
    a = a+1;
end
D = find(elengths>0.00001);
if D==1
    a = a+1;
end
