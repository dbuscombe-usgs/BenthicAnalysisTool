%---------------------------------------------------------------
%---------------------------------------------------------------
B.A.T. (Benthic Analysis Tool) version 0.5 (Apr 2012)

Written by Daniel Buscombe
School of Marine Science and Engineering, University of Plymouth, UK
(daniel.buscombe@plymouth.ac.uk)
%---------------------------------------------------------------%---------------------------------------------------------------

%---------------------------------------------------------------
Before you begin:
This is a program written for MATLAB, therefore you need a copy of the software to use this program at all. Please note it is not designed, and will not work, for Octave because of the highly graphical nature of the software.

Please ensure you have the following files in the same directory as the main program, 'bat.m':

1. Substrate_main.txt
This text file contains the main substrate classifcation for the seabed. It should contain each type on a new line, and can be as long as needed. An example is provided, and should be sufficient for most non-specialist needs

2. Substrate_sub.txt
This text file contains the secondary substrate classifcation for the seabed. It should contain each type on a new line, and can be as long as needed. An example is provided, and should be sufficient for most non-specialist needs

3. a navigation file in the .txt format
This text file must be in the in the following format, one row per image:
YYYY/MM/DD HH:MM:SSSS localXcoordinate localYcoordinate altitude(m) depth(m) latitude longitude

Example:
2005/10/18 14:53:5537 366171.5 6387304.8 3.5 784.8 57.60824 -11.23992

Note 'altitude' refers to height above the seabed and is used if the images are geometrically transformed (see below). IMPORTANT: it is assumed that the data in the navigation file are in the same order as the loaded images. An example 'navtest.txt' is provided. This means that images should be named with an increment which makes it easy for matlab to sort them (e.g. 'blahblahblah_1.jpg', 'blahblahblah_2.jpg', etc) and this order should correspond with the order in the navigation file

4. if you will carry out perspective/orthographic transformations on the images, you also need a '.mat' file with a specific structure which has the information necessary to carry out the computations - see separate guide on how to carry out the transformations

Two sub-folders with the names, respectively, 'gui_functions' and 'species_lists' must also exist

1. 'species_lists' must contain a txt file called 'Categories.txt' which lists the main groupings for what will be counted. One category name per line. An example is provided. This is read by the program and used to generate the species lists for counting and identification. 

The program will allow up to 6 main categories. Each category must have a separate txt file with the name of the category, exactly as it is spelt in the 'Categories.txt' listing. Inside each group, you may have as many individual species as required. Examples are provided. 

2. 'gui_functions' - check that all of the following sub-functions are here:

bat_mat2txt.m
bat_figload.m
bat_gui_swopsimages.m
bat_transform.m
bat_labelson.m
bat_length.m
bat_area.m
um1_call.m
bat_gui_substrate.m
bat_gui_substrate2.m
bat_gui_count.m
ax_bdfcn.m
bat_transform_fileload.m
bat_gui_fileload.m
bat_quit.m
imgeomt.m
qinterp2.m
bat_zoombox.m
magnifyOnFigure.m
About.m
zoom_instructions.m
bat_zoominstructions.m
instructions.m
bat_print.m
bat_loadTmatrix.m
popupmessage.m
bat_About.m
bat_Help.m
bat_labelsoff.m
bat_save.m
count_quit.m
maximise.m
zoomfix.m
bat_setaxes.m
text2struct.m

as well as the folder 'export_fig' which contains
export_fig/copyfig.m
export_fig/eps2pdf.m
export_fig/export_fig.m
export_fig/fix_lines.m
export_fig/ghostscript.m
export_fig/isolate_axes.m
export_fig/license.txt
export_fig/pdf2eps.m
export_fig/pdftops.m
export_fig/print2array.m
export_fig/print2eps.m
export_fig/user_string.m


Please do not move these programs. They may be modified but at your own risk!
%---------------------------------------------------------------

If you require transformations on the images, you also need a subfolder 'support functions' with the following files within:

1. geom_convlines.m
2. uct_geomtransform.m


%---------------------------------------------------------------
Brief instructions for use:
%---------------------------------------------------------------

1. Open MATLAB and navigate to this directory, which will be your current working directory (~/BAT_v0.2). This folder can be anywhere on your computer

2. Type 'bat' (without the apostrophes) in the command window to initiate the program

3. Start by loading images into the program (or a previous session, in a '.fig' format, if you have one saved - you then can carry on where you left off). these images can be located anywhere on your computer

4. You will be prompted to load a 'Navigation' file

5. Images can be swapped back and forth freely using the drop-down menu in the bottom right. In other words, you can always come back later and finish the job. 

6. Likewise, substrates can be assigned as many times as you like using the drop-down menu

7. You have the option to apply a perspective transformation to the images. For this, a matrix containing the rectification information must first be generated . For simplicity, and since most calibration grids will be regular geometric objects such as squares, the matrix can be made using the principles of converging lines and vanishing points. This can be generated by running this program: ~/BAT_v0.1/support_functions/uct_geomtransform.m. Make this directory your current MATLAB directory and type 'uct_geomtransform' (without apostrophes) in the command window. You will be asked to select the calibration images and click on the four corners of the calibration grid in the sequence specified. 

IMPORTANT: apply your image transformation BEFORE you start counting and measuring organisms. Once the image is transformed there is no 'untransform' option, although a copy of the untransformed (original) image is displayed in a separate window in order to aid identification

7. Zoom and pan buttons can be used to navigate around the image to find creatures. A right click when in zoom mode will give you more zoom options. If the 'zoom to extent' option does not function correctly, which it sometimes might, click on the 'globe' button on the toolbar which has been designed to fix such issues

8. When a creature has been identified, select it from the appropriate drop-down menu and click on the 'count' button adjacent. The image, zoomed to the extent it is in the main window and in the same position, will be copied onto a new figure for identification. Again, the zoom and pan tools are available in this subwindow. If a mistake is made, a right click will give you the option to delete the points which have just been made.
IMPORTANT: remember that this counting window is specific to the organism selected in the drop-down menu. To count a different creature, a new selection must be made. Only one counting window at a time is allowed. Thus it is best practice to count all of a particular species in one go. Remember you can come back to it later
IMPORTANT: once counts have been made, use the 'file' menu option to close the window. Counted creatures will be copied onto the main window   

9. 'Area' measurements can be made one at a time by clicking the area button. You will be prompted to zoom by drawing a box around the organism (please do this anyway even if it is zoomed in adequately - a single click will cause the area tool to crash). Then it will go into 'drawing' mode - draw around the creature by clicking dots. A right click finishes the drawing, a line is drawn connecting the dots and the area measurement assigned to the counted organism which has the closest coordinates. The program pauses for a second to allow you to view your selection, before the window zooms to extent
IMPORTANT: this area tool should only be used on organisms which have been 'identified' already (i.e. things in the main window which already have a cross on them)

10. The 'length' tool works in a similar way to the 'area' tool described above. Again, the procedure starts with a zoom which must be carried out. Then select two points, both with a left or ordinary click, spanning the object. A line will be drawn between the points, pause, and zoom to extent
IMPORTANT: this length tool should only be used on organisms which have been 'identified' already (i.e. things in the main window which already have a cross on them)

11. There are 2 buttons provided for switching the labels on and off. You may press these as many times as you like. It might be easier to identify objects with the labels turned off. Toggling them off and on every so often assigns the correct 'colours' to the identified objects, but doesn't change any of the data.

12. The 'save' button will save the workspace (figure, plus user-input data) as a .fig file with the current date

13. The 'print' button will print a .tiff image of the current annotated image, minus the buttons and menus. You may do this as many times as you like in one session, and the program will update the figure number accordingly

******************* IMPORTANT ********************************
14. To end a session, AND SAVE YOUR WORK, use the 'File - Quit' menu. This will close the image, save the workspace data to a a matlab data file (with suffix .mat), and save the most important info (i.e. the counts - names, coordinates, areas, and lengths, etc) to a txt file. The filenames for each are constructed using the time you started using the session.
******************* IMPORTANT ********************************

%---------------------------------------------------------------




