
I = imread('eparts2.jpg');

%  Test our solution on different scale
J = imresize(I, 1);
J = imrotate(J, 0);
J = imnoise(J,'gaussian');

% Resize input image so that number of cols and rows will match the
% original scale of our analysis
% X = size(I, 1);
% Y = size(I, 2);
% rescaledRotatedJ = imresize(J, [X Y]);
% imshow(rescaledRotatedJ);
% J = rescaledRotatedJ;



% Calculate a 16-bin histogram for the image.
[counts,x] = imhist(J,16);
stem(x,counts)

% Compute a global threshold using the histogram counts.
T = otsuthresh(counts);

% Create a binary image using the computed threshold and display the image.
BW = im2bw(J,T);
figure;
imshow(BW);

% Create complementary
BW = imcomplement(BW);
imshow(BW);

% fill gap
 se = strel('disk',1);
 BW = imclose(BW,se);
 imshow(BW)

% remove noise regions with less than 30 pixels 
BW = bwareaopen(BW,20);
imshow(BW)




 % Label each blob so we can make measurements of it
captionFontSize = 14;
labeledImage = bwlabel(BW);    
% % labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
 subplot(3, 3, 4);
 imshow(labeledImage, []);  % Show the gray scale image.
 title('Labeled Image, from bwlabel()', 'FontSize', captionFontSize);
% % Let's assign each blob a different color to visually show the user the distinct blobs.
 coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
% % coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
 subplot(3, 3, 5);
 imshow(coloredLabels);
 axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
 caption = sprintf('Pseudo colored labels, from label2rgb().\nBlobs are numbered from top to bottom, then from left to right.');
 title(caption, 'FontSize', captionFontSize);
 
 [B,L] = bwboundaries(BW, 'noholes');
 
 w = find(bwlabel(BW)==2);
 blob = label2rgb(w);
 disp(blob);
 
 % Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
 blobMeasurements = regionprops(labeledImage, BW, 'all');
 [H,T,R] = hough(BW);
 P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
 linesMeasurements = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7); 
 numberLines = length(linesMeasurements);
 disp(numberLines);
 numberOfBlobs = size(blobMeasurements, 1);
 labelShiftX = -7;	% Used to align the labels in the centers of the blob.
 
  %Get the connected components from the image
  
% Loop over all blobs printing their measurements to the command window.
 for k = 1 : numberOfBlobs           % Loop through all blobs.
%  	thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
%  	blobArea = blobMeasurements(k).Area;		% Get area.
%     blobCentroid = blobMeasurements(k).Centroid; % Get centroid coordinates
%     blobPerimeter = blobMeasurements(k).Perimeter;
%     lines = linesMeasurements(k);
%     numberLines = length(lines);
%     imshow(k);
%     roundness = 4*pi*blobArea/blobPerimeter^2; %Work out the roundness of current connected component
%  	fprintf(1,'#%2d %2d %2d %2d %7.1f\n', k, blobArea, blobPerimeter, roundness, numberLines);
%  	% Put the "blob number" labels on the "boundaries" grayscale image.
%  	text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k),'FontSize', 15, 'FontWeight', 'Bold', 'Color', 'white', 'HorizontalAlignment', 'center');
   imshow(labeledImage, []);
 end
  
 
 
 % Now I'll demonstrate how to select certain blobs based using the ismember() function.
 % Let's say that we wanted to find only those blobs
 % with an area higher than 800 pixels.
 % This would give us the three brightest dimes (the smaller coin type).
 allBlobAreas = [blobMeasurements.Area];
 % Get a list of the blobs that meet our criteria and we need to keep.
 % These will be logical indices - lists of true or false depending on whether the feature meets the criteria or not.
 % for example [1, 0, 0, 1, 1, 0, 1, .....].  Elements 1, 4, 5, 7, ... are true, others are false.
 allowableAreaIndexes = allBlobAreas >= 285 & allBlobAreas < 450; %
 % Now let's get actual indexes, rather than logical indexes, of the  features that meet the criteria.
 % for example [1, 4, 5, 7, .....] to continue using the example from above.
 keeperIndexes = find(allowableAreaIndexes);
 % Extract only those blobs that meet our criteria, and
 % eliminate those blobs that don't meet our criteria.
 % Note how we use ismember() to do this.  Result will be an image - the same as labeledImage but with only the blobs listed in keeperIndexes in it.
 keeperBlobsImage = ismember(labeledImage, keeperIndexes);
 % Re-label with only the keeper blobs kept.
 labeledDimeImage = bwlabel(keeperBlobsImage, 8);     % Label each blob so we can make measurements of it
 % Now we're done.  We have a labeled image of blobs that meet our specified criteria.
 subplot(3, 3, 7);
 imshow(labeledDimeImage, []);
 axis image;
 title('"Keeper" blobs (3 pin component in a re-labeled image)', 'FontSize', captionFontSize);
 
 

%  for k = 1 : length(bb)
%     bb = bb(k).BoundingBox;
%     xBox = [bb(1), bb(1)+bb(3), bb(1)+bb(3), bb(1), bb(1)];
%     yBox = [bb(2), bb(2), bb(2)+bb(4), bb(2)+bb(4), bb(2)];
%     plot(xBox, yBox, 'Color', 'red');
%     hold on;
%  end

 % Now use the keeper blobs as a mask on the original image.
 % This will let us display the original image in the regions of the keeper blobs.
 maskedImageDime = BW; % Simply a copy at first.
 maskedImageDime(~keeperBlobsImage) = 0;  % Set all non-keeper pixels to zero.
 bb = regionprops(maskedImageDime, 'BoundingBox');
 rectangle('Position',[bb.BoundingBox(1),bb.BoundingBox(2),bb.BoundingBox(3), bb.BoundingBox(4)], 'EdgeColor', 'red'); 
 subplot(3, 3, 8);
 imshow(maskedImageDime);
 
 axis image;
 title('Only the 3 pin component from the original image', 'FontSize', captionFontSize);
 
 
 
