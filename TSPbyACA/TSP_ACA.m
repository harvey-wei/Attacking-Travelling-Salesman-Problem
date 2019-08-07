%% To solve the TSP by ACA
%% clear the environment
clc,clear,close
%% load the data of city-coor
load coor.mat;%
citys=coor;
%% calculate the distance matrix
D=Distanse(citys);  
n=size(D,1); 
D=D+diag((diag(D)+1e-4));
%% initial the arg.
m=31;%the number of the ant colony
alpha=1;%the importance factor of pheromone
beta=5;%the importance factor of heuristic fun.
rho=0.1;%the volatilization factor of pheromone
Q=1;%the constant
eta=1./D;%the heuristic function
path_mat=zeros(m,n);%the path record table
tau=ones(n,n);%the pheromone matrix
iter=1;%the inital value of iteration
iter_max=250;%the maximum value of iteration
route_best=zeros(iter_max,n);%the best path of every iter
length_best=zeros(iter_max,1);%the short path len. of every iter
length_ave=zeros(iter_max,1);%the average len. of every iter
%% to seek the best path
while iter<=iter_max
    %to generate the starting node
    path_mat=round((n-1)*rand(m,1)+1);
    city_index=1:n;
    %to select the path for every ant
    for i=1:m
        for j=2:n%
            %to get the allowing sets
            tabu=path_mat(i,1:j-1);
            allow_index=~ismember(city_index,tabu);
            allow=city_index(allow_index);
            %to calculate the probility 
            i1=repmat(tabu(end),1,length(allow));
            i2=allow;
            tau0=tau((i2-1)*n+i1);
            eta0=eta((i2-1)*n+i1);
            p=(tau0.^alpha).*(eta0.^beta);
            p=p';
            p=p./sum(p);
            p_cum=cumsum(p);
            index0=find(p_cum>rand());
            path_mat(i,j)=allow(index0(1));
        end
    end
    %to calcualate the length of every ant
    len=PathLength(D,path_mat);
    %to find the shotest path up to now
    if iter==1
    [min_len,min_index1]=min(len);
    best_len(iter)=min_len;
    best_path(iter,:)=path_mat(min_index1,:);
    else
        [min_len,min_index]=min(len);
        best_len(iter)=min(best_len(iter-1),min_len);
        if best_len(iter)==min_len
            best_path(iter,:)=path_mat(min_index,:);
        else
            best_path(iter,:)=best_path(iter-1,:);
        end
    end
    if iter>1
        line([iter-1,iter],[best_len(iter-1),best_len(iter)]);pause(0.00001);
    end
    %to updat the pheromone
    %delta_tau=repmat(sum(Q./len),n,n);
    for i=1:m
        dtau=zeros(n,n);
        ii1=path_mat(i,:);
        ii2=[path_mat(i,2:end) path_mat(i,1)];
        dtau((ii2-1)*n+ii1)=Q./D((ii2-1)*n+ii1);
        if i==1
        delta_tau=dtau;
        else
            delta_tau=delta_tau+dtau;
        end
    end
    
    
    tau=(1-rho).*tau+delta_tau;
    iter=iter+1;
    %cleat the path_mat
    path_mat=zeros(m,n);
end
%input the outcome
[shortest_len,index]=min(best_len);
shortest_len
shortest_path=best_path(index,:)
OutputPath(shortest_path)
DrawPath(shortest_path,citys);



            
            
    