function tests = test_viscoelastic_properties
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.modelPath = fullfile(repoRoot, 'matlab_code', ...
    'visco_elastic_models');
testCase.TestData.addedModelPath = ...
    ~any(strcmp(strsplit(path, pathsep), testCase.TestData.modelPath));
if testCase.TestData.addedModelPath
    addpath(testCase.TestData.modelPath);
end
end

function teardownOnce(testCase)
if testCase.TestData.addedModelPath
    rmpath(testCase.TestData.modelPath);
end
end

function testCalculatesReducedModuliAndLossTangent(testCase)
stiffness = 1000;
contactDamping = 100;
contactArea = 1e-12;
beta = 1.034;

[storageModulus, lossModulus, lossTangent] = ...
    viscoelastic_properties(stiffness, contactDamping, contactArea, beta);

verifyEqual(testCase, storageModulus, 0.8570860014, 'AbsTol', 1e-10);
verifyEqual(testCase, lossModulus, 0.08570860014, 'AbsTol', 1e-11);
verifyEqual(testCase, lossTangent, 0.1, 'AbsTol', 1e-12);
end

function testSupportsDepthDependentInputs(testCase)
stiffness = [1000; 2000];
contactDamping = [100; 400];
contactArea = [1e-12; 4e-12];
beta = 1.034;

[storageModulus, lossModulus, lossTangent] = ...
    viscoelastic_properties(stiffness, contactDamping, contactArea, beta);

verifyEqual(testCase, storageModulus(2), storageModulus(1), 'AbsTol', 1e-12);
verifyEqual(testCase, lossModulus(2), 2 .* lossModulus(1), 'AbsTol', 1e-12);
verifyEqual(testCase, lossTangent, [0.1; 0.2], 'AbsTol', 1e-12);
end

function testRejectsMismatchedInputSizes(testCase)
verifyError(testCase, @() viscoelastic_properties([1; 2], [1; 2; 3], ...
    1e-12, 1), 'NIMS:Viscoelastic:IncompatibleInputSizes');
end
