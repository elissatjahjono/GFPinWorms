function results = wormGFPArea(img)

% Reduce noise
X = medfilt2(img);

% Adjust data to span data range.
X = adapthisteq(X);

% Threshold image - global threshold
BW = imbinarize(X);

% Close mask with disk
radius = 1;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imclose(BW, se);

% Open mask with disk
radius = 1;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);

% Input for region filtering
BW_out = BW;

% Filter image based on image properties.
BW_out = bwpropfilt(BW_out,'Area',[1000, 50000]);

% Create masked image
maskedImage = img;
maskedImage(~BW_out) = 0;

% Calculate worm area
nPixWorm = nnz(maskedImage);

% Find the number of area identified in region properties
[~, numRegions] = bwlabel(BW_out);
numRegions;

% Threshold for GFP
BW_GFP = maskedImage > 10000;
BW_GFP_out = bwpropfilt(BW_GFP,'Area',[1000, 50000]);

% Get properties
nPixGFP = nnz(BW_GFP_out);
[~, numRegions_GFP] = bwlabel(BW_GFP_out);
numRegions_GFP;


results.wormarea = nPixWorm;
results.GFParea = nPixGFP;
results.wormnum = numRegions;
results.GFPnum = numRegions_GFP;
results.wormproc = BW_out;
results.GFPproc = BW_GFP_out;
results.GFPinWorms = nPixGFP/nPixWorm;

end