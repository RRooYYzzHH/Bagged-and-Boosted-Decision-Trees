function T=id3tree(xTr,yTr,maxdepth,weights)
% function T=id3tree(xTr,yTr,maxdepth,weights)
%
% The maximum tree depth is defined by "maxdepth" (maxdepth=2 means one split).
% Each example can be weighted with "weights".
%
% Builds an id3 tree
%
% Input:
% xTr | dxn input matrix with n column-vectors of dimensionality d
% yTr | 1xn input matrix
% maxdepth = maximum tree depth
% weights = 1xn vector where weights(i) is the weight of example i
%
% Output:
% T = decision tree
%

%% fill in code here

[d,n]=size(xTr);

%handle not provided input
if nargin<3
    weights = ones(1,n)./n;
    maxdepth = Inf;
end
weights=weights./sum(weights);

% calculate maxDepth and estimate q - length of T
maxdepth = min(maxdepth, d);
q = 0;
for i = 1:maxdepth
    q = q + power(2,(i - 1));
end    
T = zeros(6,q);

% Initial cell array
Dx = cell(q,1);
Dy = cell(q,1);
W = cell(q,1);
Feature = cell(q,1);

f = zeros(1,d);
for i = 1:d
    f(1,i) = i;
end    
   
X = xTr;
Y = yTr;
Dx{1} = X;
Dy{1} = Y;
W{1} = weights;
Feature{1} = f;

judge = 1;
for depth = 1:maxdepth
    if judge == 0
        break;
    end
    judge = 0;
    for i = power(2,(depth-1)):(power(2,depth)-1)
        parentIndex = floor(i/2);
        if i ~= 1 %not root
            parent = T(:, parentIndex);
            if parent(4,1) == 0 %parent is a leaf
                continue;
            end
        end
        % get cell array 
        X = Dx{i};
        Y = Dy{i};
        weights = W{i};
        F = Feature{i};

        [d,~] = size(X);
        [~, dataNum] = size(Y);
        [majority, ~, ~] = mode(Y);
        [~, uni] = size(unique(Y));
        T(1,i) = majority;
        T(6,i) = parentIndex;

        if uni == 1 || (2*i + 1) > q %pure or maxDepth
            T(4,i) = 0;
            T(5,i) = 0;   
        else           
            [feature,cut,~]=entropysplit(X,Y,weights);
            
            if feature == 0
                T(4,i) = 0;
                T(5,i) = 0; 
                continue;
            end
            
            final_fea = F(1,feature);
            T(2,i) = final_fea;
            T(3,i) = cut;

            judge = 1;
            T(4, i) = 2 * i;
            T(5, i) = 2 * i + 1;

            [~,ii]=sort(X(feature,:));
            Y=Y(ii);   
            weights=weights(ii);
            X=sortrows(X',feature)';

            cutIndex = 0;
            for j = 1:dataNum
                if X(feature,j) > cut
                    cutIndex = j;
                    break;
                end    
            end  

            if feature ~= 1
                X = [X(1:(feature-1),:); X((feature+1):d,:)];
                F = [F(:,1:(feature-1)), F(:,(feature+1):d)];
            else
                X = X(2:d,:);
                F = F(:,2:d);
            end
            Xleft = X(:,1:(cutIndex-1));
            Xright = X(:,cutIndex:dataNum);
            Yleft = Y(:,1:(cutIndex-1));
            Yright = Y(:,cutIndex:dataNum);
            Wleft = weights(:,1:(cutIndex-1));
            Wright = weights(:,cutIndex:dataNum);
            
            Wleft=Wleft./sum(Wleft);
            Wright=Wright./sum(Wright);

            Dx{2*i} = Xleft;
            Dy{2*i} = Yleft;
            Dx{2*i + 1} = Xright;
            Dy{2*i + 1} = Yright; 
            W{2*i} = Wleft;
            W{2*i + 1} = Wright;
            Feature{2*i} = F;
            Feature{2*i + 1} = F;
        end
    end
end
