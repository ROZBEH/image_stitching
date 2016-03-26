%% Calculates a transformation that aligns the points points1 and points2 using RANSAC Optimization
function T_im1 = OPT( points1, points2, n_pts )
best_n_inliers = -1;
idx_best = zeros(n_pts,1);
it_improv={}; % saves the amount of inliers per improvment
n_iters = 2^n_pts * 10; % Iteration rule of thumb :-)
fprintf('In Progress. Please wait ... ')
for i = 1:n_iters
    % progressbar
    
    % Create a set of 'n_pts' unique point indices
    idxset = 1:length(points2(:,1));
    idxs=zeros(n_pts,1);
    for j = 1:n_pts
        idx=randi(length(idxset)-j+1);
        idxs(j)=idxset(idx);
        idxset(idx:end-1)=idxset(idx+1:end);
    end
    
    % Calculate the transformation
    warning off all
    T = Affine(points1(idxs,:), points2(idxs,:));
    warning on all
    % transformation check
    if max(max(isnan(T.tdata.T)))==1
        disp('nan');
        continue
    end
    
    % Apply the transformation ...
    [A_X A_Y] = tformfwd(T,points1(:,1),points1(:,2));
    dXsq = (A_X - points2(:,1)).^2;
    dYsq = (A_Y - points2(:,2)).^2;
    
    % .. and count the amount of inliers
    n_inliers=0;
    for i=1:length(dXsq)
        e=sqrt(dXsq(i)+dYsq(i));
        if e <= 2 % inlier radius in px
            n_inliers=n_inliers+1;
        end
    end
    
    % improvment check
    if n_inliers > best_n_inliers
        best_n_inliers = n_inliers;
        T_im1 = T;
        it_improv{end+1}=best_n_inliers;
        idx_best = idxs;
    end
end
fprintf('>\n')

% disp('Inliers:');
% disp(it_improv);

best_pts=zeros(length(idx_best),4);
best_pts(:,[1 2])=points1(idx_best,:);
best_pts(:,[3 4])=points2(idx_best,:);


end
