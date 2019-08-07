function pl=patlen(path,d)
%path----a path permutation that is a column vector
%d---the distance matrix(m x m)
%pl---the length of the path
m=size(path,2);%to get the col-num
i1=path;
i2=[path(2:m),path(1)];
pl=sum(d((i1-1)*m+i2));
end
