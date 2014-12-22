Models
======
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \

Nanoindentation test
--------------------

The following part is about extraction of mechanical properties of material from indentation experiments with conical indenters.

Conical indenters
------------------

Load-Displacement curves
------------------------

An schematic of the load-displacement curve obtained from nanoindentation experiment is given Figure 1.
The applied load :math:`F_\text{c}` is plotted in function of the indentation depth :math:`h`.
The evolution of this curve depends on material properties of the sample and the indenter, and of the indenter's geometry.

.. figure:: ./_pictures/load-disp_curve.png
   :scale: 50 %
   :align: center
   
   *Figure 1 : Schematic of indentation load-displacement curve.*

Indentation contact topography
-------------------------------

The indentation total depth is rarely equal to the indentation contact depth.
Two kind of topography can occur: the pile-up (indentation contact depth > indentation total depth) or the sink-in (indentation contact depth < indentation total depth) (see Figure 2).

The flow of material below the indenter is function of mechanical properties of the material.
Pile-up occurs when work-hardening coefficient is low (< 0.3) or if the ratio yield stress over Young's modulus is less than 1%.

.. figure:: ./_pictures/contact_topography.png
   :scale: 50 %
   :align: center
   
   *Figure 2 : Schematic of indentation contact topography : a) « pile-up » and b) « sink-in ».*
   
Three models were developed to take into account this indentation contact topography.

Model of Doerner and Nix  :
   
		.. math:: h_\text{c} = h_\text{t} - F/S
				:label: doerner_nix_model
				
Model of Oliver and Pharr :
			
		.. math:: h_\text{c} = h_\text{t} - \epsilon * F/S
				:label: oliver_pharr_model
				
where :math:`\epsilon` is a constant function of the indenter's geometry (0.72 for the Berkovich indenter and 0.75 for paraboloids of revolution).
				
Model of Loubet et al. :
				
		.. math:: h_\text{c} = \alpha * (h_\text{t} - F/S)
				:label: loubet_model

where :math:`\alpha` is a constant function of the indented material (usually around 1.2).
			

Extraction of elastic properties
--------------------------------

Elastic properties of bulk material
+++++++++++++++++++++++++++++++++++

Elastic properties of a thin film on a substrate
+++++++++++++++++++++++++++++++++++++++++++++++++

Elastic properties of a thin film on a multilayer system
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. figure:: ./_pictures/multilayer_sample_elastic_model.png
   :scale: 50 %
   :align: center
   
   *Figure 3 : Schematic of elastic multilayer model.*
   
.. figure:: ./_pictures/multilayer_sample_methodology.png
   :scale: 50 %
   :align: center
   
   *Figure 4 : Experimental process to apply for elastic multilayer model.*

Corrections to apply for thin film indentation
+++++++++++++++++++++++++++++++++++++++++++++++

	.. math:: t_\text{eff} = t - h_\text{c}/3
			:label: thickness_correction

.. figure:: ./_pictures/thickness_correction.png
   :scale: 50 %
   :align: center
   
   *Figure 5 : Indentation penetration of a thin film on a sample.*

Extraction of plastic properties
--------------------------------

	.. math:: H = F_\text{c,max}/A_\text{c}
			:label: hardness
			
References
----------