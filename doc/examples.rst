Examples of nanoindentation data
==================================

.. include:: includes.rst

Please look at the experimental procedure proposed by Jennett N. M. and Bushby A. J. [#Jennett_2001]_,
to perform nanoindentation tests on bulk, coatings or multilayer systems, and to the ISO standard (ISO 14577 - 1 to 4).

Format of data
###############

* Both .txt or .xls files are accepted.
* 3 columns (Displacement / Load / Stiffness)
* 6 columns (Disp. / SD (Disp.) / Load / SD (Load.) / Stiff. / SD (Stiff.)) (SD for Standard Deviation)

..  warning::
    You data must only have the loading part from the load-displacement curves of your (nano)indentation results.
    In the case of data saved in a 'Sample' sheet of a .xls file obtained from MTS software - Analyst with a 'Hold Segment Type',
    the toolbox is able to consider only the loading part of your results.

..  warning::
    It is advised to use average results from at least 10 indentation tests to avoid artefacts
    (e.g. pop-in, roughness, local impurities or dust on the sample's surface...).

..  warning::
    Please, check if the surface detection is well done, especially if the substrate is compliant [#Kaufman_2009]_ and [#Piccarolo_2010]_.
    For more explanations about the surface detection, look into the `NIMS documentation <http://nims.readthedocs.org/en/latest/models.html>`_.

To analyze pop-in distribution, the Matlab PopIn toolbox was developed. The `Matlab code <https://github.com/DavidMercier/PopIn>`_
is available on GitHub with `the documentation <http://popin.readthedocs.org/en/latest/>`_.

Examples
#########

* `0film_Si_CSM-2nm_noSD.txt <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/0film_Si_CSM-2nm_noSD.txt>`_
    - Data for a bulk Silicon sample obtained by Berkovich indentation with no CSM mode (amplitude 2nm).
    - Data obtained by Berkovich indentation with CSM mode (amplitude 2nm) (no standard deviation).

* `1film_SiO2_Si_CSM-2nm.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/1film_SiO2_Si_CSM-2nm.xls>`_
    - Data for a thin film of Silicon thermal oxide (500nm) on a bulk Silicon sample.
    - Data obtained by Berkovich indentation with CSM mode (amplitude 2nm).

* `1film_SiO2_Si_CSM-2nm_noSD.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/1film_SiO2_Si_CSM-2nm_noSD.xls>`_
    - Data for a thin film of Silicon thermal oxide (500nm) on a bulk Silicon sample.
    - Data obtained by Berkovich indentation with CSM mode (amplitude 2nm) (no standard deviation).

* `2films_Al_SiO2_Si_CSM-2nm.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/2films_Al_SiO2_Si_CSM-2nm.xls>`_
    - Data for a thin film of PVD Aluminum (500nm) deposited on a bulk Silicon sample with a Silicon thermal oxide (500nm).
    - Data obtained by Berkovich indentation with CSM mode (amplitude 2nm).

* `3films_Au-Ti-SiO2-Si_CSM-1nm.txt <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/3films_Au-Ti-SiO2-Si_CSM-1nm.txt>`_
    - Data for a thin film of PVD Gold (500nm) deposited on thin film of PVD Titanium (500nm) on a bulk Silicon sample with a Silicon thermal oxide (500nm).
    - Data obtained by Berkovich indentation with CSM mode (amplitude 1nm).

* `3films_Au-Ti-SiO2-Si_CSM-1nm.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/3films_Au-Ti-SiO2-Si_CSM-1nm.xls>`_
    - Data for a thin film of PVD Gold (500nm) deposited on thin film of PVD Titanium (500nm) on a bulk Silicon sample with a Silicon thermal oxide (500nm).
    - Data obtained by Berkovich indentation with CSM mode (amplitude 1nm).

The last example (2 files for Au-Ti-SiO2-Si sample) is used to validate the elastic multilayer model of Mercier et al. [#Mercier_2010]_.
A micrograph of this sample is given Figure 1.

.. figure:: ./_pictures/multilayerSEM.png
   :scale: 60 %
   :align: center
   
   *Figure 1 : SEM cross-sectional observation of a multilayer sample.*
    
References
###########

.. [#Jennett_2001] `Jennett N. M. and Bushby A. J., "Adaptive Protocol for Robust Estimates of Coatings Properties by Nanoindentation" (2001). <http://dx.doi.org/10.1557/PROC-695-L3.1.1>`_

.. [#Kaufman_2009] `Kaufman J. D. and Klapperich C. M., "Surface detection errors cause overestimation of the modulus in nanoindentation on soft materials" (2009). <http://dx.doi.org/10.1016/j.jmbbm.2008.08.004>`_

.. [#Mercier_2010] `Mercier D. et al., "Young's modulus measurement of a thin film from experimental nanoindentation performed on multilayer systems" (2010). <http://dx.doi.org/10.1051/mattech/2011029>`_

.. [#Piccarolo_2010] `Piccarolo S. et al., "Improving surface detection on nanoindentation of compliant materials" (2010). <http://dx.doi.org/10.1088/0957-0233/21/6/065701>`_

- `ISO 14577 - 1 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 1: Test method", (2002). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=30104>`_

- `ISO 14577 - 2 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 2: Verification and calibration of testing machines", (2002). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=30543>`_

- `ISO 14577 - 3 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 3: Calibration of reference blocks", (2002). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=32193>`_

- `ISO 14577 - 4 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 4: Test method for metallic and non-metallic coatings", (2007). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=39228>`_