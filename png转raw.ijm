



run("Input/Output...", "jpeg=85 gif=-1 file=.csv use use_file save copy_row save_column save_row");
fileDir = getDirectory("path");
allList = getFileList(fileDir);
fileList = newArray();
k = 0;
for(i=0;i<allList.length;i++)
{ if (endsWith(allList[i],".raw") ){
	fileList =Array.concat(fileList,allList[i]);
	k++;
}
else if (endsWith(allList[i],".png") ){
	fileList =Array.concat(fileList,allList[i]);
	k++;
}

}


for(i=0;i<fileList.length;i++)
{open(fileList[i]);

saveAs("Raw data",fileDir+fileList[i]+".raw");
close();

}












