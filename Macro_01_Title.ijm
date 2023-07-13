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

