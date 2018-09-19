NIMS
=====
This Matlab toolbox has been developed to plot and to analyze (nano)indentation data (with conical indenters).
Please, have a look at the full online documentation here: http://nims.readthedocs.org/en/latest/

To get started with the NIMS toolbox, clone the repository, then run Matlab, and cd into the folder containing this README file.

You can start the launcher by typing "demo" at the Matlab command prompt.

Features
--------
This Matlab toolbox has been developed to :

- Plot and Analyze nanoindentation dataset with standard deviation ;

- Coefficient of the power law fit of the load-displacement curve ;

- Energy of the loading (area below the load-displacement curve) ;

- Plot of the Stiffness and the Load/Stiffness² evolution ;

- Young's modulus and Hardness of bulk materials ;

- Young's modulus and Hardness of a thin film on a substrate or on a multilayer sample (3 layers on a substrate) ;

- Generation of a Python script for FEM simulation of indentation test on bulk or multilayer sample with ABAQUS 6.12 to ABAQUS 6.14.

Author
------
:Author: `David Mercier <david9684@gmail.com>`_ [1,2]

[1] `CEA, 17 Avenue des Martyrs, 38000 Grenoble, France <http://www.cea.fr/Pages/le-cea/les-centres-cea/grenoble.aspx>`_

[2] `CRM Group, Avenue du Bois Saint-Jean 21, B27 – Quartier Polytech 4, 4000 Liège, Belgium <http://www.crmgroup.be/>`_


How to cite NIMS in your papers ?
------------------------------------

.. image::
  https://zenodo.org/badge/5888/DavidMercier/NIMS.svg
  :target: http://dx.doi.org/10.5281/zenodo.14610

Reference papers
------------------

* `Mercier D. et al., "Young's modulus measurement of a thin film from experimental nanoindentation performed on multilayer systems" (2010). <https://doi.org/10.1051/mattech/2011029>`_

* `Mercier D., "Behaviour laws of materials used in electrical contacts for « flip chip » technologies.", PhD thesis (2013) <https://tel.archives-ouvertes.fr/tel-01127940>`_

* `Mercier D., "Behaviour laws of materials used in electrical contacts for « flip chip » technologies." PhD defense (2013). <https://doi.org/10.5281/zenodo.11753>`_

* `Mercier D. et al., "Investigation of the fracture of very thin amorphous alumina film during spherical nanoindentation" (2017). <https://doi.org/10.1016/j.tsf.2017.07.040>`_

Acknowledgements
----------------
I acknowledge `Dr. V. Mandrillon <https://www.researchgate.net/profile/Vincent_Mandrillon>`_ from (`CEA <http://www.cea.fr/le-cea/les-centres-cea/grenoble>`_, France (Grenoble))
and to `Dr. M. Verdier <Marc.Verdier@simap.grenoble-inp.fr>`_ from (`SIMaP <http://simap.grenoble-inp.fr>`_, France (Grenoble)), for long discussions and many advices about nanoindentation.

I am grateful to `Dr. Igor Zlotnikov <https://www.researchgate.net/profile/Igor_Zlotnikov>`_ 
(`Max Planck Institute of Colloids and Interfaces <http://www.mpikg.mpg.de/>`_, Germany (Potsdam)), for providing Hysitron example files.

Keywords
--------
Matlab Toolbox ; Graphical User Interface ; Nanoindentation ; Young's modulus ; thin film ; multilayer system ; analytical model ; finite element modelling.

Screenshot
-------------

.. figure:: ./doc/_pictures/GUI_Main_Window_Esample_curve.png
   :scale: 40 %
   :align: center
   
   *Plot of the evolution of the Young's modulus of the sample in function of the indentation depth.*

Links
-----
http://fr.mathworks.com/matlabcentral/fileexchange/43392-davidmercier-nims
