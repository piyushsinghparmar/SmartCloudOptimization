function result = analyzeGame(payoffA, payoffB, strategyNames)
% ANALYZEGAME Finds pure-strategy Nash equilibria and strict dominant strategies.
% payoffA(i,j): A's payoff when A chooses row i and B chooses column j.
% payoffB(i,j): B's payoff at the same outcome.
%
% Ties are allowed in best-response checks. A strict dominant strategy must
% strictly outperform every alternative for every opposing strategy.

if ~isequal(size(payoffA), size(payoffB)) || ndims(payoffA) ~= 2
    error('Payoff matrices must have the same two-dimensional size.');
end
if any(~isfinite(payoffA(:))) || any(~isfinite(payoffB(:)))
    error('Payoffs must be finite numbers.');
end
[nA,nB] = size(payoffA);
if nargin < 3 || isempty(strategyNames)
    strategyNames = arrayfun(@(k) sprintf('Strategy %d',k), ...
        1:max(nA,nB),'UniformOutput',false);
end
if numel(strategyNames) < max(nA,nB)
    error('strategyNames must contain names for every strategy.');
end

bestA = false(nA,nB);
bestB = false(nA,nB);

% A's best responses: maximize down each column.
for j = 1:nB
    bestA(:,j) = payoffA(:,j) == max(payoffA(:,j));
end
% B's best responses: maximize across each row.
for i = 1:nA
    bestB(i,:) = payoffB(i,:) == max(payoffB(i,:));
end

nash = [];
for i = 1:nA
    for j = 1:nB
        if bestA(i,j) && bestB(i,j)
            nash(end+1,:) = [i j]; %#ok<AGROW>
        end
    end
end

dominantA = [];
for i = 1:nA
    isStrict = true;
    for k = 1:nA
        if k ~= i && any(payoffA(i,:) <= payoffA(k,:))
            isStrict = false;
            break;
        end
    end
    if isStrict, dominantA(end+1) = i; end %#ok<AGROW>
end

dominantB = [];
for j = 1:nB
    isStrict = true;
    for k = 1:nB
        if k ~= j && any(payoffB(:,j) <= payoffB(:,k))
            isStrict = false;
            break;
        end
    end
    if isStrict, dominantB(end+1) = j; end %#ok<AGROW>
end

result.bestResponsesA = bestA;
result.bestResponsesB = bestB;
result.nash = nash;
result.dominantA = dominantA;
result.dominantB = dominantB;
result.strategyNames = strategyNames;
end
