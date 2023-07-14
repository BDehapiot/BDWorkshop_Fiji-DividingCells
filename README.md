# BDWorkshop_Fiji-DividingCells
Learn how to detect dividing cells using Fiji and ImageJ macro

# A - Overview

During cell division the chromosomes contained in the nuclei compact before
being segregated between the two daughter cells. As a result, the fluo

In this tutorial we will use basic Fiji commands and ImageJ Macro language
to automatically detect these dividing cells. We will first

## 1. Create mask

First, we will create a mask using an automatic thresholding procedure.  

During this process we will keep track of the commands using the
***macro recorder***:  
- ![Plugins] <sup>></sup> ![Macros] <sup>></sup> ![Record...]

Open `image_01.tif` from the `data` directory:   
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

Using the ***Analyse Particles*** menu we will next select objects based on 
their size and position:  
- ![Analyse] <sup>></sup> ![Analyse%20Particles...]
    - Select ***Size*** = 300-Infinity
    - Select ***Exclude on edges***
    - Select ***Add to Manager***

Our objects are now stored as regions of interests in the ***ROI manager***. 

## 4. Fluorescence intensities measurments

The last step will consist of measuring the mean fluorescence intensity on the
original image.

Setup Fiji to measure mean intensities:
- ![Analyse] <sup>></sup> ![Set%20Measurments...]
    - Select only ***Mean gray value*** 

Select the original image and do the following on the ROI manager:
- Display ROIs by selecting ***Show All*** and ***Labels***
- Make sure that no ROIs are selected by clicking ***Deselect***
- Quantify fluorescence by clicking ***Measure***

This should open a ***Results*** window with fluorescence mean intensity for
every ROI.  
You can compare values for normal and dividing cells.

# B - Automation

We will now use ***ImageJ Macro*** language to automate the analysis and also
add advanced features.

## Exercice #1 : Automate the basic procedure
Open the Fiji ***IDE*** (Integrated Development Environment):
- ![Plugins] <sup>></sup> ![New] <sup>></sup> ![Macro]

Gather commands from the macro recorder and recapitulate the above procedure.  
- The macro should:
    1) Open the image 
    2) Create the mask
    3) Perform binary operations
    4) Select objects
    5) Make the measurments 

⚠️ Add this to the of your code to close all windows that could interfere with the execution.
```
run("Close All Windows");
```

## Exercice #2 : Detect dividing cells
As we have seen above, nuclei in dividing cell are brighter due to the 
compaction of their chromosomes. We will take advantage of this to property
to automatically detect dividing cells.

We will use a ***for*** loop combined to an ***if*** statement to check 
the mean fluorescence intensity for all segmented objects. If the measured 
intensity is above a given threshold we will draw a rectangle around the object centroid on the original image. 

Here are some of the code snippets you will need to perform this task:

- Modify your `Set Measurements...` statement to extract object ***centroid*** coordinates:
    ```
    run("Set Measurements...", "mean centroid redirect=None decimal=3");
    ```
    - Add ***X*** and ***Y*** columns to the result table

- Get the number of segmented objects by measuring the length of the result table:
    ```
    n = nResults;
    ```
- Retreive values in the result table:
    ```
    value = getResult(column, idx);
    ```
    - ***column*** - column name (e.g. "Mean")
    - ***idx*** - row index (start at 0)

- Make a rectangle selection:
    ```
    makeRectangle(x, y, width, height);
    ```
    - ***x*** and ***y*** - top left pixel coordinates
    - ***width*** and ***height*** - rectangle size (pixels)

- Draw a selection:
    ```
    run("Draw", "slice");
    ```

- Use an ***if*** statement within a ***for*** loop:
    ```
    for (i = 0; i < nResults ; i++) { 
        if (value > threshold) {
        }
    }
    ```

- Clean the original image at the end:
    ```
    run("Remove Overlay");
    run("Select None");
    ```

## Exercice #3 : Batch processing

The next step will consists in performing the analysis on all images contained 
in the `data` directory. We will proceed step by step and first modify the
code to make it able to handle any image. 

### Step #1

For that we will start by defining a ***dynamic variable*** to handle image 
names. The idea is to just modify the path to the image on the top of the code 
and use this variable to handle the name of the image in the rest of the code. 

- Retrieve and store the image name in the `image_name` variable:
    ```
    open(".../BDWorkshop_Fiji-DividingCells/data/image_01.tif");
    image_name = getTitle();
    ```
- Later in the code you can then replace:
    ```
    selectWindow("image_01.tif");
    ```
    by:
    ```
    selectWindow(image_name);
    ```

- Now you can modify the image path to open the second image:
    ```
    open(".../BDWorkshop_Fiji-DividingCells/data/image_02.tif");
    ``` 

### Step #2




---

<details>
  
<summary>Macro_01_BasicProcedure.ijm</summary>

```
// Open image:
open(".../BDWorkshop_Fiji-DividingCells/data/image_01.tif");

// Segmentation mask: 
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Otsu dark no-reset");
setOption("BlackBackground", true);
run("Convert to Mask");

// Binary operations: 
run("Fill Holes");
run("Watershed");

// Objects selection:
run("Analyze Particles...", "size=300-Infinity exclude add");

// Fluorescence intensities measurements:
run("Set Measurements...", "mean redirect=None decimal=3");
selectWindow("image_01.tif");
roiManager("Show All with labels");
roiManager("Deselect");
roiManager("Measure");
```
</details>

<details>
  
<summary>Macro_02_DividingCells.ijm</summary>

```
// Open image:
open(".../BDWorkshop_Fiji-DividingCells/data/image_01.tif");

// Create mask: 
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Otsu dark no-reset");
setOption("BlackBackground", true);
run("Convert to Mask");

// Binary operations: 
run("Fill Holes");
run("Watershed");

// Objects selection:
run("Analyze Particles...", "size=300-Infinity exclude add");

// Fluorescence intensities measurements:
run("Set Measurements...", "mean centroid redirect=None decimal=3"); // add centroid
selectWindow("image_01.tif");
roiManager("Show All with labels");
roiManager("Deselect");
roiManager("Measure");

// Detect dividing cells:
for (i = 0; i < nResults; i++) { 
	
	mean = getResult("Mean", i);
	x = getResult("X", i);
	y = getResult("Y", i);
	
	// Draw rectangle:
	if (mean > 90) {
		makeRectangle(x-50, y-50, 100, 100);
		run("Draw", "slice");

	}
}

// Clean display image:
run("Remove Overlay");
run("Select None");
```
</details>

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
[New]: https://img.shields.io/badge/New-f0f0f0?style=plastic
[Macro]: https://img.shields.io/badge/Macro-f0f0f0?style=plastic