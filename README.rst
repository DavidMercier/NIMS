NIMS
=====
This Matlab toolbox has been developed to plot and to analyze (nano)indentation data (with conical indenters).
Please, have a look to the full documentation here: http://nims.readthedocs.org/en/latest/

To get started with NIMS, clone the repository, then run Matlab, and cd into the folder containing this README file.

You can start the launcher by typing "demo" at the Matlab command prompt.

Features
--------
This Matlab toolbox has been developed to :

- Plot and Analyze nanoindentation dataset;

- Coefficient of the power law fit of the load-displacement curve;

- Energy of the loading (area below the load-displacement curve);

- Young's modulus and Hardness of bulk materials;

- Young's modulus of thin films on a substrate (for a bilayer or a multilayer sample (3 layers on a substrate));

- Generate Python script for FEM simulation of indentation test on multilayer sample with ABAQUS 6.12.

Author
------
Written by D. Mercier [1].

[1] Max-Planck-Institut für Eisenforschung, 40237 Düsseldorf, Germany (http://www.mpie.de/)

How to cite NIMS in your papers ?
------------------------------------

.. image::
  https://zenodo.org/badge/5888/DavidMercier/NIMS.svg
  :target: http://dx.doi.org/10.5281/zenodo.14610

Reference papers
------------------

* `Mercier D. et al., "Young's modulus measurement of a thin film from experimental nanoindentation performed on multilayer systems" (2010). <http://dx.doi.org/10.1051/mattech/2011029>`_

* `Mercier D., "Behaviour laws of materials used in electrical contacts for « flip chip » technologies" (2013). <http://www.theses.fr/2013GRENI083>`_

Acknowledgements
----------------
The author is grateful to V. Mandrillon from CEA Grenoble and to M. Verdier from SIMaP.

CEA: http://www.cea.fr/le-cea/les-centres-cea/grenoble

SIMaP: http://simap.grenoble-inp.fr

Keywords
--------
Matlab Toolbox ; Graphical User Interface ; Nanoindentation ; Young's modulus ; thin film ; multilayer system ; analytical model ; finite element modelling.

Screenshots
-------------

.. figure:: ./_pictures/GUI_Main_Window_Esample_curve.png
   :scale: 40 %
   :align: center
   
   *Plot of the evolution of the Young's modulus of the sample in function of the indentation depth.*

Links
-----
http://fr.mathworks.com/matlabcentral/fileexchange/43392-davidmercier-nims
