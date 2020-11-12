addpath('/Users/spuliz/Desktop/DCU/IPAassignmentdata');
clc;
clear all;

A_COL=imread('IPAassignmentdata/parrot.jpg');
disp('image read done');

h=figure;
imshow(A_COL);
set(h, 'Name', 'Color Image');

A=rgb2gray(A_COL);
A=uint8(A);

h=figure;
imshow(A);
set(h, 'Name', 'GrayScale Image');

B= vsg('Median', A);
disp('median done');
B = uint8(B);

h= figure;
imshow(B);
set(h, 'Name', 'Median 3X3'); 

