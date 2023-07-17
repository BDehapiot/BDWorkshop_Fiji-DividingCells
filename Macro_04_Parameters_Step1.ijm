// Parameters
sigma = 2;
fillHoles = false;
splitObjects = false;
minSize = 300;
minIntensity = 30;

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

