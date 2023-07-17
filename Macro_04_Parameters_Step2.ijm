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

runMacro("C:/Users/bdeha/Projects/BDWorkshop_Fiji-DividingCells/CloseAll.ijm");

// Define directory path and list content
dir_path = "C:/Users/bdeha/Projects/BDWorkshop_Fiji-DividingCells/data/";
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