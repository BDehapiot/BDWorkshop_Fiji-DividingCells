# BDWorkshop_Fiji-DividingCells
Learn how to detect dividing cells using Fiji and ImageJ macro

# A - Overview

During this tutorial we will try to detect dividing cells based on...  
We will first try the procedure manually.

## 1. Segmentation mask

First, we will create a mask using an automatic thresholding procedure.  

During this process we will keep track of the commands using the macro recorder:  
- ![Plugins] <sup>></sup> ![Macros] <sup>></sup> ![Record...]

Open ***image_01.tif*** from the ***data*** directory:   
- ![File] <sup>></sup> ![Open...]

Duplicate the image: 
- ![Image] <sup>></sup> ![Duplicate...]

Filter image using a Gaussian kernel:   
- ![Process] <sup>></sup> ![Filters] <sup>></sup> ![Gaussian%20Blur...]
    - Select ***Sigma*** = 2

Apply threshold:  
- ![Image] <sup>></sup> ![Adjust] <sup>></sup> ![Threshold...]
    - Select ***Otsu*** method
    - Click the ***Apply*** button

We obtain a binary black (0) and white (255) mask.

## 2. Binary operations

We will now apply some binary operations to improve our mask.

Fill holes in the segemented objects:
- ![Process] <sup>></sup> ![Binary] <sup>></sup> ![Fill%20Holes]

Separate touching objects using the ***Watershed*** function:
- ![Process] <sup>></sup> ![Binary] <sup>></sup> ![Watershed]

## 3. Objects selection

Using the ***Analyse Particles*** menu we will next select objects based on their size and position:  
- ![Analyse] <sup>></sup> ![Analyse%20Particles...]
    - Select ***Size*** = 300-Infinity (pixel units)***  
    - Select ***Exclude on edges***
    - Select ***Add to Manager***

Our objects are now stored as regions of interests in the ROI manager. 

## 4. Measure fluorescence intensities

The last step will consist of measuring the mean fluorescence intensity on the original image.

Setup Fiji to measure mean intensities:
- ![Analyse] <sup>></sup> ![Set%20Measurments...]
    - Select only ***Mean gray value*** 

Select the original image and do the following on the ROI manager:
- Display ROIs by selecting ***Show All*** and ***Labels***
- Make sure that no ROIs are selected by clicking ***Deselect***
- Quantify fluorescence by clicking ***Measure***

This should open a ***Results*** window with fluorescence mean intensity for every ROI.  
You can compare values for normal and dividing cells.

# B - Automation

The first step of automation w

```
// Open ***image_01.tif*** from the ***data*** directory:  
open("C:/Users/bdeha/Projects/BDWorkshop_Fiji-DividingCells/data/image_01.tif");

// Duplicate the image:
run("Duplicate...", " ");

// Gaussian Blur: 
run("Gaussian Blur...", "sigma=2");

// Apply threshold:
setAutoThreshold("Otsu dark no-reset");
setOption("BlackBackground", true);
run("Convert to Mask");

// Fill holes:
run("Fill Holes");

// Separate touching objects:
run("Watershed");

// Select objects based on their size and position:
run("Analyze Particles...", "size=300-Infinity pixel exclude add");

// Setup Fiji to measure mean intensities:
run("Set Measurements...", "mean redirect=None decimal=3");

// Get measurments from the original image:
selectWindow("image_01.tif");
roiManager("Show All with labels");
roiManager("Deselect");
roiManager("Measure");
```

<!---[ Buttons ]-------------------------------------------------------------->
[Plugins]: https://img.shields.io/badge/Plugins-f0f0f0?style=plastic
[Macros]: https://img.shields.io/badge/Macros-f0f0f0?style=plastic
[Record...]: https://img.shields.io/badge/Record...-f0f0f0?style=plastic
[File]: https://img.shields.io/badge/File-f0f0f0?style=plastic
[Open...]: https://img.shields.io/badge/Open...-f0f0f0?style=plastic
[Image]: https://img.shields.io/badge/Image-f0f0f0?style=plastic
[Duplicate...]: https://img.shields.io/badge/Duplicate...-f0f0f0?style=plastic
[Process]: https://img.shields.io/badge/Process-f0f0f0?style=plastic
[Filters]: https://img.shields.io/badge/Filters-f0f0f0?style=plastic
[Gaussian%20Blur...]: https://img.shields.io/badge/Gaussian%20Blur...-f0f0f0?style=plastic
[Adjust]: https://img.shields.io/badge/Adjust-f0f0f0?style=plastic
[Threshold...]: https://img.shields.io/badge/Threshold...-f0f0f0?style=plastic
[Binary]: https://img.shields.io/badge/Binary-f0f0f0?style=plastic
[Fill%20Holes]: https://img.shields.io/badge/Fill%20Holes-f0f0f0?style=plastic
[Watershed]: https://img.shields.io/badge/Watershed-f0f0f0?style=plastic
[Analyse]: https://img.shields.io/badge/Analyse-f0f0f0?style=plastic
[Analyse%20Particles...]: https://img.shields.io/badge/Analyse%20Particles...-f0f0f0?style=plastic
[Set%20Measurments...]: https://img.shields.io/badge/Set%20Measurments...-f0f0f0?style=plastic