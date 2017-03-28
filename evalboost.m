function preds=evalboost(BDT,xTe)
% function preds=evalboost(BDT,xTe);
%
% Evaluates a boosted decision tree on a test set xTe.
%
% input:
% BDT | Boosted Decision Trees
% xTe | matrix of m input vectors (matrix size dxm)
%
% output:
%
% preds | predictions of labels for xTe
%

%% fill in code here
[~, n] = size(xTe);
[nt, ~] = size(BDT);

preds = zeros(1, n);

for i = 1:n
    pred = cell(nt, 2);
    pred(:, 2) = {0};
    pred(:, 1) = {Inf};
    
    X = xTe(:,i);
    for j = 1:nt
        T = BDT{j, 1};
        w = BDT{j, 2};
        [ypredict] = evaltree(T,X);
        for k = 1:nt
            if pred{k, 1} == ypredict(1,1)
                pred{k, 2} = pred{k, 2} + w;
                break;    
            end    
            if pred{k, 1} == Inf
                pred{k, 1} = ypredict(1,1);
                pred{k, 2} = w;
                break;
            end    
        end    
    end
    max = 0;
    for m = 1:nt
        weight = pred{m,2};
        if weight > max;
            max = weight;
            preds(1, i) = pred{m,1};
        end    
    end    
end    

