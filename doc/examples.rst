Examples of nanoindentation data
================================
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \

Format of data
##############

* Both .txt or .xls files are accepted.
* Only the loading part from the load-displacement curves of your (nano)indentation results.
* 3 columns (Displacement/Load/Stiffness) or 6 columns (Disp./SD of Disp./Load/SD of Load/Stiff./SD of Stiff.) (SD for Standard Deviation)
* Units : Displacement (nm) / Load (mN) / Stiffness (N/m)
* For .xls files : It is possible to import a 'Sample' sheet obtained from MTS software - Analyst (with a 'Hold Segment Type')

N.B. : It is advised to use average results from at least 10 indentation tests to avoid artifacts.

Examples
########

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

* `3films_Au-Ti-SiO2-Si_CSM-1nm.xls <hhttps://github.com/DavidMercier/NIMS/blob/master/Data_indentation/3films_Au-Ti-SiO2-Si_CSM-1nm.xls>`_
    - Data for a thin film of PVD Gold (500nm) deposited on thin film of PVD Titanium (500nm) on a bulk Silicon sample with a Silicon thermal oxide (500nm).
    - Data obtained by Berkovich indentation with CSM mode (amplitude 1nm).