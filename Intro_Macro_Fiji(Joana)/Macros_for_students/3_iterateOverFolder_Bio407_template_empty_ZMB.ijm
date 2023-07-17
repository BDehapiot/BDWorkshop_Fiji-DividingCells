// Written by d.haenni@zmb.uzh.ch and joana.delgadomartins@zmb.uzh.ch 
// February  2020, Bio 407,
//This script was written using Fiji, ImageJ 1.52p.  
 
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
	
		// END of inserted code   ///////////
		
	    saveTitle= outputDir+File.separator+"_processed_"+title;
	    print("new file path is "+saveTitle);
	
		saveAs("Tiff", saveTitle);
		close();

} 


setBatchMode(false);
print ("----------All is done!----------------");

