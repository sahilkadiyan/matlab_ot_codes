clc
clear all
% change all const to <= no problem if b gets negative
 a = [-1 -3 1 0; -1 -1 0 1];
 b = [-3;-2];
 c = [-3 -5 0 0];
 %a = [1 1 1 0;-1 -2 0 1];
 %b = [1;-3];
 %c = [-3 -2 0 0];
[m,n] = size(a);
y = [a b];
bv_ind = n-m+1:1:n;
for s = 1 : 50
    cb = c(bv_ind)
    xb = y(:,end);
    z = cb * xb;
    zjcj = cb*y(:,1:n) - c
    if zjcj >= 0
        disp('Solution is optimal, now we will check for feasibility');
    else
        disp('Solution not optimal, ERROR');
        break;
    end
    if xb > 0
        disp('The solution is feasible also');
        xb
        basic_var = bv_ind
        -z  %min problem
        break;
    else
        [val,lv] = min(xb);
        for i = 1:n
            if(y(lv,i)<0)
                ratio(i) = abs(zjcj(i)./y(lv,i))
            else
                ratio(i) = inf;
            end
        end
        [val,ev] = min(ratio);
        bv_ind(lv) = ev;
    end
        pivot = y(lv,ev);
        y(lv,:) = y(lv,:)./pivot;
        for i = 1:m
            if i~= lv
                y(i,:) = y(i,:) - y(i,ev)*y(lv,:)
            end
        end
       % zjcj(1,:) = zjcj(1,:) - y(lv,:)*zjcj(1,ev);
end