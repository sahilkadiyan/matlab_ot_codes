format short
clc
clear all
%%% input parameters for the LPP
Noofvariables=3;
C=[-1 3 -1];
Info=[3 -1 2; -2 4 0 ; -4 3 8];
b=[7 ; 12 ; 10];
s=eye(size(Info,1));
A=[Info s b];

cost=zeros(1,size(A,2));
cost(1:Noofvariables)=C;

%%%Constraint BV
BV=Noofvariables+1:size(A,2)-1;

%%% Calculate Zj-Cj row 
zjcj=cost(BV)*A-cost;

%%%For print table
zcj=[zjcj;A];
Simptable=array2table(zcj);
Simptable.Properties.VariableNames(1:size(zcj,2)) = {'x_1','x_2','x_3','s_1','s_2','s_3','Sol'}


RUN=true;
while RUN

%%%Check if any negative value is there
if any(zjcj<0);
    fprintf('the current BFS is not the optimal one \n')
    fprintf('\n =================The next iteration results =======\n')
    disp('OLD basic variable(BV) = ')
    disp(BV);
    
    %%% Finding the entering variable
    zc=zjcj(1:end-1);
    [EnterCol,pvt_col]=min(zc);
    fprintf('The minimum element in Zj-Cj row is %d corresponding to column %d \n',EnterCol,pvt_col);
    fprintf('Entering variable is %d \n',pvt_col);
    
    %%%Finding the leaving variable
    sol=A(:,end) %%last column which is of solution column 
    column = A(:,pvt_col)
    if all(column<=0)
        error('LPP is UNBOUNDED allentries<=0 in colummn %d',pvt_col);
    else
        for i=1:size(column,1)
            if column(i)>0
                ratio(i)=sol(i)./column(i);
            else
                ratio(i)=inf;
            end
        end
        
        [MinRatio , pvt_row]=min(ratio);
        fprintf('the min ratio corresponding to pivot row is %d \n',pvt_row);
        fprintf('leaving variable is %d \n',BV(pvt_row));
    end
    
    BV(pvt_row)=pvt_col;
    
    disp('now basic variables (BV) =')
    disp(BV);
    
    %%%PIVOT key
    pvt_key=A(pvt_row,pvt_col);
    
    %%now divide the row by pvt_key
    A(pvt_row,:)=A(pvt_row,:)./pvt_key;
    
    
    %%% update the table for next iteration 
    for i=1:size(A,1)
        if i~= pvt_row
            A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
        end
        
        zjcj=zjcj-zjcj(pvt_col).*A(pvt_row,:);
        
       zcj=[zjcj;A];
table=array2table(zcj);
table.Properties.VariableNames(1:size(zcj,2)) = {'x_1','x_2','x_3','s_1','s_2','s_3','Sol'}


BFS=zeros(1,size(A,2));
BFS(BV)=A(:,end)
BFS(end)=sum(BFS.*cost);
current_BFS=array2table(BFS);
current_BFS.Properties.VariableNames(1:size(current_BFS,2))={'x_1','x_2','x_3','s_1','s_2','s_3','sol'}
    
    end
 
else
    RUN=false;
    fprintf('solution is optimal one');
end

end



        
    
    
    


