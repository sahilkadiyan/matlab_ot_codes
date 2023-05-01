variables={'x_1','x_2','s_2','s_3','A_1','A_2','sol'};
M=1000;
cost=[-2 -1 0 0 -M -M 0];
A=[3 1 0 0 1 0 3;4 3 -1 0 0 1 6;1 2 0 1 0 0 3];
%identity matrix
s=eye(size(A,1))
%finding the basic variables
BV=[]
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV=[BV i];
        end
    end
end
%Computing Zj-Cj
ZjCj=cost(BV)*A-cost
%Print the table
ZCj=[ZjCj;A];
Simpletable=array2table(ZCj)
Simpletable.Properties.VariableNames(1:size(ZCj,2))=variables
%to find the entering variables
RUN=true;
while RUN
    ZC=ZjCj(1:end-1)
    if any(ZC<0)
        fprintf('The bfs soln is not optimal \n')
        [EnteringVal,pvt_col]=min(ZC)
        fprintf('The most negative number is %d at column %d \n', EnteringVal,pvt_col)
        %Finding the leaving variable
        sol=A(:,end);
        Column=A(:,pvt_col);
        if all(Column<=0)
            fprintf('The problem is unbounded in nature\n')
        else
            for i=1:size(Column,1)
               if Column(i)>0
                   ratio(i)=sol(i)./Column(i)
               else
                   ratio(i)=inf
               end
            end
        end
    
            
            [LeavingVal, pvt_row]=min(ratio)
            fprintf('The value of leaving_var is %d and the pivot row is %d \n', LeavingVal, pvt_row)
            %Updating the BV
            BV(pvt_row)=pvt_col
            %Updating the table
            pvt_key=A(pvt_row,pvt_col);
            A(pvt_row,:)=A(pvt_row,:)./pvt_key
            for i=1:size(A,1)
                if i~=pvt_row
                    A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:)
                end
                
            end
            ZjCj=ZjCj-ZjCj(pvt_col).*A(pvt_row,:)
            ZCj=[ZjCj;A];
            Table=array2table(ZCj)
            Table.Properties.VariableNames(1:size(ZCj,2))=variables
            %To get the final Table
            final_BFS=zeros(1,size(A,2));
            final_BFS(BV)=A(:,end);
            final_BFS(end)=sum(final_BFS.*cost);
            optimal_Table=array2table(final_BFS);
            optimal_Table.Properties.VariableNames(1:size(optimal_Table,2))=variables
    
    
    
    
    else
        RUN=false;
        fprintf('The current BFS is the optimal one \n');
    
    end
end

