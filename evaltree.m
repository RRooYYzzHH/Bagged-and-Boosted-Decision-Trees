function [ypredict]=evaltree(T,xTe)
% function [ypredict]=evaltree(T,xTe);
%
% input:
% T0  | tree structure
% xTe | Test data (dxn matrix)
%
% output:
%
% ypredict : predictions of labels for xTe
%

%% fill in code here

[~,n] = size(xTe);
[~,q] = size(T);
ypredict = zeros(1,n);
for i = 1:n
   x = xTe(:,i);
   j = 1;
   while j <= q
        label = T(1,j);
        f = T(2,j);
        c = T(3,j);
        if T(4,j) == 0  %leaf
            ypredict(1,i) = label;
            break;
        end
        if x(f,1) <= c
            j = 2*j;
        else
            j = 2*j + 1;
        end    
   end    
end

