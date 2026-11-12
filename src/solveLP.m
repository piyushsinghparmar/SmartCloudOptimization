function result = solveLP(costs, capacities, demand)
% SOLVELP Minimize workload cost subject to server capacities and demand.
% Requires Optimization Toolbox (linprog).
%
% Inputs:
%   costs      n-by-1 cost per workload unit
%   capacities n-by-1 maximum server capacities
%   demand     scalar total workload requirement
%
% Output fields:
%   x, minCost, exitflag, success, message

costs = costs(:);
capacities = capacities(:);
n = numel(costs);

if numel(capacities) ~= n
    error('costs and capacities must have the same number of elements.');
end
if any(~isfinite(costs)) || any(costs < 0)
    error('Costs must be finite and non-negative.');
end
if any(~isfinite(capacities)) || any(capacities < 0)
    error('Capacities must be finite and non-negative.');
end
if ~isscalar(demand) || ~isfinite(demand) || demand < 0
    error('Demand must be a finite, non-negative scalar.');
end

result.x = nan(n,1);
result.minCost = NaN;
result.exitflag = -999;
result.success = false;
result.message = '';

if demand > sum(capacities) + 1e-9
    result.message = 'Infeasible: demand exceeds total available capacity.';
    return;
end

% min f''x, subject to A*x <= b, Aeq*x = beq, lb <= x <= ub
A = eye(n);
b = capacities;
Aeq = ones(1,n);
beq = demand;
lb = zeros(n,1);
ub = capacities;

try
    options = optimoptions('linprog','Display','none');
    [x, fval, exitflag, output] = linprog(costs,A,b,Aeq,beq,lb,ub,options);
    result.exitflag = exitflag;
    if ~isempty(x) && exitflag > 0
        result.x = x;
        result.minCost = fval;
        result.success = true;
        result.message = 'Optimal solution found.';
    elseif isstruct(output) && isfield(output,'message')
        result.message = output.message;
    else
        result.message = 'Solver did not return an optimal solution.';
    end
catch ME
    if contains(ME.message, 'linprog') || contains(ME.identifier, 'optim')
        result.message = ['Could not run linprog. Confirm Optimization Toolbox is installed. Details: ' ME.message];
    else
        rethrow(ME);
    end
end
end
