function BDT=boosttree(X,y,nt,maxdepth)
% function BDT=boosttree(x,y,nt,maxdepth)
%
% Learns a boosted decision tree on data X with labels y.
% It performs at most nt boosting iterations. Each decision tree has maximum depth "maxdepth".
%
% INPUT:
% X  | input vectors dxn
% y  | input labels 1xn
% nt | number of trees (default = 100)
% maxdepth | depth of each tree (default = 3)
%
% OUTPUT:
% BDT | Boosted DTree
%


%% fill in code here
[d, m] = size(X);
D = ones(1,m)./m; % initial D1

BDT = cell(nt, 2);

for i = 1:nt
    T = id3tree(X,y,maxdepth,D);
    ypredict = evaltree(T,X);
    error = 0;
    for j = 1:m
        if ypredict(1, j) ~= y(1, j) %miss classified
            error = error + D(1, j);
        end    
    end  
    if error > 0.5
        break;
    end    
    acc = 1 - error;
    alpha = 0.5 * log(acc / error);
    D = D .* exp(alpha * sum(2*(ypredict~=y) - 1));
    D = D./sum(D);
    BDT{i, 1} = T;
    BDT{i, 2} = alpha;
end

