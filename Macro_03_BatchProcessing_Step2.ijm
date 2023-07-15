// Data directory path and content
dir_path = "C:/Users/bdeha/Projects/BDWorkshop_Fiji-DividingCells/data/"; 
dir_list = getFileList(dir_path);

for (i = 0; i < dir_list.length; i++) {
	
	image_path = dir_path + dir_list[i];
	print(image_path); // Display created paths
	open(image_path); // Open images using created paths
	
}
