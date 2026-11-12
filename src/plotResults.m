function plotResults(lp, p, sens, game, graphDir)
% PLOTRESULTS Creates and saves project graphs as PNG files.
if ~exist(graphDir,'dir'), mkdir(graphDir); end

% Graph 1: workload allocation
fig = figure('Visible','on','Name','Optimal Workload Allocation');
bar(lp.x);
set(gca,'XTick',1:numel(p.serverNames),'XTickLabel',p.serverNames);
ylabel('Workload units'); title('Optimal Cloud Resource Allocation');
grid on;
saveas(fig,fullfile(graphDir,'workload_allocation.png'));

% Graph 2: demand versus minimum cost (ignore infeasible NaN points)
fig = figure('Visible','on','Name','Cost versus Demand');
valid = isfinite(sens.MinimumCost);
plot(sens.Demand(valid),sens.MinimumCost(valid),'-o','LineWidth',1.5);
xlabel('Total workload demand'); ylabel('Minimum operating cost');
title('Minimum Cost versus Workload Demand'); grid on;
saveas(fig,fullfile(graphDir,'cost_vs_demand.png'));

% Graph 3: capacity utilization
fig = figure('Visible','on','Name','Capacity Utilization');
util = 100*lp.x(:)./p.capacities(:);
bar(util);
set(gca,'XTick',1:numel(p.serverNames),'XTickLabel',p.serverNames);
ylabel('Capacity utilized (%)'); ylim([0 110]);
title('Server Capacity Utilization'); grid on;
saveas(fig,fullfile(graphDir,'capacity_utilization.png'));

% Graph 4: Provider A payoff matrix
fig = figure('Visible','on','Name','Provider A Payoffs');
imagesc(p.payoffA); colorbar;
set(gca,'XTick',1:numel(p.strategyNames),'XTickLabel',p.strategyNames, ...
    'YTick',1:numel(p.strategyNames),'YTickLabel',p.strategyNames);
xlabel('Provider B strategy'); ylabel('Provider A strategy');
title('Provider A Payoff Matrix');
for i = 1:size(p.payoffA,1)
    for j = 1:size(p.payoffA,2)
        text(j,i,num2str(p.payoffA(i,j)),'HorizontalAlignment','center', ...
            'FontWeight','bold','Color','w');
    end
end
saveas(fig,fullfile(graphDir,'payoff_matrix.png'));

% Graph 5: both providers' payoffs by outcome
fig = figure('Visible','on','Name','Pricing Strategy Payoffs');
labels = {};
vals = zeros(4,2);
idx = 0;
for i = 1:2
    for j = 1:2
        idx = idx+1;
        labels{idx} = [p.strategyNames{i} ' / ' p.strategyNames{j}]; %#ok<AGROW>
        vals(idx,:) = [p.payoffA(i,j), p.payoffB(i,j)];
    end
end
bar(vals);
set(gca,'XTick',1:4,'XTickLabel',labels);
xtickangle(20);
ylabel('Illustrative payoff units');
legend({'Provider A','Provider B'},'Location','best');
title('Payoffs Under Each Pricing Outcome'); grid on;
saveas(fig,fullfile(graphDir,'pricing_payoffs.png'));

fprintf('\nSaved graphs to: %s\n',graphDir);
end
