%min z=3x1+5x2 s.t
%x1+3X2>=3
%X1+X2>=2
%X1,X2>=0

variables={'x1','x2','s1','s2','A1','A2','sol'}
Ovariables={'x1','x2','s1','s2','sol'}
origC=[-3 -5 0 0 -1 -1 0]
Info=[1 3 -1 0 1 0 3;
    1 1 0 -1 0 1 2]
BV=[5 6];

%Phase1
cost= [0 0 0 0 -1 -1 0]
A=Info
startBV=find(cost<0)  %%% artifical variable
ZjCj=cost(BV)*A-cost
InitialTable=array2table([ZjCj ; A])
InitialTable.Properties.VariableNames(1:size(ZjCj,2))= variables

fprintf('--- Phase 1----')
[BFS, A]=simp(A,BV,cost,variables)

fprintf('--- Phase 2----')
A(:,startBV)=[];
origC(:,startBV)=[];
[optBFS, optA]= simp(A,BFS,origC,Ovariables)

final_BFS=zeros(1,size(A,2))
final_BFS(optBFS)=optA(:,end)
final_BFS(end)=sum(final_BFS.*origC)
optimalBFS=array2table(final_BFS)
optimalBFS.Properties.VariableNames(1:size(optimalBFS,2))=Ovariables

fprintf('optimal sol of the given problem is %d',final_BFS(end))

%Two phase method
function[BFS,A]=simp(A,BV,cost,variables)
ZjCj=cost(BV)*A-cost
RUN=true
while RUN
    ZC=ZjCj(1,1:end-1)
    if any(ZC<0)
        fprintf('the current BFS is not optimal')
        [EnterCol pvt_Col]=min(ZC)
        fprintf('Entering col= %d', pvt_Col)
        sol=A(:,end)
        column=A(:,pvt_Col)
        if column <=0
            fprintf('unbounded sol')
        else
            for i=1:1:size(A,1)
                if column(i)>0
                    ratio(i)=sol(i)./column(i)
                else
                    ratio(i)=inf
                end
            end
            [Minratio, pvt_row]=min(ratio)
            fprintf('leaving row is %d', pvt_row)
        end
        BV(pvt_row)=pvt_Col
        pvt_key=A(pvt_row,pvt_Col)
        A(pvt_row,:)=A(pvt_row,:)./pvt_key
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_Col)*A(pvt_row,:)
            end
        end
        ZjCj=ZjCj-ZjCj(pvt_Col).*A(pvt_row,:)
        ZCj=[ZjCj;A]
        Table=array2table(ZCj)
        Table.Properties.VariableNames(1:size(ZCj,2))=variables
        BFS(BV)=A(:,end);
    else
        RUN=false
        fprintf('optimal soln is reached')
        fprintf('----phase ends----')
        BFS=BV;
    end
end
end