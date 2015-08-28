Examples of nanoindentation data
==================================

.. include:: includes.rst

Please look at the experimental procedure proposed by Jennett N. M. and Bushby A. J. [#Jennett_2001]_,
to perform nanoindentation tests on bulk, coatings or multilayer systems, and to the ISO standard (ISO 14577 - 1 to 4).

Type of data - Pre-Requirements
##################################

Only data continuously measured in function of the indentaton depth are accepted in the NIMS toolbox (e.g.:
CSM mode for Agilent - MTS nanoindenter or DMA - CMX algorithm for Hysitron nanoindenter).

You data must only have the loading part from the load-displacement curves of your (nano)indentation results. In the case of data saved in a 'Sample' sheet of a .xls file obtained with 'Analyst' (MTS software) containing a 'Hold Segment Type', the toolbox is able to consider only the loading part of your results.

Please, check if the surface detection is well done, especially if the substrate is compliant [#Kaufman_2009]_ and [#Piccarolo_2010]_.
For more explanations about the surface detection, look into the `NIMS documentation <http://nims.readthedocs.org/en/latest/models.html>`_.

It is advised to use average results from at least 10 indentation tests to avoid artefacts
(e.g. pop-in, roughness, local impurities or dust on the sample's surface...).

.. note::
    To analyze pop-in distribution, the Matlab PopIn toolbox was developed. The `Matlab code <https://github.com/DavidMercier/PopIn>`_
    is available on GitHub with `the documentation <http://popin.readthedocs.org/en/latest/>`_.

Agilent - MTS example files
###############################

* Both .txt or .xls files are accepted.
* 3 columns (Displacement / Load / Stiffness)
* 6 columns (Disp. / SD (Disp.) / Load / SD (Load.) / Stiff. / SD (Stiff.)) (SD for Standard Deviation)


* `MTS_0film_Si_CSM-2nm_noSD.txt <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/MTS_0film_Si_CSM-2nm_noSD.txt>`_
    - Data for a bulk Silicon sample.
    - Data obtained by Berkovich indentation with CSM mode (75Hz / amplitude 2nm) (no standard deviation).

* `MTS_1film_SiO2_Si_CSM-2nm.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/MTS_1film_SiO2_Si_CSM-2nm.xls>`_
    - Data for a thin film of Silicon thermal oxide (500nm) on a bulk Silicon sample.
    - Data obtained by Berkovich indentation with CSM mode (75Hz / amplitude 2nm).

* `MTS_1film_SiO2_Si_CSM-2nm_noSD.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/MTS_1film_SiO2_Si_CSM-2nm_noSD.xls>`_
    - Data for a thin film of Silicon thermal oxide (500nm) on a bulk Silicon sample.
    - Data obtained by Berkovich indentation with CSM mode (75Hz / amplitude 2nm) (no standard deviation).

* `MTS_2films_Al_SiO2_Si_CSM-2nm.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/MTS_2films_Al_SiO2_Si_CSM-2nm.xls>`_
    - Data for a thin film of PVD Aluminum (500nm) deposited on a bulk Silicon sample with a Silicon thermal oxide (500nm).
    - Data obtained by Berkovich indentation with CSM mode (75Hz / amplitude 2nm).

* `MTS_3films_Au-Ti-SiO2-Si_CSM-1nm.txt <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/MTS_3films_Au-Ti-SiO2-Si_CSM-1nm.txt>`_
    - Data for a thin film of PVD Gold (500nm) deposited on thin film of PVD Titanium (500nm) on a bulk Silicon sample with a Silicon thermal oxide (500nm).
    - Data obtained by Berkovich indentation with CSM mode (75Hz / amplitude 1nm).

* `MTS_3films_Au-Ti-SiO2-Si_CSM-1nm.xls <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/MTS_3films_Au-Ti-SiO2-Si_CSM-1nm.xls>`_
    - Data for a thin film of PVD Gold (500nm) deposited on thin film of PVD Titanium (500nm) on a bulk Silicon sample with a Silicon thermal oxide (500nm).
    - Data obtained by Berkovich indentation with CSM mode (75Hz / amplitude 1nm).

The last example (2 files for Au-Ti-SiO2-Si sample) is used to validate the elastic multilayer model of Mercier et al. [#Mercier_2010]_.
A micrograph of this sample is given Figure 1.

.. figure:: ./_pictures/multilayerSEM.png
   :scale: 60 %
   :align: center
   
   *Figure 1 : SEM cross-sectional observation of a multilayer sample.*
   
Hysitron example files
##########################

* Both .txt or .dat files are accepted.

* `Hysitron_dma.txt <https://github.com/DavidMercier/NIMS/blob/master/Data_indentation/Hysitron_dma.txt>`_
    - Data obtained with DMA mode (205Hz / amplitude 0.65nm).
    - Courtesy of `Dr. Igor Zlotnikov <https://www.researchgate.net/profile/Igor_Zlotnikov>`_ 
    (`Max Planck Institute of Colloids and Interfaces <http://www.mpikg.mpg.de/>`_, Germany (Potsdam)).

References
############

.. [#Jennett_2001] `Jennett N. M. and Bushby A. J., "Adaptive Protocol for Robust Estimates of Coatings Properties by Nanoindentation" (2001). <http://dx.doi.org/10.1557/PROC-695-L3.1.1>`_

.. [#Kaufman_2009] `Kaufman J. D. and Klapperich C. M., "Surface detection errors cause overestimation of the modulus in nanoindentation on soft materials" (2009). <http://dx.doi.org/10.1016/j.jmbbm.2008.08.004>`_

.. [#Mercier_2010] `Mercier D. et al., "Young's modulus measurement of a thin film from experimental nanoindentation performed on multilayer systems" (2010). <http://dx.doi.org/10.1051/mattech/2011029>`_

.. [#Piccarolo_2010] `Piccarolo S. et al., "Improving surface detection on nanoindentation of compliant materials" (2010). <http://dx.doi.org/10.1088/0957-0233/21/6/065701>`_

- `ISO 14577 - 1 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 1: Test method", (2002). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=30104>`_

- `ISO 14577 - 2 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 2: Verification and calibration of testing machines", (2002). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=30543>`_

- `ISO 14577 - 3 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 3: Calibration of reference blocks", (2002). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=32193>`_

- `ISO 14577 - 4 , "Metallic materials -- Instrumented indentation test for hardness and materials parameters -- Part 4: Test method for metallic and non-metallic coatings", (2007). <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=39228>`_

- `Agilent website <http://www.agilent.com/>`_

- `Hysitron website <https://www.hysitron.com/>`_