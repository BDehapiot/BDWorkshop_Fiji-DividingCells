runMacro(".../BDWorkshop_Fiji-DividingCells-main/CloseAll.ijm");

// Open image:
open(".../BDWorkshop_Fiji-DividingCells-main/data/image_03.tif");
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