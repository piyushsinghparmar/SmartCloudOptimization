% SMART CLOUD RESOURCE ALLOCATION AND COMPETITIVE STRATEGY OPTIMIZATION
% Run this script from MATLAB with the project folder as the current folder.
% Requires Optimization Toolbox for linprog.

clc; clear; close all;
projectRoot = fileparts(mfilename('fullpath'));
addpath(genpath(projectRoot));

fprintf('\n===============================================\n');
fprintf(' SMART CLOUD OPTIMIZATION PROJECT\n');
fprintf('===============================================\n');

% Load the sample inputs
p = project_parameters();

% Validate inputs before solving
validateInputs(p);

% 1) Linear programming: minimum-cost workload allocation
lp = solveLP(p.costs, p.capacities, p.demand);
if ~lp.success
    error('LP solver did not find an optimum: %s', lp.message);
end

fprintf('\n--- LINEAR PROGRAMMING RESULTS ---\n');
for k = 1:numel(p.serverNames)
    fprintf('%s: %.2f workload units (capacity %.2f; utilization %.1f%%)\n', ...
        p.serverNames{k}, lp.x(k), p.capacities(k), 100*lp.x(k)/p.capacities(k));
end
fprintf('Demand: %.2f units\n', p.demand);
fprintf('Minimum total cost: Rs. %.2f\n', lp.minCost);

% 2) Game theory: pure-strategy Nash equilibrium
game = analyzeGame(p.payoffA, p.payoffB, p.strategyNames);

fprintf('\n--- GAME THEORY RESULTS ---\n');
disp('Provider A payoff matrix:'); disp(p.payoffA);
disp('Provider B payoff matrix:'); disp(p.payoffB);
if isempty(game.nash)
    fprintf('No pure-strategy Nash equilibrium found.\n');
else
    for k = 1:size(game.nash,1)
        i = game.nash(k,1); j = game.nash(k,2);
        fprintf('Nash equilibrium %d: A chooses %s; B chooses %s; payoffs = (%.2f, %.2f)\n', ...
            k, p.strategyNames{i}, p.strategyNames{j}, ...
            p.payoffA(i,j), p.payoffB(i,j));
    end
end
if all(game.dominantA > 0)
    fprintf('Provider A dominant strategy: %s\n', p.strategyNames{game.dominantA(1)});
else
    fprintf('Provider A has no single strict dominant strategy.\n');
end
if all(game.dominantB > 0)
    fprintf('Provider B dominant strategy: %s\n', p.strategyNames{game.dominantB(1)});
else
    fprintf('Provider B has no single strict dominant strategy.\n');
end

% 3) Sensitivity analysis across feasible demand values
demands = [100 140 180 220];
sens = sensitivityAnalysis(p.costs, p.capacities, demands);
fprintf('\n--- SENSITIVITY ANALYSIS ---\n');
disp(sens);

% 4) Generate and save graphs/results
outDir = fullfile(projectRoot, 'results');
if ~exist(outDir, 'dir'), mkdir(outDir); end
graphDir = fullfile(projectRoot, 'graphs');
if ~exist(graphDir, 'dir'), mkdir(graphDir); end

plotResults(lp, p, sens, game, graphDir);
writetable(array2table([lp.x(:), p.capacities(:), ...
    100*lp.x(:)./p.capacities(:), p.costs(:).*lp.x(:)], ...
    'VariableNames', {'Workload','Capacity','UtilizationPercent','OperatingCost'}, ...
    'RowNames', p.serverNames), fullfile(outDir,'optimal_allocation.csv'), ...
    'WriteRowNames', true);
writetable(sens, fullfile(outDir,'sensitivity_results.csv'));

fprintf('\nFinished. Check the graphs/ and results/ folders.\n');
fprintf('Note: all values are illustrative project data, not actual cloud-provider prices.\n');
