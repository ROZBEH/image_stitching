%% This is the main function to call other three main functions
%% MainAll is able to search inside a folder of images for corresponding pictures and stitch them to eachother
%% MainTwo is able to Stitch two pictures from different formats but overlapping parts to eachother
%% MainThree is able to Stitch three corresponding pictures from different formats but overlapping parts to eachother

clc
close all
clear all
commandwindow
fprintf(2,'HELLO.\n')
Function=input('Which function you want to run \n MainAll for multiple pictures---> press 1 \n MainTwo for two pictures---> press 2 \n MainThree for Three pictures---> press 3\n MainFour for Four pictures---> press 4\n');
if Function==1
    MainAll
elseif Function==2
    MainTwo
elseif Function==3
    MainThree
else
    MainFour
end