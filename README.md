# Smart Cloud Resource Allocation and Competitive Strategy Optimization

A medium-level B.Tech IT project demonstrating Linear Programming (LP) and Game Theory using MATLAB.

## Project modules
1. **Linear Programming:** Minimize workload allocation cost subject to server capacities and total demand.
2. **Game Theory:** Analyze best responses, strict dominant strategies, and pure-strategy Nash equilibria for a two-provider pricing game.
3. **Sensitivity analysis:** Re-solve the LP under different demand levels.
4. **Visualization:** Save workload, cost, utilization, and payoff charts.

All sample numbers are illustrative educational values, not real cloud-provider prices or measured market data.

## Application Screenshots

### Linear Programming Tab
![Linear Programming Tab](screenshots/lp_tab.png)

### Game Theory Tab
![Game Theory Tab](screenshots/game_theory_tab.png)

### Sensitivity Analysis Tab
![Sensitivity Analysis Tab](screenshots/sensitivity_tab.png)

## Requirements
- MATLAB
- Optimization Toolbox for `linprog`

## Run the project
1. Extract the project folder.
2. Open MATLAB and set the Current Folder to `SmartCloudOptimization`.
3. Run the command-line pipeline:
   ```matlab
   main
4. Generated graphs are saved in `graphs/`.

5. CSV results are saved in `results/`.



## Run tests

From the MATLAB Command Window:

```matlab

testLP

testGameTheory

```

If MATLAB cannot find the tests, open the `tests` folder or add it to the path with `addpath(genpath(pwd))`.



## Mathematical model

Minimize:

`Z = 4*xA + 3*xB + 2.5*xC`



Subject to:

`xA + xB + xC = demand`
`0 <= xA <= 100`
`0 <= xB <= 80`
`0 <= xC <= 60`


For demand 180, the expected allocation is `[40, 80, 60]` and the minimum cost is 550 illustrative cost units.



## Game theory

Rows correspond to Provider A strategies and columns to Provider B strategies. The sample strategies are Low Price and Premium Price. Each provider has a separate payoff matrix. The example has a pure-strategy Nash equilibrium at (Low Price, Low Price), payoff (40, 40).



## Limitations

The LP and game theory modules are complementary analyses, but are not mathematically coupled in this baseline model. To model a truly integrated market, define how workload, pricing, demand, and costs determine provider payoffs. 