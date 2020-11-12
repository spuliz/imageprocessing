% read the image
I = imread('eparts2.jpg');
I = rgb2gray(I);

% apply a different scale
J = imresize(I, 0.6);

% apply image noise 
J = imnoise(J,'gaussian');

% rotate image
J = imrotate(J, 15);

% calculate a 16-bin histogram for the image.
[counts,x] = imhist(J,16);
stem(x,counts)

% compute a global threshold using the histogram counts.
T = otsuthresh(counts);

% create a binary image using the computed threshold and display the image.
BW = im2bw(I,T);

% create complementary
BW = imcomplement(BW);

figure; imshow(BW);

% create the skeleton  
BW = bwmorph(BW,'skel',Inf);

figure; imshow(BW);

% we are going to perform dilate and close at 360 degrees to make sure that
% our solution will be rotation invariant
 for i=1:360
      seStats1 = strel('line',2, i);
      BW = imdilate(BW, seStats1);
      seStats2 = strel('line',3, i);
      BW = imclose(BW, seStats2);
 end
 
 figure; imshow(BW);

% thinning the image
BW = bwmorph(BW,'thin',Inf);

% remove noisy regions with less than 20 pixels 
BW = bwareaopen(BW, 20);

figure; imshow(BW);
 
% In this section we will label each blob and count the number of blobs 
CC = bwconncomp(BW);
L = labelmatrix(CC);
blobMeasurements = regionprops(L, BW, 'all');
numberOfBlobs = size(blobMeasurements, 1);

% initiating our for loop, looping through our image blobs and filtering
% only blobs with number of lines equals to 3 
    for k=1 :  numberOfBlobs
       BW1 = (L==k); 
           figure; imshow(BW1);
           [H,T,R] = hough(BW1);
           P  = houghpeaks(H,100,'threshold',ceil(0.4*max(H(:))));
           linesMeasurements = houghlines(BW1,T,R,P); 
           numberLines = length(linesMeasurements);
           disp(numberLines);
            if numberLines == 3
                BW = BW1;
                bb = regionprops(BW, 'BoundingBox');
            end 
    end
   figure; imshow(BW);

 
 
 % find all the blobs.
[labeledImage, numberOfRegions] = bwlabel(BW);
% let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); 
imshow(coloredLabels);
% find bounding boxes
props = regionprops(labeledImage, 'BoundingBox', 'Area');

% place bounding boxes over our component
imshow(BW, []);
hold on;
for k = 1 : length(props)
  thisBB = props(k).BoundingBox;
  rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 3);
end

% place bounding boxes over the orignal image
imshow(I, []); 
hold on;
for k = 1 : length(props)
  thisBB = props(k).BoundingBox;
  rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 3);
end


  
