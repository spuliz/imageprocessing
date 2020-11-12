I = imread('eparts2.jpg');
% Calculate a 16-bin histogram for the image.
[counts,x] = imhist(I,16);
stem(x,counts)
% Compute a global threshold using the histogram counts.
T = otsuthresh(counts);
% Create a binary image using the computed threshold and display the image.
BW = im2bw(I,T);
figure;
imshow(BW);
% edge detection
[~,threshold] = edge(BW,'sobel');
fudgeFactor = 0.5;
BWs = edge(BW,'sobel',threshold * fudgeFactor);
imshow(BWs)
title('Binary Gradient Mask')
% dilate
 se90 = strel('line',3,90);
 se0 = strel('line',3,0);
 BWsdil = imdilate(BWs,[se90 se0]);
 imshow(BWsdil)
 title('Dilated Gradient Mask')
 
% Fill the holes
BWdfill = imfill(BWsdil,26,'holes');
imshow(BWdfill)
title('Binary Image with Filled Holes')

 seD = strel('line',1, 0);
 BWfinal = imerode(BWdfill,seD);
 BWfinal = imerode(BWfinal,seD);
 imshow(BWfinal)
 title('Segmented Image');
 
 BWfinal = lowpass(BWfinal,0.1);


C = corner(BWfinal);
imshow(I)
hold on
plot(C(:,1),C(:,2),'r*');






% Visualize in original image
% imshow(labeloverlay(I,BWfinal))
% title('Mask Over Original Image')