%% MainAll is able to search inside a folder of images for corresponding pictures and STCH them to eachother
clc
close all
clear all
commandwindow
fprintf(2,'HELLO.\n')
IMRESIZE=input('To be faster, Do you want to reduce image size? Just say y or n--->','s');
while IMRESIZE~='y' && IMRESIZE~='n'
    IMRESIZE=input('I did not get that... Just say y or n --->','s');
end
%pwd is the command for current folder in MATLAB
srcFiles1 = dir('demo\*.png');
srcFiles2 = dir('demo\*.jpg');  
srcFiles3 = dir('demo\*.bmp');
srcFiles=[srcFiles1; srcFiles2; srcFiles3]; 
% the folder in which ur images exists
indice=-1;
i=0;
while i <= length(srcFiles)
    i=i+1;
    if i==indice+1, i=i+1; end
    if i == length(srcFiles)+1
    h = msgbox('Finished :-). There is no more pictures in the database.');
    return;
    end
    filename = strcat(pwd,'\demo\',srcFiles(i).name);
    clearvars -except srcFiles i filename filename2 j IMRESIZE
    I{i} = imread(filename);
    PTS=zeros(10000,10000);
    for j = i+1 : length(srcFiles)
        filename2 = strcat(pwd,'\demo\',srcFiles(j).name);
        J{j}=imread(filename2);
        im1 = I{i};
        im2 = J{j};
        if IMRESIZE=='y'
            im2 = imresize(im2, [256 NaN],'nearest');
            im1 = imresize(im1, [256 NaN],'nearest');
        end
%% sift features
        [im1points im2points] = MchSift( im1, im2, 0, true );
        INDEX(j-1)=numel(im1points);
        PTS(1:size(im1points,1),[4*(j-2)+1 4*(j-2)+2])=im1points;
        PTS(1:size(im2points,1),[4*(j-2)+3 4*(j-2)+4])=im2points;
        clearvars im1points im2points
    end
    Alpha=max(INDEX);
    indice=find(INDEX==Alpha);
    im2=J{indice+1};
    if IMRESIZE=='y'
        im2 = imresize(im2, [256 NaN], 'nearest');
    end
    PTS( ~any(PTS,2), : ) = [];
    im1points=PTS(:,[4*(indice-1)+1 4*(indice-1)+2]);
    im2points=PTS(:,[4*(indice-1)+3 4*(indice-1)+4]);
%% OPT affine
    im2_T= OPT( im2points, im1points, 3 );
%% STCH affine
    warning('off', 'Images:initSize:adjustingMag');
    im_STCH = STCH(im1, im2, im2_T);
%     figure;
%     imshow(im_STCH);
    figure;
    warning('off')
    Im(:,:,1)=imadjust(im_STCH(:,:,1),[0;.8],[0.01;1]);
    Im(:,:,2)=imadjust(im_STCH(:,:,2),[0;.8],[0.01;1]);
    Im(:,:,3)=imadjust(im_STCH(:,:,3),[0;.8],[0.01;1]);
    imshow(Im);
end