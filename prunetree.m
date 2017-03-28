function T=prunetree(T,xTe,y)
% function T=prunetree(T,xTe,y)
%
% Prunes a tree to minimal size such that performance on data xTe,y does not
% suffer.
%
% Input:
% T = tree
% xTe = validation data x (dxn matrix)
% y = labels (1xn matrix)
%
% Output:
% T = pruned tree
%

%% fill in code here
acc = analyze('acc',y,evaltree(T,xTe));

[~,q] = size(T);
depth = ceil(log2(q));

for i = 1:q
    index = q - i + 1;
    if mod(index, 2) == 1 %right leaf
        continue;
    end
    if T(4,i) ~= 0
        continue;
    end
    parentIndex = i / 2;
    if T(4, parentIndex) == 0
        continue;
    end
    temp = T;
    temp(4, parentIndex) = 0;
    temp(5, parentIndex) = 0;
    newAcc = analyze('acc',y,evaltree(temp,xTe));
    if newAcc > acc
        T = temp;
        acc = newAcc;
    end
end


