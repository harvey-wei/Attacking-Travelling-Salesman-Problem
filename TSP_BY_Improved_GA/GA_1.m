% To Solve the TSP by the Improved GA
% Created by Harvey Mao @2014/11/17
% School of Automotive Engineering,WHUT
% The number of city:101
%% To clear the environment 
clc,clear,close

%% To preprocess the data
% load the coordinates for 100 objects
sj0=load('sj.txt');
x=sj0(:,1:2:8);x=x(:);
y=sj0(:,2:2:8);y=y(:);
sj=[x,y];d1=[70,40];
sj=[d1;sj;d1];                %the coordinate including the start-end nodes
N=101;                        % the number of the cities
%to generate the distance matrix
sj=sj*pi/180;                 % transform the angle to the radian
d=zeros(N+1);                 % to initial the d-mat
for i=1:N+1
    for j=i+1:N+1
        d(i,j)=6370*acos(cos(sj(i,1)-sj(j,1))*cos(sj(i,2))*cos(sj(j,2))+sin(sj(i,2))*sin(sj(j,2)));
        d(j,i)=d(i,j);
    end
end

%% the ga process
% set the arguments
M=50;                          %the population size 
G=1000;                        % the maximum evolutional generations
rand('state',sum(clock));      % initial the random numbers generattion machine
pm=0.1;                        % the probability of mutation
pc=1;                          % the probability of crossover
%% to generate the inital population

for k=1:M
    c=randperm(N-1);
    c1=[1,c+1,N+1];
    for t=1:N+1
        flag=0;
        for m=1:N-1
            for n=m+2:N
                if d(c1(m),c1(n))+d(c1(m+1),c1(n+1))<d(c1(m),c1(m+1))+d(c1(n),c1(n+1))
                 c1(m+1:n)=c1(n:-1:m+1);  flag=1;
                end
            end
        end
        if flag==0
           J(k,c1)=1:N+1;break;
        end
    end
end
J(:,1)=0;J=J/(N+1);            %transform the integer series to the interval [0,1]

%% evolve
for k=1:G
    % crossover
    A=J;                        %A is used to generate the children by crossover
    c=randperm(M);              %to generate the chromosome for crossovering
    for i=1:2:M                 %notice the odds or even of M
        F=2+floor((N-1)*rand)
        temp=A(c(i),F:end);
       A(c(i),F:end)=A(c(i+1),F:end);
       A(c(i+1),F:end)=temp;
    end
    
    % mutate
    by=[];                     %the length of the empty vector is 0
    while ~length(by)
        by=find(rand(1,M)<pm); % the number of the chromosome to mutate
    end
    B=A(by,:);                 % the inital chromosomes for mutating
    for j=1:length(by)
        mut_point=sort(2+floor((N-1)*rand(1,3)));
        B(j,:)=B(j,[1:mut_point(1)-1,mut_point(2)+1:mut_point(3),mut_point(1):mut_point(2),mut_point(3)+1:end]);
    end
    
    %select
    Mix_Pop=[J;A;B];            % parents and children 
    [SG,ind1]=sort(Mix_Pop,2);  % ind1 is a series from 1 to 102;
    num=size(ind1,1);           % the number of size of Mix_Pop
    distance=zeros(1,num);      % save the distance 
    for i=1:num
        for j=1:N
            distance(i)=distance(i)+d(ind1(i,j),ind1(i,j+1));
        end
    end
    [SP,ind2]=sort(distance);   %sort by ascending order
    J=Mix_Pop(ind2(1:M),:);     %update the population
    SP(1)
    Best_Path(k,:)=ind1(ind2(1),:);
    Shortest_Len(k)=distance(ind2(1));
end
%     plot(1:G,Shortest_Len)
      Best_Time=Shortest_Len(end)/1000
      temp1=Best_Path(G,:);
      temp1(end)=1;
      nn=length(temp1);
      p=num2str(temp1(1));
      
      for i=2:nn
          p=[p,'->',num2str(temp1(i))];
      end
      p
