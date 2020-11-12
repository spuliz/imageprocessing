
I = imread('eparts2.jpg');

%  Test our solution on different scale
J = imresize(I, 0.5);
imshow(J);

%Resize input image so that number of cols and rows will match the
% original scale of our analysis
X = size(I, 1);
Y = size(I, 2);
RescaledJ = imresize(J, [X Y]);
imshow(RescaledJ);
J = RescaledJ;

% sharpen
% J = imsharpen(J,'Radius',100,'Amount',1);
% figure, imshow(J);
% title('Sharpened Image');