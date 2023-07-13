inputDir = "C:/Users/bdeha/Desktop/Current/data/"
list = getFileList(inputDir);

//for (i=0; i<list.length; i++) {
for (i=0; i<1; i++) {
	
	// Open images
	open(inputDir + list[i]);
	img_name = getTitle();
	
	// Duplicate image
	run("Duplicate...", " ");
	
	// Process image and thresholding
	run("Gaussian Blur...", "sigma=2");
	run("Threshold...");
	setAutoThreshold("Otsu dark no-reset");
	run("Convert to Mask");
	run("Brightness/Contrast...");
	
	// Rename thresholded image
	rename(replace(img_name, ".tif", "_mask.tif"));
	mask_name = getTitle();
	
	// Binary operations
	run("Fill Holes");
	run("Set Measurements...", "mean redirect=None decimal=3");
	run("Analyze Particles...", "size=300-Infinity pixel exclude add");
	
	
	
//	rename(name + "_mask");
//	mask = getTitle();
//	print(mask);
	
}
