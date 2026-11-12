function testGameTheory()
% TESTGAMETHEORY Checks the example game.
% Run from MATLAB with: testGameTheory

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(projectRoot));
p = project_parameters();

g = analyzeGame(p.payoffA,p.payoffB,p.strategyNames);
assert(isequal(g.nash,[1 1]), 'Expected Low Price / Low Price equilibrium.');
assert(isequal(g.dominantA,1), 'Expected Provider A strict dominant strategy 1.');
assert(isequal(g.dominantB,1), 'Expected Provider B strict dominant strategy 1.');
fprintf('testGameTheory passed.\n');

% A coordination game with two pure equilibria.
A = [2 0; 0 2];
B = [2 0; 0 2];
g2 = analyzeGame(A,B,{'Strategy 1','Strategy 2'});
assert(size(g2.nash,1)==2, 'Expected two pure-strategy equilibria.');
fprintf('Multiple-equilibrium test passed.\n');
end
