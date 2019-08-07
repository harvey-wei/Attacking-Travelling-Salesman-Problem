% to solve the TSP by Particle Swarm Optimization
tic
%% clear the environment
clc,clear,close
%% load the data
X=xlsread('citycoor.xlsx',1,'a2:b15');
D=Distanse(X);%to generate the distance matrix
N=size(D,1);  %to get the number of city
%% initial the arg.
maxnum=250;%the maximum iterations
parsize=100;%the size of the PS
x=zeros(parsize,N);
size(x)
 for i=1:parsize
     x(i,:)=[1 randperm(N-1)+1];
 end

fvalue=fitness(x,D);
pbestvalue=fvalue;
pbestcoor=x;
[gbestvalue,index]=max(pbestvalue);
gbestcoor=pbestcoor(index,:);
gg=size(maxnum,1);
for i=1:maxnum
    %to calculate the fvalue
    f=fitness(x,D);
    %to update the particle
    index1=find(f<pbestvalue);
    pbestvalue(index1)=f(index1);
    pbestcoor(index1,:)=x(index1,:);
    [gbestvalue,index2]=min(pbestvalue);
    gbestcoor=x(index2,:);
    gg(i,1)=gbestvalue;
    if i>1
    line([i-1,i],[gg(i-1,1),gg(i,1)]);pause(0.00001)
    end
    %to update the coordinate of particles
    %to crossover the x
    for j=1:parsize
    c=round((N-2)*rand(2,1)+1);%to generate the crossover node
    c=minmax(c);%sort the node 
    %x crossovers with the pbestcoor
    tempx=[x(j,1:c(1)-1) pbestcoor(j,c(1):c(2)) x(j,c(2):end)];
    flag=zeros(1,N);
    %to delete the repeated flag
      for k=1:N
        flag(k)=length(find(tempx==k));
        if flag(k)==2
           subpoint=find(tempx==k);
        end
      end
      if ~isempty(find(flag==0))
          find(flag==0);
    tempx(subpoint(1))=find(flag==0);%the empty matrix can not give the value
      end
    % to accept or not
     if fitness(tempx,D)<fitness(x(j,:),D)
        x(j,:)=tempx;
     end
    %to mutate
    c=round((N-2)*rand(2,1)+1);%to generate the mutating node
    c=minmax(c);%sort the node ;
    tempx1=[x(j,1:c(1)-1) x(j,c(2)) x(j,c(1)+1:c(2)-1) x(j,c(1)) x(j,c(2)+1:end)];
    if fitness(tempx1,D)<fitness(x(j,:),D)
        x(j,:)=tempx1;
    end
    end
end
gbestcoor
gbestvalue
%% to draw the path graph
DrawPath(gbestcoor,X);
toc