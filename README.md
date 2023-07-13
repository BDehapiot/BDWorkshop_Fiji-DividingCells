# BDWorkshop_Fiji-DividingCells
Learn how to detect dividing cells using Fiji and ImageJ macro

# A - Overview

During this tutorial we will try to detect dividing cells based on...  
We will first try the procedure manually.

## 1. Segmentation mask

First, we will create a mask using an automatic thresholding procedure.  

During this process we will keep track of the commands using the macro recorder:  
- `Plugins` > `Macros` > `Record...`

- ![Static Badge](https://img.shields.io/badge/%20Plugins%20-%20blue?color=rgb(100%2C%20100%2C%20100)) > ![Static Badge](https://img.shields.io/badge/%20Macros%20-%20blue?color=rgb(100%2C%20100%2C%20100)) > ![Static Badge](https://img.shields.io/badge/%20Record%20-%20blue?color=rgb(100%2C%20100%2C%20100)) 



Open a nuclei image from the `data` directory:   
- `File` > `Open...`

Duplicate the image: 
- `Image` > `Duplicate...`

Filter image using a Gaussian kernel:   
- `Process` > `Filters` > `Gaussian Blur...`
    - Select `Sigma` = 2

Open the Threshold menu:  
- `Image` > `Adjust` > `Threshold...`
    - Select `Otsu` method
    - Click the `Apply` button

We obtain a binary black (0) and white (255) mask.

## 2. Binary operations

We will now apply some binary operations to improve our mask.

Fill holes in the segemented objects:
- `Process` > `Binary` > `Fill Holes`

Separate touching objects using the `Watershed` function:
- `Process` > `Binary` > `Watershed`

## 3. Objects selection

Using the `Analyse Particles` menu we will next select objects based on their size and position:  
- `Analyse` > `Analyse Particles...`
    - Select `Size` = 300-Infinity (pixel units)`  
    - Select `Exclude on edges`
    - Select `Add to Manager`

Our objects are now stored as regions of interests in the ROI manager. 

## 4. Measure fluorescence intensities

The last step will consist of measuring the mean fluorescence intensity on the original image.

Setup Fiji to measure mean fluorescence intensities:
- `Analyse` > `Set Measurments...`
    - Select only `Mean gray value` 

Select the original image and do the following on the ROI manager:
- Display ROIs by selecting `Show All` and `Labels`
- Make sure that no ROIs are selected by clicking `Deselect`
- Quantify fluorescence by clicking `Measure`

This should open a `Results` window with fluorescence mean intensity for every ROI.  
You can compare values for normal and dividing cells.

# B - Automation

The first step of automation w



