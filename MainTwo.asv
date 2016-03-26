%% MainTwo is able to STCH two pictures from different formats but overlapping parts to eachother
clc
close all
clear all
commandwindow
fprintf(2,'HELLO.\n')
IMRESIZE=input('To be faster, Do you want to reduce image size? Just say y or n--->','s');
while IMRESIZE~='y' && IMRESIZE~='n'
    IMRESIZE=input('I did not get that... Just say y or n --->','s');
end
im1 = imread('demoimages-copy/11.png');
im2 = imread('demoimages-copy/22.png'); 
if size(im1,1)>size(im2,1)+100 || size(im1,1)+100<size(im2,1)
    IMRESIZE='y';
end
    

warning('off')
if IMRESIZE=='y'
    if size(im1,2)>300 || size(im1,1)>300
        im1=imresize(im1,[300,NaN]);
    end
    if size(im2,2)>300 || size(im2,1)>300
        im2=imresize(im2,[300,NaN]);
    end
end
warning('on')
IM1=im1;
IM2=im2;
%% sift features
[im1points im2points] = MchSift( im1, im2, 0, true );
MEAN1=mean(im1points(:,1));
MEAN2=mean(im2points(:,1));
if MEAN2 >= MEAN1
    clearvars -except IM1 IM2
    im1=IM2;
    im2=IM1;
    [im1points im2points] = MchSift( im1, im2, 0, true );
end
%% OPT affine
im2_T= OPT( im2points, im1points, 3 );

%% STCH affine
im_STCH = STCH(im1, im2, im2_T);
% figure
% imshow(im_STCH)
figure;
warning('off')
Im(:,:,1)=imadjust(im_STCH(:,:,1),[0;.8],[0.01;1]);
Im(:,:,2)=imadjust(im_STCH(:,:,2),[0;.8],[0.01;1]);
Im(:,:,3)=imadjust(im_STCH(:,:,3),[0;.8],[0.01;1]);
imshow(Im);