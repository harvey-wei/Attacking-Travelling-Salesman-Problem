function path=inipath(d)
%d---the distance matrix
%path----a better initial path
rand('state',sum(clock));%to initial the rand generator
len=inf;
for j=1:1000 
    path0=[1 1+randperm(100)];temp=0;
    temp=patlen(path0,d);
    if temp<len
        path=path0;len=temp;
    end
end
