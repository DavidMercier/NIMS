Machine learning for indentation of thin films
================================================

Nanoindentation can provide information about both elastic and plastic
properties, but the measured load--depth response of a film also depends on
the substrate, film thickness, indenter geometry and contact conditions.
Machine learning (ML) offers a way to approximate an inverse relationship
between indentation measurements and material properties using a database of
finite element (FE) simulations. The following papers illustrate different
approaches; they are a literature overview, not implemented NIMS features.
See :doc:`python_abaqus` for the FEM workflows available in NIMS.

Inverse modelling workflow
------------------------------

The general approach is to choose a material law and ranges for its
parameters, simulate indentation over those ranges, and train a model to
predict the parameters or a stress--strain curve from simulated observables.
After calibration of the experiment and the indenter, the same observables
are extracted from measured curves and supplied to the trained model.
Predicted properties can then be checked by running a new FE simulation and
comparing its response with measurements not used for training or fitting.

The learned inverse is conditional on the simulations: it cannot reliably
recover mechanisms or parameter values absent from the training set. Different
sets of material parameters can also produce similar indentation curves.
Consequently, a good curve fit alone does not establish a unique solution.

Examples from the literature
----------------------------

Dual-indenter ANN for metallic-glass films
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Han, Marimuthu and Lee (2022) <https://doi.org/10.1016/j.matdes.2022.111000>`_
studied Zr-based metallic-glass films using Berkovich and sphero-conical
indentation. Their artificial neural network (ANN), incorporating a
pretrained autoencoder, maps loading and unloading energy--depth data to the
film's Young's modulus, Poisson's ratio and two parameters of a
pressure-dependent free-volume constitutive model. The FE simulations
explicitly include the film and substrate, with indentation to approximately
30% of the film thickness; substrate properties and tip geometry were
calibrated.

Using two tip geometries supplies complementary responses and can improve
parameter identifiability, although it does not guarantee uniqueness. For
the validation cases, the authors reported differences of up to 3% in plastic
indentation energy. This is a response-level comparison, not a general
uncertainty bound on all inferred parameters.

ANN-derived stress--strain curve for GaN
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Khalfallah, Khalfallah and Benzarti (2024) <https://doi.org/10.3390/coatings14060683>`_
used an approximately 2 µm GaN film on sapphire and a calibrated Berkovich
tip. A feed-forward ANN trained on 81 FE simulations uses 25 inputs, including
load--depth data, unloading stiffness and the plastic-to-total work ratio, to
estimate a stress--strain curve. A Swift-type power law is then fitted to the
curve. The reported values are a Young's modulus of 365.4 GPa, yield stress
of 5.1057 GPa and hardening exponent of 0.073.

The authors compared 2D and 3D FE models and selected a 2D model. Their
shallow-indentation analysis treats the film as a semi-infinite material and
assumes substrate effects are negligible. These assumptions should be
checked for other film thicknesses, property contrasts and indentation depths;
a depth-to-thickness rule of thumb is not a guarantee of substrate-free
measurements.

CNN using the loading curve
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Long, Lu, Shen and Su (2022) <https://doi.org/10.1007/s10338-022-00340-5>`_
trained a convolutional neural network (CNN) on 228 simulated cases to
predict Young's modulus, yield strength and hardening exponent. They reshape
81 loading-curve points into a 9 × 9 input matrix and fix Poisson's ratio at
0.3. Reported correlations on synthetic test cases are 0.951 for modulus,
0.954 for yield strength and 0.845 for the hardening exponent.

The lower correlation for hardening highlights that some parameters are less
well constrained by a loading curve than others. This is a simulation-based
validation rather than an experimental thin-film demonstration; substrate
effects should not be assumed to have been addressed by this method.

Considerations for applying these methods
-----------------------------------------

* **Choose the forward model carefully.** Include the relevant film and
  substrate layers, elastic--plastic law, indenter shape, friction and
  boundary conditions; check mesh convergence. If an effect is neglected,
  assess its sensitivity rather than assuming it is insignificant.
* **Design the simulation database.** Cover plausible property ranges and
  combinations, film thicknesses and measurement conditions. Keep test
  cases separate from training and report prediction errors for each
  parameter, especially near the limits of the training range.
* **Match simulations to measurements.** Calibrate the tip area function,
  instrument compliance and depth; consider surface roughness, pile-up,
  residual stress and experimental noise. These can create a gap between
  idealized FE curves and experimental data.
* **Assess identifiability and uncertainty.** Use sensitivity studies,
  repeated measurements and, where useful, multiple indentation depths or tip
  geometries. Report plausible parameter ranges and assumptions rather than
  interpreting a single prediction as unique.
* **Validate independently.** Compare simulated loading and unloading
  responses with held-out experiments, and where possible compare inferred
  properties with independent measurements. Matching the input indentation
  curve alone is not sufficient evidence that the underlying properties are
  correct.
