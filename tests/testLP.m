function testLP()
% TESTLP Basic checks for the sample LP model.
% Run from MATLAB with: testLP

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(projectRoot));
p = project_parameters();

r = solveLP(p.costs,p.capacities,p.demand);
assert(r.success, 'Expected an optimal solution.');
assert(abs(sum(r.x)-p.demand) < 1e-6, 'Demand constraint failed.');
assert(all(r.x >= -1e-8), 'Non-negativity constraint failed.');
assert(all(r.x <= p.capacities + 1e-8), 'Capacity constraint failed.');
assert(abs(r.minCost-550) < 1e-6, 'Unexpected minimum cost.');
fprintf('testLP passed.\n');

% Infeasible demand should be rejected.
r2 = solveLP(p.costs,p.capacities,sum(p.capacities)+1);
assert(~r2.success, 'Expected infeasible demand to be rejected.');
fprintf('Infeasibility test passed.\n');
end
