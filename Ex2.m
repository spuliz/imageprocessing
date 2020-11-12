addpath('/Users/spuliz/Desktop/DCU/sample_images');
clc;
clear all;

A_COL=imread('sample_images/baboon.jpg');
disp('image read done');

h=figure;
imshow(A_COL);
set(h, 'Name', 'Color Image');

A=rgb2gray(A_COL);
A=uint8(A);

h=figure;
imshow(A);
set(h, 'Name', 'GrayScale Image');

B=imresize(A, 2:2);
disp('low pass done')
B = uint8(B);

h= figure;
imshow(B);
set(h, 'Name', 'Lowpass image'); 

% data driven threshold 
max_gray = max(B(:));
min_gray = min(B(:));
thresh = uint8(3*(max_gray + min_gray)/4);
disp(thresh);


C = im2bw(B);
C = im2uint8(C);

h= figure;
imshow(C);
set(h, 'Name', 'Threshold Image'); 




