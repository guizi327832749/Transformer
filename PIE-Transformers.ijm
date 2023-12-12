// Design for raw bmp png transfor to other type. 
// if you has any question can mail to Ray.Lei@ovt.com
// 1.Copy the "PIE-Transformers.ijm" file to your imagej file path like: "C:\Program Files\imageJ\macros\"
// 2.Open imageJ->Plugins->Install===>"PIE-Transformers.ijm"
// 3.Enjoy it XD



Dialog.create("OOC-PIE Transformers");
//create Radiobuttons select input image type
inputImageTypeList = newArray("__________raw__________","__________png__________","__________bmp__________");

Dialog.setInsets(100, 0, 0)
Dialog.addRadioButtonGroup("Input_image_type:",inputImageTypeList,1,3,inputImageTypeList[0])
Dialog.setInsets(10, 0, 0) 
rawList = newArray("8-bit","16-bit Signed","16-bit Unsigned")
Dialog.addChoice("rawBits:",rawList,rawList[2])


Dialog.addNumber("row", 400, 0, 4, "pixels")
Dialog.addNumber("column", 400, 0, 4, "pixels")


appList = newArray("Automatic","8-bit (0-255)","10-bit (0-1023)","12-bit (0-4095)","14-bit (0-16383)","15-bit (0-32767)","16-bit (0-65535)")
Dialog.addChoice("Appearance:",appList,appList[2])


//func need crop?
Dialog.addCheckbox("Need Crop?","false");
Dialog.addNumber("Start_X", 0, 0, 4, "pixels")
Dialog.addToSameRow()
Dialog.addNumber("Start_Y", 0, 0, 4, "pixels")
Dialog.addToSameRow()
Dialog.addNumber("[Width]", 0, 0, 4, "pixels")
Dialog.addToSameRow()
Dialog.addNumber("[Height]", 0, 0, 4, "pixels")

//need bandpass filter
Dialog.addCheckbox("Need Enhance?","false");

Dialog.addNumber("Large:", 40, 0, 4, "pixels")
//Dialog.addToSameRow()
Dialog.addNumber("Small:", 5, 0, 4, "pixels")
suppressList = newArray("None","Horizontal","Vertical")
Dialog.addChoice("Suppress:",suppressList,suppressList[0])
//Dialog.addToSameRow()
Dialog.addNumber("Tolerance:", 5, 0, 4, "%")
Dialog.addMessage("Enhance use  [Process-> FFT-> Bandpass Filter]  Function, you can get more detail infos in it.",12,"#ff0000")

//create Radiobuttons select output image type
outputImageTpyeList = newArray("__________png(8-bit)__________","__________png(16-bit)__________","__________bmp__________");

Dialog.setInsets(100, 0, 0)
Dialog.addRadioButtonGroup("Output image type:",outputImageTpyeList,1,2,outputImageTpyeList[0])


Dialog.show();

inputType = Dialog.getRadioButton
rawBits = Dialog.getChoice
appearanceBits = Dialog.getChoice 
rawRow = Dialog.getNumber
rawColumn = Dialog.getNumber

cropFlag = Dialog.getCheckbox

x = Dialog.getNumber
y = Dialog.getNumber
w = Dialog.getNumber
h = Dialog.getNumber
enhanceFlag = Dialog.getCheckbox
large = Dialog.getNumber
small = Dialog.getNumber
suppress = Dialog.getChoice
tolerance = Dialog.getNumber
saveType = Dialog.getRadioButton


// print("inputType:" +inputType )
// print("rawbits:" +rawBits)

// print("appenrancebits:" +appearanceBits)
// print("inputrow:" + rawRow)
// print("inputcolumn:" + rawColumn)
// print("cropFlag:" + cropFlag)
// print("enhanceFlag:" + enhanceFlag)
// print("cropx:" + x)
// print("cropy:" + y)
// print("cropw:" + w)
// print("croph:" + h)

// print("large:" + large)
// print("small:" + small)
// print("suppress:" + suppress)
// print("tolerance:" + tolerance)
// print("savetype:" + saveType)






fileDir = getDirectory("path");
allList = getFileList(fileDir);
fileList = newArray();
k = 0;
for(i=0;i<allList.length;i++)
{ if (endsWith(allList[i],".raw") && inputType == "__________raw__________"){
	fileList =Array.concat(fileList,allList[i]);
	k++;
}
else if (endsWith(allList[i],".png") && inputType == "__________png__________"){
	fileList =Array.concat(fileList,allList[i]);
	k++;
}
else if (endsWith(allList[i],".bmp") && inputType == "__________bmp__________"){
	fileList =Array.concat(fileList,allList[i]);
	k++;
}
}


for(i=0;i<fileList.length;i++)
{//step1:open your file 
	  if(inputType == "__________raw__________")
	{   //print(fileDir+fileList[i]);
		run("Raw...", "open=[" + fileDir + fileList[i] + "] image=[" + rawBits + "] width=" + rawRow +" height=" + rawColumn + " number=1 little-endian");	
	}
	else if(inputType == "__________png__________")
	{   open(fileDir+fileList[i]);
	}
	else if(inputType == "__________bmp__________")
	{	open(fileDir+fileList[i]);
	}
//appearance the photo follow your setting
	wait(100);
	if (appearanceBits=="Automatic")
	{	run("Appearance...", "  menu=15 gui=1 16-bit=Automatic");
		run("Grays");
	}
	else if(appearanceBits == appList[1])
	{	call("ij.ImagePlus.setDefault16bitRange", 8);
		run("Appearance...", "  menu=15 gui=1 16-bit=[8-bit (0-255)]");
		run("Grays");
	}
	else if(appearanceBits == appList[2])
	{	call("ij.ImagePlus.setDefault16bitRange", 10);
		run("Appearance...", "  menu=15 gui=1 16-bit=[10-bit (0-1023)]");
		run("Grays");
	}

	else if(appearanceBits == appList[3])
	{	call("ij.ImagePlus.setDefault16bitRange", 12);
		run("Appearance...", "  menu=15 gui=1 16-bit=[12-bit (0-4095)]");
		run("Grays");
	}

	else if(appearanceBits == appList[4])
	{	call("ij.ImagePlus.setDefault16bitRange", 14);
		run("Appearance...", "  menu=15 gui=1 16-bit=[14-bit (0-16383)]");
		run("Grays");
	}

	else if(appearanceBits == appList[5])
	{	call("ij.ImagePlus.setDefault16bitRange", 15);
		run("Appearance...", "  menu=15 gui=1 16-bit=[15-bit (0-32767)]");
		run("Grays");
	}

	else if(appearanceBits == appList[6])
	{	call("ij.ImagePlus.setDefault16bitRange", 16);
		run("Appearance...", "  menu=15 gui=1 16-bit=[16-bit (0-65535)]");
		run("Grays");
	}
//crop your file and save the result
	if(cropFlag == 1)
    {
		wait(100);
		makeRectangle(x, y, w, h);
		run("Crop");
		saveAs("Jpeg",fileDir+fileList[i]+"_Crop");
    }

//output all photo follow user setting
    	if(saveType == "__________png(8-bit)__________")
	{
		wait(100);
		run("8-bit");
		saveAs("PNG",fileDir+fileList[i]+"_8-bit");
		if (enhanceFlag == 0)
		{close();}

	}
	else if(saveType == "__________png(16-bit)__________"){

		wait(100);
		run("16-bit");
		saveAs("PNG",fileDir+fileList[i]+"_16-bit");
		if (enhanceFlag == 0)
		{close();}
		
	}
	else if(saveType == "__________bmp__________"){

		wait(100);
		saveAs("BMP",fileDir+fileList[i]+"_bmp");
		if (enhanceFlag == 0)
		{close();}
		
	}
//enhance your file and save the result
//enhance your file and save the result
    if(enhanceFlag == 1)
    {
		run("Bandpass Filter...", "filter_large=" + large + " filter_small=" + small +" suppress=" + suppress +" tolerance=" + tolerance +" autoscale saturate");
		wait(100);
		saveAs("Jpeg",fileDir+fileList[i]+"_Enhance");
		close();
    }
}
//show a messagebox about finished!
    Toturials = "<html>"
     +"<h1>!!!Transfomers!!!</h1>"
     +"This marco design for easily change your photo format by batch<br>"
     +"you should know your file type/bits/pixel size...<br>"
     +"you can crop with rect,you can enhance your file with <i>[FFT->bandpass filter]</i><br>"
	 +"if you has any problem, you can send a message to <font color=blue>327832749@qq.com</font>";
  Dialog.create("Congratulations");
  Dialog.addMessage("All process have been finished,please check your results in below links:")
  Dialog.addMessage(fileDir)
  Dialog.addHelp(Toturials);
  Dialog.show












