.. Matlab documentation master file, created by
   sphinx-quickstart on Fri Apr 04 20:28:37 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
   
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \
   
NIMS |matlab| toolbox
=====================

The NIMS toolbox has been developed to plot and to analyze (nano)indentation data (obtained with conical indenters) for bulk material or multilayer sample.

With this Matlab toolbox, it is possible to :
    * plot and correct nanoindentation data;
    * calculate the coefficient of the power law fit of the load-displacement curve;
    * calculate the energy of the loading (area below the load-displacement curve);
    * calculate the Young's modulus and hardness of bulk materials;
    * calculate the Young's modulus of thin films on a substrate (for a bilayer or a multilayer sample (until 3 layers on a substrate));
    * generate python script of axisymmetrical FEM model for use in Abaqus 6.12 (cono-spherical indentation of multilayer sample).
	
.. figure:: ./_pictures/download.png
   :scale: 20 %
   :align: left
   :target: https://github.com/DavidMercier/NIMS

`Source code is hosted at Github <https://github.com/DavidMercier/NIMS>`_.

.. figure:: ./_pictures/normal_folder.png
   :scale: 4 %
   :align: left
   :target: https://github.com/DavidMercier/NIMS/archive/master.zip
   
`Download source code as a .zip file <https://github.com/DavidMercier/NIMS/archive/master.zip>`_.

.. figure:: ./_pictures/normal_folder.png
   :scale: 4 %
   :align: left
   :target: https://media.readthedocs.org/pdf/nims/latest/nims.pdf
   
`Download the documentation as a pdf file <https://media.readthedocs.org/pdf/nims/latest/nims.pdf>`_.
   
.. figure:: ./_pictures/GUI_Main_Window_Efilm_curve.png
   :scale: 50 %
   :align: center
   
   *Screenshot of the main window of the NIMS toolbox.*

Contents
========
   
.. toctree::
   :maxdepth: 3
   
   getting_started
   configuration
   models
   examples
   links_ref
   
Contact
=======

:Author: `David Mercier <david9684@gmail.com>`_ [1]

[1] `Max-Planck-Institut für Eisenforschung, 40237 Düsseldorf, Germany <http://www.mpie.de/>`_

Acknowledgements
================
The author is grateful to V. Mandrillon from `CEA Grenoble <http://www.cea.fr/le-cea/les-centres-cea/grenoble>`_ and to M. Verdier from `SIMaP <http://simap.grenoble-inp.fr/>`_

Keywords
========
|matlab| toolbox; nanoindentation ; Young's modulus ; hardness ; thin film ; multilayer system ; analytical model ; python script ; finite element modelling.
