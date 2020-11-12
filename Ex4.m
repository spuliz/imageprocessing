I = im2bw(imread('eparts2.jpg'));

imshow(I);

% Get the complementary
I = imcomplement(I)


% Fill holes
 I = imfill(I, 'holes');
imshow(I);

% % Identify individual blobs by seeing which pixels are connected to each other.
% % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
% % Do connected components labeling with either bwlabel() or bwconncomp().
 labeledImage = bwlabel(I);     % Label each blob so we can make measurements of it
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
 
 
% % Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
 blobMeasurements = regionprops(labeledImage, I, 'all');
 numberOfBlobs = size(blobMeasurements, 1);
 
 
 textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
 labelShiftX = -7;	% Used to align the labels in the centers of the coins.
 blobECD = zeros(1, numberOfBlobs);
 
 % Loop over all blobs printing their measurements to the command window.
 for k = 1 : numberOfBlobs           % Loop through all blobs.
 	% Find the mean of each blob.  (R2008a has a better way where you can pass the original image
 	% directly into regionprops.  The way below works for all versions including earlier versions.)
 	thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
 	meanGL = mean(I(thisBlobsPixels)); % Find mean intensity (in original image!)
 	meanGL2008a = blobMeasurements(k).MeanIntensity; % Mean again, but only for version >= R2008a
 	
 	blobArea = blobMeasurements(k).Area;		% Get area.
 	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
 	blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
 	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
 	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
 	% Put the "blob number" labels on the "boundaries" grayscale image.
 	text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
 end
 
 
 % Now I'll demonstrate how to select certain blobs based using the ismember() function.
 % Let's say that we wanted to find only those blobs
 % with an area higher than 800 pixels.
 % This would give us the three brightest dimes (the smaller coin type).
 allBlobAreas = [blobMeasurements.Area];
 % Get a list of the blobs that meet our criteria and we need to keep.
 % These will be logical indices - lists of true or false depending on whether the feature meets the criteria or not.
 % for example [1, 0, 0, 1, 1, 0, 1, .....].  Elements 1, 4, 5, 7, ... are true, others are false.
 allowableAreaIndexes = allBlobAreas > 5500 & allBlobAreas < 6500; % Take the small objects.
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
 title('"Keeper" blobs (2 scissors in a re-labeled image)', 'FontSize', captionFontSize);
 
 
 
 % Now use the keeper blobs as a mask on the original image.
 % This will let us display the original image in the regions of the keeper blobs.
 maskedImageDime = I; % Simply a copy at first.
 maskedImageDime(~keeperBlobsImage) = 0;  % Set all non-keeper pixels to zero.
 subplot(3, 3, 8);
 imshow(maskedImageDime);
 axis image;
 title('Only the 2 scissors from the original image', 'FontSize', captionFontSize);



