addpath('/Users/spuliz/Desktop/DCU/sample_images');
clc;
clear all;

A_COL=imread('sample_images/planet.jpg');
disp('image read done');

h=figure;
imshow(A_COL);
set(h, 'Name', 'Color Image');

A=rgb2gray(A_COL);
A=uint8(A);

h=figure;
imshow(A);
set(h, 'Name', 'GrayScale Image');
