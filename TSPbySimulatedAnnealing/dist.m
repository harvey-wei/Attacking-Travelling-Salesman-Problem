function D=dist(coor)
m=size(coor,1);
D=zeros(m);
for i=1:m
    d=repmat(coor(i,:),m,1);
    D(:,i)=6370*acos(cos(d(:,1)-coor(:,1)).*cos(coor(:,2)).*cos(d(:,2))+sin(d(:,2)).*sin(coor(:,2)));
end
    
    