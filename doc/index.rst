.. Matlab documentation master file, created by
   sphinx-quickstart on Fri Apr 04 20:28:37 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
   
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \
   
NIMS |matlab| toolbox
=====================

How to use the toolbox for indentation data analysis ?

The NIMS toolbox has been developed to plot and to analyze (nano)indentation data (obtained with conical indenters) for bulk material or multilayer sample.

With this Matlab toolbox, it is possible to :
    * plot and correct nanoindentation data;
    * calculate the coefficient of the power law fit of the load-displacement curve;
    * calculate the energy of the loading (area below the load-displacement curve);
    * calculate the Young's modulus and Hardness of bulk materials;
    * calculate the Young's modulus of thin films on a substrate (for a bilayer or a multilayer sample (--> 3 layers on a substrate));
    * generate python script for FEM model with Abaqus 6.12 (cono-spherical indentation of multilayer sample).
   
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
   overview_of_the_toolbox
   examples
   links_ref
   
Contact
=======
:Author: `David Mercier <david9684@gmail.com>`_ [1]

[1] `Max-Planck-Institut für Eisenforschung, 40237 Düsseldorf, Germany <http://www.mpie.de/>`_

Acknowledgements
================
The author is grateful to V. Mandrillon of `CEA Grenoble <http://www.cea.fr/le-cea/les-centres-cea/grenoble>`_.

Keywords
========
|matlab| Toolbox; Graphical User Interface (GUI); Nanoindentation; Young's modulus; thin film; multilayer system; analytical model; finite element modelling
