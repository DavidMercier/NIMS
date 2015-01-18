Configuration
=============
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \

YAML File
#########

`Visit the YAML website for more informations. <http://www.yaml.org/>`_

`Visit the YAML code for Matlab. <http://code.google.com/p/yamlmatlab/>`_

You need to update the YAML configuration file in order to use Matlab toolbox.

This YAML configuration file provides :
    * indenter's information (geometry and material);
    * and a path on your computer to select easily your data.

How to create your YAML configuration file ?
############################################

A `YAML configuration file <https://github.com/DavidMercier/NIMS/blob/master/YAML_config_files/GUI_config.yaml>`_ is given as an example in the `YAML folder <https://github.com/DavidMercier/nanoind-data-analysis/tree/master/YAML_config_files>`_

.. figure:: ./_pictures/YAML_config_file.png
   :scale: 50 %
   :align: center
   
   *Screenshot of a YAML configuration file.*

Open your YAML config. file and fill it:
    * Write your Indenter_ID(s) (e.g. : Conical indenter, Berk_TB10161_091208, ...);
    * Write indenter's properties (e.g. : Berk_TB10161_091208: [22.233, 437.603, 127.765, -417.878, -84.0989, 0]);
    * Write the (absolute) path for the folder where you store your indentation data.

..  warning::
	* Be careful to put a comma + a space between each data...! (YAML convention)
	* Use # in the beginning of the line to add comments.
	* For user-defined indenters, make the name of the indenter begins with the 4th first letters of the indenter name (e.g.: 'Berk_130214' for 'Berkovich').
	* Do not remove standard indenters