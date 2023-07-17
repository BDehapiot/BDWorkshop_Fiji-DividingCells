// Written by d.haenni@zmb.uzh.ch and joana.delgadomartins@zmb.uzh.ch 
// February  2020, Bio 407,
//This script was written using Fiji, ImageJ 1.52t.  

// This is a template for processing entire folders
// Also saves the output in a chosen folder.

setBatchMode(true);

inputDir=getDirectory("Select folder containing files to process");
outputDir=getDirectory("Select an output folder");

list = getFileList(inputDir);
print("-----The input folder contains "+list.length+" files that will be processed.-----");

for (i=0; i<list.length; i++) {

		run("Bio-Formats Importer", "open=[" + inputDir + list[i] + "] color_mode=Default open_files open_all_series view=Hyperstack stack_order=XYCZT use_virtual_stack");
		title=getTitle();

		// Enter your code here ///////////

//Here we choose the LUTs for the image
run("Red Hot");

//Here you adjust automatically Brightness/Contrast
//Uncomment following line if you would like to automatically adjust B&C.
//run("Enhance Contrast", "saturated=0.35");

//Here you set defined B&C values
//run("Brightness/Contrast...");
setMinAndMax(230, 10000);


run("RGB Color");


run("Duplicate...", " ");
title2=getTitle();

//Here you add the scale bar
run("Scale Bar...", "width=50 height=16 font=56 color=White background=None location=[Lower Right] bold");

		// END of inserted code   ///////////
		
		
		//Saving first image
		
		selectWindow(title);
	    saveTitle= outputDir+File.separator+"noscalebar_"+title;
	    print("new file path is "+saveTitle);
	
		saveAs("Tiff", saveTitle);
		
		close();

		//Saving second image

		selectWindow(title2);
	    saveTitle= outputDir+File.separator+"withscalebar_"+title;
	    print("new file path is "+saveTitle);
	
		saveAs("Tiff", saveTitle);
		
		close();

} 


setBatchMode(false);
print ("----------All is done!----------------");

