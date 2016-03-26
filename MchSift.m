%% SIFT matching between im1 and im2.Returns The lists of matched points for both images.
function [points1, points2] = MchSift(im1, im2, mode, show)
if nargin < 4, show = false;end
if nargin >= 3 && mode == 1
    load previous_points points1 points2
else
    [loc1,loc2,matchidxs]=MATCHED( rgb2gray(im1), rgb2gray(im2), show );
    points1 = loc1(find(matchidxs>0),1:2);
    points2 = loc2(nonzeros(matchidxs),1:2);
    points1 = points1(:,[2 1]);
    points2 = points2(:,[2 1]);
    pts=unique([points1 points2], 'rows');
    fprintf('\n')
    points1 = pts(:,[1 2]);
    points2 = pts(:,[3 4]);
    save previous_points points1 points2
end
end