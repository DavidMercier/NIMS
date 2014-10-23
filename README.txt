Copyright 2014 MERCIER David

This Matlab toolbox has been developed to plot and to analyze (nano)indentation data (with conical indenters).
Please, have a look to the full documentation here: http://nims.readthedocs.org/en/latest/

First, unzip the downloaded file and follow the instructions :

1) Update the YAML configuration file (in the YAML folder) and write in this file the properties
of your indenters and the search path.

2) Run into Matlab the script : GUI_Extraction_EP_properties_for_multilayer_sample.m

3) Answer "yes" to the 1st question in the Command Window of Matlab,
in order to add the above folder with subfolders to the matlab search path.

4) The main Window of the GUI is now opened. Import your data (.txt or .xls).
See examples files given in the folder "Data_indentation" for the accepted format.
Only the loading part of your (nano)indentation results !

Units : Displacement (nm) / Load (mN) / Stiffness (N/m)
- 3 columns : Displacement/Load/Stiffness
- 6 columns : Disp./SD of Disp./Load/SD of Load/Stiff./SD of Stiff. (SD for Standard Deviation)
For .xls files : It is possible to import a 'Sample' sheet obtained
from MTS software - Analyst (with a 'Hold Segment Type')

5) Set the minimum and maximum depths, then set the CSM correction.

6) Choose the appropriate indenter and set if needed the function area.

7) Set the number of thin films (1 to 3) deposited on your substrate (bulk material).

8) Then, set thin films properties

9) Select corrections to apply to your data and the model to use for contact displacement calculation.

10) Select the parameter to plot in x and y axis

11) If you select for y axis the Young's modulus, you can select the analytical multi- or bilayer elastic model
to use for the calculation of the Young's modulus of the thin film.
It is possible to correct the thickness of the top thin film by applying the model of Mencik.
Extracted values obtained by solving the nonlinear curve-fitting (data-fitting) problem in least-squares sense,
are given in the corresponding text box (thin films properties) or in the plot title.

12) It is possible to plot residuals from the least mean square fitting,
to get values from the plot or to plot in a logarithmic scale.

13) Energy (area under the load-displacement curve) and coefficient of the power law fit of the load-displacement curve, 
are given for the plot of load vs. displacement.

14) Results can be stored in a YAML file and a picture (.png format) of the figure are saved
(in same the folder as the folder where the indentation data are stored),
by pressing the button 'Save', when Young's modulus calculation is performed.

15) Finally, press the button FEM to generate a Python script to model indentation of multilayer sample with Abaqus. 

Format of the name of the YAML file : 'data_name / multi- or bilayer model / .yaml'

Format of the name of the .png picture : 'data_name / multi- or bilayer model / .yaml.png'

%% Links %%

Matlab Central : http://www.mathworks.fr/matlabcentral/fileexchange/43392-davidmercier-nanoind-data-analysis

YAML Matlab code : http://code.google.com/p/yamlmatlab/

Official YAML website : http://www.yaml.org/
