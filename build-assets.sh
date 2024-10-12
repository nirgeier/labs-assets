#!/bin/bash

# Set the base url for this repository (GitHub)
BASE_URL="https://github.com/nirgeier/labs-assets/blob/main"
PUBLIC_BASE_URL="https://raw.githubusercontent.com/nirgeier/labs-assets/main"

# Generate the images preview file
cp assets/templates/images-preview.md assets/README.md             

# Loop over the assets folder and create images preview
for asset in `find assets/images -type f -name "*"`
do
    echo "Creating preview for $asset"
    
    # Create the image preview
    magick "$asset" -resize 50x50 "assets/preview/$(basename $asset).png"

    # Update the images preview file
    imgUrl=$PUBLIC_BASE_URL/$asset
    previewUrl=$BASE_URL/assets/preview/$(basename $asset).png
    echo "|$(basename $asset)|$imgUrl| ![]($previewUrl)|" >> assets/README.md    
done;

# Copy the images preview file to the main folder as well
cp  assets/README.md     README.md    



