I=imread('eparts2.jpg'); % Read the Image
level  = graythresh(I);
BW = im2bw(I, level);
C = corner(BW);
imshow(I)
hold on
plot(C(:,1),C(:,2),'r*');
