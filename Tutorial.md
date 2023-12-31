# BDWorkshop_Fiji-DividingCells
Learn how to detect dividing cells using Fiji and ImageJ macro

# A - Overview

During cell division, the chromosomes contained in the nuclei are compacted 
before being segregated between the two daughter cells. This phenomenon is 
easily observed under fluorescence microscopy as the DNA staining (e.g. DAPI) 
appears brighter in dividing cells.

In this tutorial, we'll use Fiji's basic commands and the ***ImageJ Macro*** 
language to automatically detect dividing cells in a collection of images.  We 
will first manually execute the procedure and then use the ***macro recorder***
to retrieve the commands needed to assemble a macro. 

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

***Fill holes*** in the segemented objects:
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
add some more advanced features.

## Exercice 1 : Automate the basic procedure
Open the Fiji ***IDE*** (Integrated Development Environment):
- ![Plugins] <sup>></sup> ![New] <sup>></sup> ![Macro]

Gather commands from the macro recorder and recapitulate the above procedure.  
- The macro should:
    1) Open the image 
    2) Create the mask
    3) Perform binary operations
    4) Select objects
    5) Make the measurments 

⚠️ When writing paths within the macro be sure to use slash `/` and not
backslash `\`.  
⚠️ Add this to the of your code to close all windows that could interfere with 
the execution.
```
runMacro(".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm");
```

## Exercice 2 : Detect dividing cells
As we have seen above, nuclei in dividing cell are brighter due to the 
compaction of their chromosomes. We will take advantage of this to property
to automatically detect dividing cells.

We will use a ***for*** loop combined to an ***if*** statement to check 
the mean fluorescence intensity for all segmented objects. If the measured 
intensity is above a given threshold we will draw a rectangle around the object
centroid on the original image. 

Here are some of the code snippets you will need to perform this task:

- Modify your `Set Measurements...` statement to extract object ***centroid*** 
coordinates:
    ```
    run("Set Measurements...", "mean centroid redirect=None decimal=3");
    ```
    - Add ***X*** and ***Y*** columns to the result table

- Get the number of segmented objects by measuring the length of the result 
table:
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

## Exercice 3 : Batch processing

The next step will consists of running the analysis on all images contained in 
the `data` directory. 

### Step 1

We will proceed step by step and first enhance the flexibility of our code by 
managing image names dynamically, using ***variables***, instead of 
hardcoding them directly into our script.

To understand why this is critical, we will open the second image by simply
modifying the opening path.

- Modify image path as follow:
    ```
    open(".../BDWorkshop_Fiji-DividingCells/data/image_02.tif");
    ```

After running the macro we should get the following error : 
`No window with the title "image_01.tif" found`  
This error arises from the fact that deeper in the code we are using a
hardcoded command to select the original image window :
`selectWindow("image_01.tif");`

To get around this problem, we need to store the name of imported images in a 
variable that we will later use to refer to the image.

- Retrieve and store the image name in the `image_name` variable:
    ```
    open(".../BDWorkshop_Fiji-DividingCells-main/data/image_01.tif");
    image_name = getTitle();
    ```
- Later in the code you can replace:
    ```
    selectWindow("image_01.tif");
    ```
    by:
    ```
    selectWindow(image_name);
    ```

- You can now modify the image path to open the second image:
    ```
    open(".../BDWorkshop_Fiji-DividingCells-main/data/image_02.tif");
    ``` 

### Step 2

We will now modify our code to process all images in a single execution. The 
basic principle involves listing the files contained in the `data` directory 
and iterating over this list to successively open and process each image. 
Since, this will imply some new concepts, particularly in terms of file path 
handling, it would be a good practice to start with a new, empty macro.

Create a new macro from Fiji ***IDE***:
- ![File] <sup>></sup> ![New]

Create a ***for*** loop to iterate through the `data` directory content to 
sucessively open all images.

Here are some of the code snippets you will need to perform this task:

- Define `data` directory path:
    ```
    dir_path = ".../BDWorkshop_Fiji-DividingCells-main/data/";
    ```

- List `data` directory files:
    ```
    dir_list = getFileList(dir_path);
    ```

- Retreive the number of files:
    ```
    nFiles = dir_list.length;
    ```

- Create the first image path and display it:
    ```
    image_01_path = dir_path + dir_list[0];
    print(image_01_path);
    ```

### Step 3

Finally, we will now merge our two macros by inserting the detection procedure 
within the for loop we just created. By doing so we will ensure that outputs
from previous iterations do not interfere with the current analysis.

Here are some of the code snippets you will need to perform this task:

- Clear ROI manager:
    ```
	roiManager("Deselect");
	roiManager("Delete");
    ```
- Clear Results:
    ```
	run("Clear Results");
    ```

⚠️ Indexing variable (e.g. `i`) in nested loops must be unique.

## Exercice 4 : Manage parameters

### Step 1

When writing a macro, it is a good idea to make all parameters you would be susceptible to modify easy to access. One way of doing it is to list these
parameters as variables in the top part of the code, and replace their 
associated commands deeper in the code.    

Your exercice here will be to modify your code to create new variables to get:
- `sigma` - Adjustable sigma for Gaussian blur 
- `fillHoles` - Optional fill hole operation (using conditional statement with boolean `true` or `false`)  
- `splitObjects` - Optional watershed operation (using conditional statement with boolean `true` or `false`)
- `minSize` - Adjustable minimum size for filtering out objects 
- `minIntensity` - Adjustable minimum intensity to detect dividing cells 

To do this you will rely on string manipulation/concatenation to make
harcoded commands dynamic.

This is for example how you would insert a number within a string:
```
number = 7
print("There is " + number + " continents")
```
The output should read: `There is 7 continents`

### Step 2
Another level of refinement would be to list adjustable parameters in
a dialog window to avoid users to read the actual code. 

Here is an example for the `sigma` parameter, you can add the others yourself.

Initialize and setup the dialog window:
```
Dialog.create("Options");
sigma = Dialog.addNumber("Sigma for Gaussian blur", 2);
```
Display it:
```
Dialog.show();
```

Retrieve the user inputs:
```
minSize = Dialog.getNumber();
```

-------------------------------------------------------------------------------

<details>
  
<summary>Macro_01_BasicProcedure.ijm</summary>

```
runMacro(".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm"); // close all windows

// Open image:
open(".../BDWorkshop_Fiji-DividingCells-main/data/image_01.tif");

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
runMacro(".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm");

// Open image:
open(".../BDWorkshop_Fiji-DividingCells-main/data/image_01.tif");

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

<details>
  
<summary>Macro_03_BatchProcessing_Step1.ijm</summary>

```
runMacro(".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm");

// Open image:
open(".../BDWorkshop_Fiji-DividingCells-main/data/image_01.tif");
image_name = getTitle(); // Store the image name in a variable

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
run("Set Measurements...", "mean centroid redirect=None decimal=3");
selectWindow(image_name); // Use image_name variable instead of the hard-coded name
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

<details>
  
<summary>Macro_03_BatchProcessing_Step2.ijm</summary>

```
// Data directory path and content
dir_path = ".../BDWorkshop_Fiji-DividingCells-main/data/"; 
dir_list = getFileList(dir_path);

for (i = 0; i < dir_list.length; i++) {
	
	image_path = dir_path + dir_list[i];
	print(image_path); // Display created paths
	open(image_path); // Open images using created paths
	
}
```
</details>

<details>
  
<summary>Macro_03_BatchProcessing_Step3.ijm</summary>

```
runMacro("".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm");

// Define directory path and list content
dir_path = ".../BDWorkshop_Fiji-DividingCells-main/data/";
dir_list = getFileList(dir_path);

// Process all images
for (i = 0; i < dir_list.length; i++) {
	
	// Open image:
	open(dir_path + dir_list[i]);
	image_name = getTitle();
	
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
	run("Set Measurements...", "mean centroid redirect=None decimal=3");
	selectWindow(image_name);
	roiManager("Show All with labels");
	roiManager("Deselect");
	roiManager("Measure");
	
	// Detect dividing cells:
	for (j = 0; j < nResults; j++) { 
		
		mean = getResult("Mean", j);
		x = getResult("X", j);
		y = getResult("Y", j);
		
		// Draw rectangle:
		if (mean > 90) {
			makeRectangle(x-50, y-50, 100, 100);
			run("Draw", "slice");
			
		}
		
	}
	
	// Clean display image:
	run("Remove Overlay");
	run("Select None");
	
	// Clear ROI manager and Results
	roiManager("Deselect");
	roiManager("Delete");
	run("Clear Results");
	
}
```
</details>

<details>
  
<summary>Macro_04_Parameters_Step1.ijm</summary>

```
// Parameters
sigma = 2;
fillHoles = false;
splitObjects = false;
minSize = 300;
minIntensity = 30;

runMacro("".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm");

// Define directory path and list content
dir_path = ".../BDWorkshop_Fiji-DividingCells-main/data/";
dir_list = getFileList(dir_path);

// Process all images
for (i = 0; i < dir_list.length; i++) {
	
	// Open image:
	open(dir_path + dir_list[i]);
	image_name = getTitle();
	
	// Create mask: 
	run("Duplicate...", " ");
	run("Gaussian Blur...", "sigma=" + sigma); // Dynamic parameter
	setAutoThreshold("Otsu dark no-reset");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	
	// Binary operations: 
	if (fillHoles == true) {
		run("Fill Holes");
		} // Conditionnal processing
	if (splitObjects == true) {
		run("Watershed");
		} // Conditionnal processing
	
	// Objects selection:
	run("Analyze Particles...", "size=" + minSize + "-Infinity exclude add"); // Dynamic parameter
	
	// Fluorescence intensities measurements:
	run("Set Measurements...", "mean centroid redirect=None decimal=3");
	selectWindow(image_name);
	roiManager("Show All with labels");
	roiManager("Deselect");
	roiManager("Measure");
	
	// Detect dividing cells:
	for (j = 0; j < nResults; j++) { 
		
		mean = getResult("Mean", j);
		x = getResult("X", j);
		y = getResult("Y", j);
		
		// Draw rectangle:
		if (mean > minIntensity) { // Dynamic parameter
			makeRectangle(x-50, y-50, 100, 100);
			run("Draw", "slice");
			
		}
		
	}
	
	// Clean display image:
	run("Remove Overlay");
	run("Select None");
	
	// Clear ROI manager and Results
	roiManager("Deselect");
	roiManager("Delete");
	run("Clear Results");
	
}
```
</details>

<details>
  
<summary>Macro_04_Parameters_Step2.ijm</summary>

```
// Initialize, setup and show dialog window
Dialog.create("Options"); 
sigma = Dialog.addNumber("Sigma for Gaussian blur", 2);
fillHoles = Dialog.addNumber("Fill holes objects", true);
splitObjects = Dialog.addNumber("Split objects", true);
minSize = Dialog.addNumber("Minimum object size", 300);
minIntensity = Dialog.addNumber("Minimum object intensity", 90);
Dialog.show();

// Retrieve values from the dialog window
minSize = Dialog.getNumber();
fillHoles = Dialog.getNumber();
splitObjects = Dialog.getNumber();
minSize = Dialog.getNumber();
minIntensity = Dialog.getNumber();

runMacro(".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm");

// Define directory path and list content
dir_path = ".../BDWorkshop_Fiji-DividingCells-main/data/";
dir_list = getFileList(dir_path);

// Process all images
for (i = 0; i < dir_list.length; i++) {
	
	// Open image:
	open(dir_path + dir_list[i]);
	image_name = getTitle();
	
	// Create mask: 
	run("Duplicate...", " ");
	run("Gaussian Blur...", "sigma=" + sigma); // Dynamic parameter
	setAutoThreshold("Otsu dark no-reset");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	
	// Binary operations: 
	if (fillHoles == true) {
		run("Fill Holes");
		} // Conditionnal processing
	if (splitObjects == true) {
		run("Watershed");
		} // Conditionnal processing
	
	// Objects selection:
	run("Analyze Particles...", "size=" + minSize + "-Infinity exclude add"); // Dynamic parameter
	
	// Fluorescence intensities measurements:
	run("Set Measurements...", "mean centroid redirect=None decimal=3");
	selectWindow(image_name);
	roiManager("Show All with labels");
	roiManager("Deselect");
	roiManager("Measure");
	
	// Detect dividing cells:
	for (j = 0; j < nResults; j++) { 
		
		mean = getResult("Mean", j);
		x = getResult("X", j);
		y = getResult("Y", j);
		
		// Draw rectangle:
		if (mean > minIntensity) { // Dynamic parameter
			makeRectangle(x-50, y-50, 100, 100);
			run("Draw", "slice");
			
		}
		
	}
	
	// Clean display image:
	run("Remove Overlay");
	run("Select None");
	
	// Clear ROI manager and Results
	roiManager("Deselect");
	roiManager("Delete");
	run("Clear Results");
	
}
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