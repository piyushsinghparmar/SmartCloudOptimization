function T = sensitivityAnalysis(costs, capacities, demands)
% SENSITIVITYANALYSIS Solves the LP repeatedly for a vector of demand values.
% Infeasible scenarios are retained with NaN cost and status text.

costs = costs(:);
capacities = capacities(:);
demands = demands(:);

n = numel(demands);
minCost = nan(n,1);
status = cell(n,1);
allocations = nan(n,numel(costs));

for k = 1:n
    res = solveLP(costs, capacities, demands(k));
    if res.success
        minCost(k) = res.minCost;
        allocations(k,:) = res.x(:)';
        status{k} = 'Optimal';
    else
        status{k} = res.message;
    end
end

T = table(demands, minCost, status, 'VariableNames', ...
    {'Demand','MinimumCost','Status'});
for j = 1:numel(costs)
    T.(sprintf('Server%dWorkload',j)) = allocations(:,j);
end
end
