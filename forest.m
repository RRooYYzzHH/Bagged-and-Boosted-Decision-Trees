function F=forest(X,y,nt)
% function F=forest(x,y,nt)
%
% INPUT:
% X  | input vectors dxn
% y  | input labels 1xn
% nt | number of trees
%
% OUTPUT:
% F | Forest
%

%% fill in code here
[~,n] = size(X);
F = cell(nt, 1);


num = ceil(n * 0.6);

for i = 1:nt
    Y = randsample(n,num,true)';
    xNew = X(:, Y);
    yNew = y(:, Y); 
    T = id3tree(xNew,yNew);

    F{i,1} = T;
end    
