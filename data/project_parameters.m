function p = project_parameters()
% PROJECT_PARAMETERS Returns the illustrative inputs used by the project.

p.serverNames = {'Server A','Server B','Server C'};
p.costs = [4; 3; 2.5];             % cost per workload unit (illustrative)
p.capacities = [100; 80; 60];      % maximum workload per server
p.demand = 180;                    % total workload that must be served

p.strategyNames = {'Low Price','Premium Price'};
% Rows = Provider A strategy; columns = Provider B strategy.
% Each matrix contains the payoff for the named provider.
p.payoffA = [40 70; 20 60];
p.payoffB = [40 20; 70 60];

end
