format short %upto 4 decimal places
clear all
clc  % clear screen
%input data
Cost=[11 20 7 8 ;21 16 10 12 ; 8 12 18 9 ];
A=[50; 40; 70]; %row
B=[30; 25; 35;40]; %column

%check  balanced /unbalanced problem
if sum(A)== sum(B)
    fprintf('Given Transportation Problem is Balanced \n');
else
    fprintf('Given Transportation Problem is Unbalanced \n');
    
    if sum(A)<sum(B)
        Cost(end+1,:)=zeros(1,size(A,2));
        A(end+1)=sum(B)-sum(A);
    elseif sum(B)<sum(A)
        Cost(:,end+1)=zeros(1,size(A,2));
        B(end+1)=sum(A)-sum(B);
    end
end

ICost=Cost; %save the cost copy
X=zeros(size(Cost)); %Initialize allocation
[m,n]=size(Cost); %finding Rows-column
BFS=m+n-1; %total BFS


for i=1:size(Cost,1) %row loop
    for j=1:size(Cost,2) %column loop
        
        hh=min(Cost(:)); %finding min cost value
        [rowind,colind]=find(hh==Cost);
        x11=min(A(rowind),B(colind)); % assign allocations to each cost
        [val,ind]=max(x11); %find max allocation
        ii=rowind(ind); %identify row position
        jj=colind(ind); %identify column position
        %so we set the allocation at (ii,jj) position
        y11=min(A(ii),B(jj));
        X(ii,jj)=y11; %assign allocation
        A(ii)=A(ii)-y11; %reduce the row value
        B(jj)=B(jj)-y11; %reduce the column value
        Cost(ii,jj)=Inf; %Cell covered so no need to cover that again and again
    end
end

%%% print the initial BFS
fprintf('Initial BFS = \n');
IB=array2table(X);
disp(IB);

%%% check for degenerate and non-degenerate
TotalBFS=length(nonzeros(X));
if TotalBFS==BFS
    fprintf('initial BFS non-degenerate \n');
else
    fprintf('Initial BFS is Degenerate \n');
end

%%% compute the initial Transportation Cost

InitialCost=sum(sum(ICost.*X));

fprintf('Initial BFS Cost = %d \n',InitialCost)






