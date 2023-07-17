// Written by d.haenni@zmb.uzh.ch and joana.delgadomartins@zmb.uzh.ch 
// February  2020, Bio 407,
//This script was written using Fiji, ImageJ 1.52p.  

// This is a template for processing entire folders
// Also saves the output in a chosen folder.

// Creates a string var. in which the path of the chosen input folder is stored.
inputDir=getDirectory("Select folder containing files to process");

// Creates a string var. in which the path of the chosen output folder is stored.
outputDir=getDirectory("Select an output folder");

// Batch mode allows processing of a macro without displaying images on the screen.
// This accelerates processing by a lot and keeps your screen clean.
setBatchMode(true); // set to true to activate or set to false to stay in displaying mode

// This closes all images that are open.
run("Close All");

// An array variable is created containing all the file names of the files within the input folder.
// An array is list of variables.  
list = getFileList(inputDir);
print("-----The input folder contains "+list.length+" files that will be processed.-----");

/* The following construction repeats (or loops) the part of code within the brackets {}. To make it more 
 recognizable which part of code is repeated the lines are indented.
 It starts with initializing the var. i to zero and repeats as long as the condition i<list.lenth is met.
 i++ is a abbreviated form for writing i=i+1. This operation is done each time that the code 
 within the brackets has been executed. 
To find out how many elements an array has append ".lenth" to the variable name. */ 


for (i=0; i<list.length; i++) {
	// To adress an element of an array use the [] brackets.
	print("The "+ i+1+ "th file is "+list[i]); 
	print("The file path is"+inputDir + list[i]); 
	
	
		// 
		run("Bio-Formats Importer", "open=[" + inputDir + list[i] +"] color_mode=Default open_files open_all_series view=Hyperstack stack_order=XYCZT use_virtual_stack");
		title=getTitle();


		// Enter your code here ///////////
	
	   //waitForUser("test");
	

		// END of inserted code   ///////////

		
		// A new string var is created in order to compose the output path and the file name.
	    saveTitle= outputDir+File.separator+"processed_"+title;
	    print("new file path is "+saveTitle);

	    // The resulting image is saved as a TIF file.
		//saveAs("Tiff", saveTitle);

	   	// Closing the image.
		close();


	

} // this bracket closes the for loop code block


setBatchMode(false);
print ("----------All is done!----------------");

