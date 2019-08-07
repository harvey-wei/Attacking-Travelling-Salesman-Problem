function y=fitness(x,D)
[m,n]=size(x);
N=size(D,1);
y=size(m,1);
for i=1:m
    i1=x(i,:);
    i2=[x(i,2:n) x(i,1)];
    y(i,:)=sum(D(N.*(i2-1)+i1));
end