%% num = match(image1, image2)This function reads two images, finds their SIFT features.
function [loc1,loc2,matchidxs] = MATCHED(image1, image2, show)
if nargin < 3
    show=true;
end
% Find SIFT keypoints for each image
[im1, des1, loc1] = SIFTLOWE(image1);
[im2, des2, loc2] = SIFTLOWE(image2);
distRatio = 0.6;
des2t = des2';  
matchidxs=zeros(size(des1,1),1);
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;       
   [vals,indx] = sort(acos(dotprods));

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      matchidxs(i) = indx(1);
   end
end
num = sum(matchidxs > 0);
fprintf('Found %d matches.\n', num);