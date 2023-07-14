macro "Close All Windows" { 
	while (nImages>0) { 
	selectImage(nImages); 
	close();
	}
	if (isOpen("Log")) {selectWindow("Log"); run("Close");} 
	if (isOpen("Summary")) {selectWindow("Summary"); run("Close");} 
	if (isOpen("Results")) {selectWindow("Results"); run("Close");}
	if (isOpen("ROI Manager")) {selectWindow("ROI Manager"); run("Close");}
	} 