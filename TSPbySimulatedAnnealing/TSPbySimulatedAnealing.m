tic
%% to solve the TSP problem by Simulated Annealing Algorithm
%the starting node is fixed
%% to clear the environment
clc,clear,close
%% to load and preprocess the data
sj=load('sj.txt');
x=sj(:,1:2:8);%to get the longtitude
x=x(:);%to get column vector
y=sj(:,2:2:8);%to get the latitude
y=y(:);
coor=[x,y];
coor=[70 40;coor];%to add the fixed node
coor=coor*pi./180;%to convert the angle to radian
m=size(coor,1);%to get the number of the city
d=dist(coor);%to get the dist-mat
d=real(d);%

%% to simulate the annealing 
% to get a better initial sol.
path=inipath(d);
% to initial the relevant parameters
e=10^(-30);%the finishing temperature
L=80000;%the frequency of iterating
alpha=0.99;%the coefficient of temp-drop
T=100;
%to begin annealing

for k=1:L
        %to generate new sol
       c=2+round(99*rand(1,2));
       c=sort(c);
       u=c(1);v=c(2);
      pathnew=[path(1:u-1),path(v:-1:u),path(v+1:end)];
        %to calculate the difference of the cost fun.
        delta=patlen(pathnew,d)-patlen(path,d);
     
        %accept or not
        if (delta<0)
            path=pathnew;
        else
            if exp(-delta/T)>rand
                path=pathnew;
            end
        end
    T=T*alpha;
    if T<e
        break;
    end
end

%% to print the outcome
 p=num2str(path(1));
shtlen=patlen(path,d)
disp('The best path is');
for i=2:m
    p=[p,'->',num2str(path(i))];
end
DrawPath(path,coor);
p
toc
  
        
        
        
        
        
        

