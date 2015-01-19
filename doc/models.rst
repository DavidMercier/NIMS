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

Loubet et al. founded a good fit to the load-displacement data with a power-law relationship of the form [#Loubet_1986]_ :

        .. math:: F_\text{c} = K h_\text{t}^n
                :label: Loubet_load_displacement

With :math:`K` and :math:`n` constants for a given material for a fixed indenter geometry.

Using the load-displacement curves analysis performed by Loubet et al.,  Hainsworth et al. proposed the following relationship to describe load-displacement curves [#Hainsworth_1996]_ :

        .. math:: F_\text{c} = K h_\text{t}^2
                :label: Hainsworth_load_displacement
                
With :math:`K` a constant function of material properties (Young's modulus and hardness) and the indenter

Indentation contact topography
-------------------------------

The indentation total depth is rarely equal to the indentation contact depth.
Two kind of topography can occur: the pile-up (indentation contact depth > indentation total depth) or the sink-in (indentation contact depth < indentation total depth) (see Figure 2).

The flow of material below the indenter is function of mechanical properties of the material.
Pile-up occurs when work-hardening coefficient is low (< 0.3) or if the ratio yield stress over Young's modulus is less than 1% [#Bolshakov_1998]_, [#Cheng_1998]_ and [#Cheng_2004]_.

.. figure:: ./_pictures/contact_topography.png
   :scale: 60 %
   :align: center
   
   *Figure 2 : Schematic of indentation contact topography : a) « pile-up » and b) « sink-in ».*
   
Three models defining the depth of contact :math:`h_\text{c}` were developed to take into account this indentation contact topography.

Model of Doerner and Nix [#DoernerNix_1986]_ :
   
        .. math:: h_\text{c} = h_\text{t} - {F_\text{c} \over S}
                :label: doerner_nix_model

Model of Oliver and Pharr [#OliverPharr_1992]_ in case of sink-in:

        .. math:: h_\text{c} = h_\text{t} - \epsilon {F_\text{c} \over S}
                :label: oliver_pharr_model

Where :math:`\epsilon` is a constant function of the indenter's geometry (0.72 for the Berkovich indenter and 0.75 for paraboloids of revolution).

Model of Loubet et al. [#Hochstetter_1999]_, [#Bec_2006]_in case of pile-up:

        .. math:: h_\text{c} = \alpha (h_\text{t} - {F_\text{c} \over S})
                :label: loubet_model

Where :math:`\alpha` is a constant function of the indented material (usually around 1.2).

Knowing the depth of contact and the geometry of the indenter, it is possible to determine the area of contact :math:`A_\text{c}` [#OliverPharr_1992]_ and [#OliverPharr_2004]_.

        .. math:: A_\text{c} = C h_\text{c}^2 + \sum_{i=0}^8{C_\text{i} h_\text{c}^{1/2^i}}
                :label: area_function

With the coefficients :math:`C` and :math:`C_\text{i}` obtained by curve fitting procedures, from nanoindentation experiments in fused silica (amorphous and isotropic material).

The first coefficient :math:`C` alone defined a perfect pyramid and is given by the following formulae:

        .. math:: C = \pi a_\text{c}^2 = \pi tan^2(\theta) h_\text{c}^2
                :label: first_coefficient

With :math:`a_\text{c}` the contact radius and :math:`\theta` the equivalent cone angle (70.32° for a Berkovich indenter and 70.2996° for a Vickers indenter).

For a perfect Berkovich indenter :math:`C` is equal to 24.56 and for a perfect Vickers indenter :math:`C` is equal to 24.504.

The second term of the area function :math:`A_\text{c}` describes a paraboloid of revolution, which approximates to a sphere at small penetration depths.
A perfect sphere of radius :math:`R` is defined by the first two terms with :math:`C_0 = -\pi` and :math:`C_1 = 2 \pi R`.
The first two terms also describe a hyperboloid of revolution, a very reasonable shape for a tip-rounded cone or pyramid that approaches
a fixed angle at large distances from the tip.

.. note::
    Only, the first 4th coefficients :math:`C_\text{i}` are used for calculations in this toolbox.
    
Continuous stiffness measurement [#OliverPharr_1992]_
------------------------------------------------------

The "continuous stiffness measurement" technique (CSM) consists to calculate the stiffness continuously during the loading of the indenter.
A small dynamic oscillation is imposed on the force (or displacement) signal and the amplitude and phase of the corresponding displacement (or force) signal are measured using a frequency-specific amplifier.

Extraction of elastic properties
--------------------------------

Elastic properties of bulk material
+++++++++++++++++++++++++++++++++++

    .. math:: E^{*} = \beta {1 \over 2} \sqrt{\pi \over A} {dF_\text{c} \over dh_\text{c}}
            :label: experimental_youngs_modulus

With :math:`\beta` a geometrical correction factor [#King_1987]_ and [#Pharr_1992]_, equal to :
    - 1 for circular indenters (e.g. : conical and spherical indenter);
    - 1.034 for three-sided pyramid indenters (e.g. : Berkovich indenter);
    - 1.012 for four-sided pyramid indenters (e.g. : Vickers indenter).
    
Woirgard has demonstrated analytically that the exact value of  :math:`\beta` for the perfectly sharp Berkovich indenter should be 1.062 [#Troyon_2006]_.

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


Doerner & Nix (1986) [#DoernerNix_1986]_ [#King_1987]_
*******************************************************

    .. math:: {1 \over E^{'}} = {1 \over E_\text{f}^{'}} + ({1 \over E_\text{s}^{'}} - {1 \over E_\text{f}^{'}}) e^{-\alpha(x)}
            :label: doerner_nix

With :math:`x=t/h`.

The equation was modified by King (1987), by the replacement of :math:`t/h` by :math:`t/a_c`.

Gao et al. (1992) [#Gao_1992]_
********************************

    .. math:: E^{'} = E^{'}_\text{s} + (E^{'}_\text{f} - E^{'}_\text{s}) \phi_{Gao_0}(x)
            :label: gao

    .. math:: \phi_{Gao_0} = {2 \over \pi} arctan {1 \over x} + {1 \over {2\pi(1-\nu_c)}} [(1-2\nu_c){1 \over x}ln(1 + x^2) - {x \over {1+x^2}}]
            :label: phi_gao_0

    .. math:: \nu_{c} = 1 + [{{(1-\nu_{s})(1-\nu_{f})} \over {1-(1-\phi_{Gao_1})\nu_{f}-\phi_{Gao_1}\nu_{s}}}]
            :label: poisson_ratio_composite

With :math:`\nu_{s}` the Poisson's ratio of the substrate and :math:`\nu_{f}` the Poisson's ratio of the thin film.

    .. math:: \phi_{Gao_1} = {2 \over \pi} arctan {1 \over x} + {1 \over {x\pi}}ln(1+x^2)
            :label: phi_gao_1

With :math:`x=a_c/t`.

Menčík et al. (linear model) (1997) [#Mencik_1997]_
*******************************************************

    .. math:: E^{'} = E^{'}_\text{f} + (E^{'}_\text{s} - E^{'}_\text{f})(x)
            :label: mencik_linear

With :math:`x=a_c/t`.

Menčík et al. (exponential model) (1997) [#Mencik_1997]_
*********************************************************

    .. math:: E^{'} = E^{'}_\text{s} + (E^{'}_\text{f} - E^{'}_\text{s}) e^{-\alpha(x)}
            :label: mencik_exponential

With :math:`x=a_c/t`.

Menčík et al. (reciprocal exponential model) (1997) [#Mencik_1997]_
**********************************************************************

    .. math:: {1 \over E^{'}} = {1 \over E_\text{s}^{'}} + ({1 \over E_\text{f}^{'}} - {1 \over E_\text{s}^{'}}) e^{-\alpha(x)}
            :label: mencik_reciprocal_exponential

With :math:`x=a_c/t`.

Perriot et al. (2003) [#Perriot_2004]_
***************************************

    .. math:: E^{'} = E^{'}_\text{f} + {{E^{'}_\text{s}-E^{'}_\text{f}} \over 1+({{k_0} \over x})^n}
            :label: perriot_barthel

    .. math:: log(k_0) = -0.093+0.792log({E^{'}_\text{s} \over E^{'}_\text{f}}) + 0.05[log{E^{'}_\text{s} \over E^{'}_\text{f}}]^2
            :label: perriot_barthel_k0

With :math:`x=a_c/t`, and :math:`k_0` and :math:`n` are adjustable constants.

Bec et al. (2006) [#Bec_2006]_
********************************

Hay et al. (2011) [#Hay_2011]_
*******************************


Elastic properties of a thin film on a multilayer system
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Mercier et al. (2010) [#Mercier_2010]_
***************************************

.. figure:: ./_pictures/multilayer_sample_elastic_model.png
   :scale: 30 %
   :align: center
   
   *Figure 3 : Schematic of elastic multilayer model.*
   
.. figure:: ./_pictures/multilayer_sample_methodology.png
   :scale: 30 %
   :align: center
   
   *Figure 4 : Experimental process to apply for elastic multilayer model.*

Corrections to apply for thin film indentation [#Mencik_1997]_, [#Saha_2002]_and [#Bec_2006]_
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

During nanoindentation tests of thin film on substrate, the thickness of the film beneath the indenter is smaller than its original value,
because of plastic flow during loading. The use of the original film thickness :math:`t` in the regression model cause a systematic shift or distortion of the Young's modulus curve.
A correction proposed by Menčík et al. can be apply, assuming a rigid substrate and determining the effective thickness :math:`t_{eff}`.

    .. math:: \pi a^2 t_\text{eff} = \pi a^2 t - V
            :label: general_thickness_correction

With :math:`V` the volume displaced by the indenter and approximated by :math:`\pi a^2 h_\text{c} / 3`, 
for a conical indenter and contact depths :math:`h_\text{c}` smaller than the film thickness.

    .. math:: t_\text{eff} = t - {h_\text{c} \over 3}
            :label: thickness_correction

.. figure:: ./_pictures/thickness_correction.png
   :scale: 60 %
   :align: center
   
   *Figure 5 : Indentation penetration of a thin film on a sample.*

Extraction of plastic properties [#OliverPharr_1992]_
------------------------------------------------------

    .. math:: H = {F_\text{c,max} \over A_\text{c}}
            :label: hardness

References
----------
.. [#Bec_2006] `Bec S. et al., "Improvements in the indentation method with a surface force apparatus" (2006). <http://dx.doi.org/10.1080/01418619608239707>`_
.. [#Bolshakov_1998] `Bolshakov A. and Pharr G.M., "Influences of pile-up on the measurement of mechanical properties by load and depth sensing indentation techniques." (1998) <http://dx.doi.org/10.1557/JMR.1998.0146>`_
.. [#Cheng_1998] `Cheng Y.T. and Cheng C.M. ,"Effects of ‘sinking in’ and ‘piling up’ on estimating the contact area under load in indentation." (1998) <http://dx.doi.org/10.1080/095008398178093>`_
.. [#Cheng_2004] `Cheng Y.T. and Cheng C.M., "Scaling, dimensional analysis, and indentation measurements." (2004) <http://dx.doi.org/10.1016/j.mser.2004.05.001>`_
.. [#DoernerNix_1986] `Doerner M.F. and Nix W.D., "A method for interpreting the data from depth-sensing indentation instruments" (1986). <http://dx.doi.org/10.1557/JMR.1986.0601>`_
.. [#Gao_1992] `Gao H. et al., "Elastic contact versus indentation modeling of multi-layered materials" (1992). <http://dx.doi.org/10.1016/0020-7683(92)90004-D>`_
.. [#Hainsworth_1996] `Hainsworth S.V. et al., "Analysis of nanoindentation load-displacement loading curves" (1996). <http://dx.doi.org/10.1557/JMR.1996.0250>`_
.. [#Hay_2011] `Hay J. and Crawford B., "Measuring substrate-independent modulus of thin films" (2011). <http://dx.doi.org/10.1557/jmr.2011.8>`_
.. [#Hochstetter_1999] `Hochstetter G. et al., "Strain-rate effects on hardness of glassy polymers in the nanoscale range. Comparison between quasi-static and continuous stiffness measurements" (1999). <http://dx.doi.org/10.1080/00222349908248131>`_
.. [#King_1987] `King R.B., "Elastic analysis of some punch problems for a layered medium" (1987). <http://dx.doi.org/10.1016/0020-7683(87)90116-8>`_
.. [#Loubet_1986] `Loubet J.L. et al., "Vickers indentation curves of elastoplastic materials" (1986). <http://dx.doi.org/10.1520/STP889-EB>`_
.. [#Mencik_1997] `Menčík J. et al., "Determination of elastic modulus of thin layers using nanoindentation" (1997). <http://dx.doi.org/10.1557/JMR.1997.0327>`_
.. [#Mercier_2010] `Mercier D. et al., "Mesure de module d'Young d'un film mince à partir de mesures expérimentales de nanoindentation réalisées sur des systèmes multicouches" (2010). <http://dx.doi.org/10.1051/mattech/2011029>`_
.. [#OliverPharr_1992] `Oliver W.C. and Pharr G.M., "An improved technique for determining hardness and elastic modulus using load and displacement sensing indentation experiments" (1992). <http://dx.doi.org/10.1557/JMR.1992.1564>`_
.. [#OliverPharr_2004] `Oliver W.C. and Pharr G.M., "Measurement of hardness and elastic modulus by instrumented indentation: Advances in understanding and refinements to methodology" (2004). <http://dx.doi.org/10.1557/jmr.2004.19.1.3>`_
.. [#Perriot_2004] `Perriot A. and Barthel E., "Elastic contact to a coated half-space: Effective elastic modulus and real penetration" (2004). <http://dx.doi.org/10.1557/jmr.2004.19.2.600>`_
.. [#Pharr_1992] `Pharr G. M.  et al., "On the generality of the relationship among contact stiffness, contact area, and elastic modulus during indentation." (1992). <http://dx.doi.org/10.1557/JMR.1992.0613>`_
.. [#Saha_2002] `Saha R. and Nix W.D., "Effects of the substrate on the determination of thin film mechanical properties by nanoindentation" (2002). <http://dx.doi.org/10.1016/S1359-6454(01)00328-7>`_
.. [#Troyon_2006] `Troyon M. and Lafaye S., "About the importance of introducing a correction factor in the Sneddon relationship for nanoindentation measurements" (2002). <http://dx.doi.org/10.1080/14786430600606834>`_




