function validateInputs(p)
% VALIDATEINPUTS Checks the main project parameter structure.

required = {'serverNames','costs','capacities','demand', ...
            'strategyNames','payoffA','payoffB'};
for k = 1:numel(required)
    if ~isfield(p,required{k})
        error('Missing required parameter: %s',required{k});
    end
end
if numel(p.serverNames) ~= numel(p.costs) || ...
        numel(p.costs) ~= numel(p.capacities)
    error('Server names, costs and capacities must have matching lengths.');
end
if p.demand < 0
    error('Demand cannot be negative.');
end
if p.demand > sum(p.capacities)
    error('Demand exceeds total server capacity; the LP is infeasible.');
end
if ~isequal(size(p.payoffA),size(p.payoffB))
    error('Provider payoff matrices must have identical dimensions.');
end
end
