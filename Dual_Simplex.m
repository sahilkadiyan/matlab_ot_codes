format short
clear all
clc
% input
variables={'x1','x2','x3','s1','s2','sol'};
Cost=[-2 0 -1 0 0 0];
Info=[-1 -1 1 ;
    -1 2 -4];
b=[-5; -8];
s=eye(size(Info,1));
A=[Info s b];
%Finding starting BFS
BV=[];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV=[BV i];
        end
    end
end

fprintf('Basic Variables BV are')
display(variables(BV))

ZjCj=Cost(BV)*A-Cost;

%print the table
ZCj=[ZjCj;A];
Simpletable=array2table(ZCj)
Simpletable.Properties.VariableNames(1:size(ZCj,2))=variables

RUN=true;
while RUN
    SOL=A(:,end);
    if any(SOL<0)
        fprintf('the current BFS is not feasible')
        % find the leaving variable
        [LeaVal , pvt_row]=min(SOL);
        fprintf('leaving row is %d',pvt_row);
        % find the entering variable
        ROW=A(pvt_row,1:end-1);
        ZJ=ZjCj(:,1:end-1);
        
        for i=1:size(ROW,2)
            if ROW(i)<0
                ratio(i)=abs(ZJ(i)./ROW(i));
            else
                ratio(i)=inf;
                
            end
        end
        [minVal,pvt_col]=min(ratio);
        fprintf('Entering variable is %d \n',pvt_col);
        
        % update the BV
        BV(pvt_row)=pvt_col;
        fprintf('Basic Variables (BV) are');
        disp(variables(BV));
        % update the table for the next iteration
        pvt_key=A(pvt_row,pvt_col);
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        
        %print the table
        ZjCj=Cost(BV)*A-Cost;
ZCj=[ZjCj;A];
Simpletable=array2table(ZCj)
Simpletable.Properties.VariableNames(1:size(ZCj,2))=variables

final_BFS=zeros(1,size(A,2));
            final_BFS(BV)=A(:,end);
            final_BFS(end)=sum(final_BFS.*Cost);
            optimal_Table=array2table(final_BFS);
            optimal_Table.Properties.VariableNames(1:size(optimal_Table,2))=variables
        
        
        
                
        
        
    else
        RUN=false;
        fprintf('the current BFS is optimal')
    end
    
        
        
    
    
    
end

