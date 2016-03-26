%% MainThree is able to Stitch three corresponding pictures from different formats but overlapping parts to eachother
clc
close all
clear all
commandwindow
fprintf(2,'HELLO.\n')
im1 = imread('demoimages-copy/STA_5973.jpg');
im2 = imread('demoimages-copy/STB_5974.jpg'); 
im3 = imread('demoimages-copy/STC_5975.jpg'); 
im4 = imread('demoimages-copy/STD_5976.jpg'); 
IMRESIZE=input('To be faster, Do you want to reduce image size? Just say y or n--->','s');
while IMRESIZE~='y' && IMRESIZE~='n'
    IMRESIZE=input('I did not get that... Just say y or n --->','s');
end

warning('off')
if IMRESIZE=='y'
    if size(im1,2)>300 || size(im1,1)>300
        im1=imresize(im1,[300,NaN]);
    end
    if size(im2,2)>300 || size(im2,1)>300
        im2=imresize(im2,[300,NaN]);
    end
    if size(im3,2)>300 || size(im3,1)>300
        im3=imresize(im3,[300,NaN]);
    end
     if size(im4,2)>300 || size(im4,1)>300
        im4=imresize(im4,[300,NaN]);
    end
end
warning('on')
IM1=im1;
IM2=im2;
IM3=im3;
IM4=im4;
%% sift features
[im1points im2points] = MchSift( im1, im2, 0, true );
[im2points2 im3points] = MchSift( im2, im3, 0, true );
[im3points2 im4points] = MchSift( im3, im4, 0, true );
% MEAN1=mean(im1points(:,1));
% MEAN2=mean(im2points(:,1));
% if MEAN2 >= MEAN1
%     clearvars -except IM1 IM2
%     im1=IM2;
%     im2=IM1;
%     [im1points im2points] = MchSift( im1, im2, 0, true );
% end
%% OPT affine
im2_TA1= OPT( im2points, im1points, 3 );

%% stitch affine
[im_STCHA,XY1] = STCHSTCHSTCH(im1, im2,im2points2, im2_TA1);
im3_TA1= OPT( im3points, XY1, 3 );
im_STCHA=im2uint8(im_STCHA);
[im_STCHB,XY2] = STCHSTCHSTCH(im_STCHA, im3,im3points2, im3_TA1);
im4_TA1= OPT( im4points, XY2, 3 );
im_STCHB=im2uint8(im_STCHB);
[im_STCHC,XY3] = STCHSTCHSTCH(im_STCHB, im4,im3points2, im4_TA1);
% figure
% imshow(im_STCHC)
figure;
warning('off')
Im(:,:,1)=imadjust(im_STCHC(:,:,1),[0;.8],[0.01;1]);
Im(:,:,2)=imadjust(im_STCHC(:,:,2),[0;.8],[0.01;1]);
Im(:,:,3)=imadjust(im_STCHC(:,:,3),[0;.8],[0.01;1]);
imshow(Im);

