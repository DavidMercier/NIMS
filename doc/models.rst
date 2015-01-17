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
   :scale: 60 %
   :align: center
   
   *Figure 1 : Schematic of indentation load-displacement curve.*

Indentation contact topography
-------------------------------

The indentation total depth is rarely equal to the indentation contact depth.
Two kind of topography can occur: the pile-up (indentation contact depth > indentation total depth) or the sink-in (indentation contact depth < indentation total depth) (see Figure 2).

The flow of material below the indenter is function of mechanical properties of the material.
Pile-up occurs when work-hardening coefficient is low (< 0.3) or if the ratio yield stress over Young's modulus is less than 1%.

.. figure:: ./_pictures/contact_topography.png
   :scale: 60 %
   :align: center
   
   *Figure 2 : Schematic of indentation contact topography : a) « pile-up » and b) « sink-in ».*
   
Three models were developed to take into account this indentation contact topography.

Model of Doerner and Nix [#DoernerNix_1986]_ :
   
        .. math:: h_\text{c} = h_\text{t} - {F \over S}
                :label: doerner_nix_model

Model of Oliver and Pharr [#OliverPharr_1992]_ :

        .. math:: h_\text{c} = h_\text{t} - \epsilon {F \over S}
                :label: oliver_pharr_model

where :math:`\epsilon` is a constant function of the indenter's geometry (0.72 for the Berkovich indenter and 0.75 for paraboloids of revolution).

Model of Loubet et al. [#Bec_1996]_ , [#Hochstetter_1999]_ :

        .. math:: h_\text{c} = \alpha (h_\text{t} - {F \over S})
                :label: loubet_model

where :math:`\alpha` is a constant function of the indented material (usually around 1.2).

Extraction of elastic properties
--------------------------------

Elastic properties of bulk material
+++++++++++++++++++++++++++++++++++

    .. math:: E^{*} = {1 \over 2} \sqrt{\pi \over A} {dF \over dh}
            :label: experimental_youngs_modulus
            
    .. math:: {1 \over E^{*}} = {1 \over E^{'}} + {1 \over E_i^{'}}
            :label: youngs_modulus
            
    .. math:: E^{'} = {E \over (1-\nu^{2})}
            :label: reduced_youngs_modulus
			
    .. math:: E_i^{'} = {E_i \over (1-\nu_i^{2})}
            :label: indenter_reduced_youngs_modulus

Elastic properties of a thin film on a substrate
+++++++++++++++++++++++++++++++++++++++++++++++++
          
    .. math:: E^{'} = E^{'}_\text{s} + (E^{'}_\text{f} - E^{'}_\text{s}) \phi(x)
            :label: youngs_modulus_evolution_phi

    .. math:: E^{'} = E^{'}_\text{s} + (E^{'}_\text{f} - E^{'}_\text{s}) \psi(x)
            :label: youngs_modulus_evolution_psi
            
.. note::
    If the difference between Poisson’s ratio of the thin film and substrate is small, the values for uniaxial loading Young's moduli, 
    :math:`E`, :math:`E_f`, :math:`E_s` can be used in previous equation.


Doerner & Nix (1986)
********************

    .. math:: {1 \over E^{'}} = {1 \over E_\text{f}^{'}} + ({1 \over E_\text{s}^{'}} - {1 \over E_\text{f}^{'}}) e^{-\alpha(x)}
            :label: doerner_nix
	
With :math:`x=t/h`.
	
The equation was modified by King (1987), by the replacement of :math:`t/h` by :math:`t/a_c`.

    .. math:: {1 \over E^{'}} = {1 \over E_\text{f}^{'}} + ({1 \over E_\text{s}^{'}} - {1 \over E_\text{f}^{'}}) e^{-\alpha(x)}
            :label: doerner_nix_king

With :math:`x=t/a_c`.
			
Gao et al. (1992)
*****************

    .. math:: E^{'} = E^{'}_\text{s} + (E^{'}_\text{f} - E^{'}_\text{s}) \phi_{Gao_0}(x)
            :label: gao
			
    .. math:: \phi_{Gao_0} = {2 \over \pi} arctan {1 \over x} + {1 \over {2\pi(1-\nu_c)}} [(1-2\nu_c){1 \over x}ln(1 + x^2) - {x \over {1+x^2}}]
            :label: phi_gao_0
			
    .. math:: \nu_{c} = 1 + [{{(1-\nu_{s})(1-\nu_{f})} \over {1-(1-\phi_{Gao_1})\nu_{f}-\phi_{Gao_1}\nu_{s}}}]
			:label: poisson_ratio_composite
			

	.. math:: \phi_{Gao_1} = {2 \over \pi} arctan {1 \over x} + {1 \over {x\pi}}ln(1+x^2)
			:label: phi_gao_1
			
With :math:`x=a_c/t`.

Menčík et al. (linear model) (1997)
***********************************
			
Menčík et al. (exponential model) (1997)
*****************************************

    .. math:: E^{'} = E^{'}_\text{s} + (E^{'}_\text{f} - E^{'}_\text{s}) e^{-\alpha(x)}
            :label: mencik_exponential
			
With :math:`x=a_c/t`.

Menčík et al. (reciprocal exponential model) (1997)
****************************************************

    .. math:: {1 \over E^{'}} = {1 \over E_\text{s}^{'}} + ({1 \over E_\text{f}^{'}} - {1 \over E_\text{s}^{'}}) e^{-\alpha(x)}
            :label: mencik_reciprocal_exponential

With :math:`x=a_c/t`.

Perriot et al. (2003)
*********************

Bec et al. (2006)
*****************

Hay et al. (2011)
*****************

Elastic properties of a thin film on a multilayer system
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Mercier et al. (2010)
*********************

.. figure:: ./_pictures/multilayer_sample_elastic_model.png
   :scale: 30 %
   :align: center
   
   *Figure 3 : Schematic of elastic multilayer model.*
   
.. figure:: ./_pictures/multilayer_sample_methodology.png
   :scale: 30 %
   :align: center
   
   *Figure 4 : Experimental process to apply for elastic multilayer model.*

Corrections to apply for thin film indentation
+++++++++++++++++++++++++++++++++++++++++++++++

    .. math:: t_\text{eff} = t - {h_\text{c} \over 3}
            :label: thickness_correction

.. figure:: ./_pictures/thickness_correction.png
   :scale: 60 %
   :align: center
   
   *Figure 5 : Indentation penetration of a thin film on a sample.*

Extraction of plastic properties
--------------------------------

    .. math:: H = {F_\text{c,max} \over A_\text{c}}
            :label: hardness

References
----------

.. [#DoernerNix_1986] `Doerner M.F. and Nix W.D., "A method for interpreting the data from depth-sensing indentation instruments" (1986). <http://dx.doi.org/10.1557/JMR.1986.0601>`_
.. [#OliverPharr_1992] `Oliver W.C. and Pharr G.M., "An improved technique for determining hardness and elastic modulus using load and displacement sensing indentation experiments" (1992). <http://dx.doi.org/10.1557/JMR.1992.1564>`_
.. [#Bec_1996] `Bec S. et al., "Improvements in the indentation method with a surface force apparatus" (1996). <http://dx.doi.org/10.1080/01418619608239707>`_
.. [#Hochstetter_1999] `Hochstetter G. et al., "Strain-rate effects on hardness of glassy polymers in the nanoscale range. Comparison between quasi-static and continuous stiffness measurements" (1999). <http://dx.doi.org/10.1080/00222349908248131>`_