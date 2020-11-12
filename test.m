I = imread('eparts2.jpg');

% apply a different scale
J = imresize(I, 0.5);

% apply image noise 
J = imnoise(J,'gaussian');

% rotate image
J = imrotate(J, 65);

% calculate a 16-bin histogram for the image.
[counts,x] = imhist(J,16);
stem(x,counts)

% compute a global threshold using the histogram counts.
T = otsuthresh(counts);

% create a binary image using the computed threshold and display the image.
BW = im2bw(I,T);

% create complementary
BW = imcomplement(BW);

%  fill gap 1
se = strel('rectangle', [2 2]);
BW = imclose(BW,se);

% dilate
seStats = strel('rectangle',[2 2]);
BW = imdilate(BW, seStats);
  
% fill the gap 2   
se = strel('rectangle', [2 2]);
BW = imclose(BW,se);
 
% remove noise regions with less than 20 pixels 
BW = bwareaopen(BW, 20);

% apply canny edge detector 
BW = edge(BW,'Canny');

 
% fill the gap 3   
se = strel('rectangle', [12 12]);
BW = imclose(BW,se);

figure; imshow(BW);
 
% In this section we will label each blob and count the number of blobs 
   CC = bwconncomp(BW);
   L = labelmatrix(CC);
   blobMeasurements = regionprops(L, BW, 'all');
   numberOfBlobs = size(blobMeasurements, 1);

% initiating our for loop, looping through our image blobs and filtering
% only blobs with number of lines between 25 and 16. 
    for k=1 :  numberOfBlobs
       BW1 = (L==k); 
%        figure; imshow(BW1);
      [H,T,R] = hough(BW1);
      P  = houghpeaks(H,100,'threshold',ceil(0.3*max(H(:))));
      linesMeasurements = houghlines(BW1,T,R,P); 
      numberLines = length(linesMeasurements);
      disp(numberLines);
       if numberLines <= 25 && numberLines >= 16
          BW = BW1;
          bb = regionprops(BW, 'BoundingBox');
      end
    end
%   figure; imshow(BW);

 
 
 % find all the blobs.
[labeledImage, numberOfRegions] = bwlabel(BW);
% display the binary image.
% let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
imshow(coloredLabels);
% find bounding boxes
props = regionprops(labeledImage, 'BoundingBox', 'Area');
% place bounding boxes over our component
% display the binary image.
imshow(BW, []);
title('Binary Image with Bounding Boxes', 'FontSize', 14, 'Interpreter', 'None');
hp = impixelinfo;
axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
for k = 1 : length(props)
  thisBB = props(k).BoundingBox;
  fprintf('Blob #%d has a blob area of %.1f and BoundingBox area of %.1f',...
  props(k).Area, thisBB(3)*thisBB(4));
  rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 3);
end

imshow(I, []);
title('Original Image with Bounding Boxes', 'FontSize', 14, 'Interpreter', 'None');
hp = impixelinfo;
axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
for k = 1 : length(props)
  thisBB = props(k).BoundingBox;
  rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 3);
end


  
