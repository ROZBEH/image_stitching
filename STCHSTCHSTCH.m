%% With two images im1 and im2 and a transformation T_im2 what would be the final stitched image
function [stitched_image,XY] = STCHSTCHSTCH(im1, im2,pts2, T_im2, mask)

mask_im2 = uint8(ones(size(im2,1),size(im2,2)));

if nargin < 5
    mask_im1 = uint8(ones(size(im1, 1), size(im1, 2)));
else
    mask_im1 = mask;
end

%Transform image 2 so it fits on image 1
%The two elements of 'XData' give the horizontal of the
%first and last columns of im2
XY = tformfwd(T_im2, pts2);
[im2, XDATA, YDATA] = imtransform(im2, T_im2);

mask_im2 = imtransform(mask_im2, T_im2);
assignin('base', 'IOU', XDATA)
assignin('base', 'IOO', YDATA)
% stitched image bounds
W=max( [size(im1,2) size(im1,2)-XDATA(1) size(im2,2) size(im2,2)+XDATA(1)] );
H=max( [size(im1,1) size(im1,1)-YDATA(1) size(im2,1) size(im2,1)+YDATA(1)] );

% Align image 1 bounds
im1_X = eye(3);
if XDATA(1) < 0, im1_X(3,1)= -XDATA(1); end
if YDATA(1) < 0, im1_X(3,2)= -YDATA(1); end
T_im1 = maketform('affine',im1_X);

[im1, XDATA2, YDATA2] = imtransform(im1, T_im1, 'XData', [1 W], 'YData', [1 H]);
mask_im1 = imtransform(mask_im1, T_im1, 'XData', [1 W], 'YData', [1 H]);

% Align image 2 bounds 
im2_X = eye(3);
if XDATA(1) > 0, im2_X(3,1)= XDATA(1); end
if YDATA(1) > 0, im2_X(3,2)= YDATA(1); end
T_im2 = maketform('affine',im2_X);
% XY = tformfwd(T_im2,XY);

[im2, XDATA, YDATA] = imtransform(im2, T_im2, 'XData', [1 W], 'YData', [1 H]);
mask_im2 = imtransform(mask_im2, T_im2, 'XData', [1 W], 'YData', [1 H]);
% Size check
if (size(im1,1) ~= size(im2,1)) || (size(im1,2) ~= size(im2,2))
    H = max( size(im1,1), size(im2,1) );
    W = max( size(im1,2), size(im2,2) );
    im1(H,W,:)=0;
    im2(H,W,:)=0;
    mask_im1(H,W)=0;
    mask_im2(H,W)=0;
end
% Combine both images
n_layers = max(max(mask_im1));
im1part = uint16(mask_im1 > (n_layers * mask_im2));
im2part = uint16(mask_im2 > mask_im1);
combpart = uint16(repmat(mask_im1 .* mask_im2,[1 1 3]));
combmask = uint16(combpart > 0);
combmask_logical=logical(combmask(:,:,1));
%  assignin('base','inm1', im1)
stitched_image_initial = repmat(im1part,[1 1 3]) .* uint16(im1) + repmat(im2part,[1 1 3]) .* uint16(im2);
SourceIm = stitched_image_initial +  (combpart .* uint16(im1) );
TargIm = stitched_image_initial + (combmask .* uint16(im2)) ;
assignin('base','SourceIm', SourceIm)
TargIm = uint8(TargIm);
SourceIm = uint8(SourceIm);
[ROW,COL]=find(combmask_logical);
A2=max(ROW);
B2=max(COL);
A1=min(ROW);
B1=min(COL);
A=find(combmask_logical(:,B2));
U1x=A(1);
U2x=A(end);
U1y=B2;
U2y=B2;
B=find(combmask_logical(:,B1));
BB=ceil(size(B,1)/2);
U3x=B(BB);
U3y=floor(0.5*(B1+B2));
U4x=floor(0.5*(A1+A2));
U4y=floor(0.75*B1);
U5x=A2;
U5y=B1;
U6x=A1;
U6y=B1;
ROW=[U1x U3x U2x U5x U4x U6x];
COL=[U1y U3y U2y U5y U4y U6y];
% figure
% imshow(SourceIm)
% figure
% imshow(TargIm)
stitched_image=BlendPois(SourceIm,TargIm,COL,ROW);
disp('We are all set.');
end