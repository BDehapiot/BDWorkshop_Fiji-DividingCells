// Open image:
open("C:/Users/bdeha/Projects/BDWorkshop_Fiji-DividingCells/data/image_01.tif");

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
run("Set Measurements...", "mean centroid redirect=None decimal=3"); // add centroid
selectWindow("image_01.tif");
roiManager("Show All with labels");
roiManager("Deselect");
roiManager("Measure");

//
for (i = 0; i < nResults; i++) { 
	
	mean = getResult("Mean", i);
	x = getResult("X", i);
	y = getResult("Y", i);
	
	if (mean > 90) {
		roiManager("Select", i);
		makeRectangle(x-50, y-50, 100, 100);
		run("Draw", "slice");
	}
}
run("Remove Overlay");
run("Select None");

