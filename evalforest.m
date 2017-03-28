function preds=evalforest(F,xTe)
% function preds=evalforest(F,xTe);
%
% Evaluates a random forest on a test set xTe.
%
% input:
% F   | Forest of decision trees
% xTe | matrix of m input vectors (matrix size dxm)
%
% output:
%
% preds | predictions of labels for xTe
%

%% fill in code here
[~, n] = size(xTe);
[nt, ~] = size(F);

preds = zeros(1, n);

for i = 1:n
    prediction = zeros(1, nt);
    X = xTe(:,i);
    for j = 1:nt
        T = F{j, 1};
        prediction(1, j) = evaltree(T,X);
    end 
    preds(1, i) = mode(prediction);
end  


