# A Two-Stage Multi-Objective Grey Wolf Optimization Approach for Multi-UAV Forest Fire Inspection in 3D Mountainous Terrain

This repository provides the MATLAB implementation and experiment data for the paper. The proposed framework solves multi-UAV forest fire inspection planning in two sequential stages:

1. **Task allocation:** DMOGWO assigns inspection tasks to multiple UAVs while considering workload balance, energy consumption, and terrain-induced detour costs.
2. **3D path planning:** DE-MOGWO plans the flight path for each assigned task subset under terrain, altitude, and maneuverability constraints.

The output of the task allocation stage is used as the input to the subsequent path planning stage.

## Requirements

- MATLAB with standard numerical and plotting functions.
- PlatEMO for the comparison experiments involving the DE-MOEA algorithm. PlatEMO is available at [https://github.com/BIMK/PlatEMO](https://github.com/BIMK/PlatEMO).

## Code Structure

```text
论文代码/
├── DMOGWO/                 # Stage 1: multi-UAV task allocation
│   ├── main.m              # Main task-allocation experiment
│   ├── MOGWO.m             # Discrete multi-objective grey wolf optimizer
│   ├── initialize_population*.m
│   ├── Swap.m, Shift.m, Symmetry.m
│   ├── Cross.m, Crossover.m
│   ├── adjustsolution.m, adjustbreak.m
│   ├── EvaluatePopulation.m
│   ├── target*.mat          # Inspection-point data
│   ├── terrain*.mat         # Terrain data
│   └── solution*.mat        # Saved allocation results
├── DE-MOGWO/               # Stage 2: 3D UAV path planning
│   ├── main2.m              # Main 3D path-planning experiment
│   ├── MGWO.m               # Diversity-enhanced MOGWO implementation
│   ├── initialize.m, initialize1.m
│   ├── evaluate.m
│   ├── adjust_HIGHT.m
│   ├── adjust_constraint_turning_angle.m
│   ├── check_constraint_*.m
│   ├── target*.mat          # Inspection-point data
│   ├── terrain.mat          # Terrain data
│   ├── Rugged2.mat          # Rugged-terrain data
│   └── solution*.mat        # Saved allocation results used for planning
└── planning results/        # Saved 2D and 3D planning figures
```

## Running the Experiments

### Stage 1: Task Allocation

1. Open MATLAB and set the current folder to `DMOGWO`.
2. Select the required inspection scenario in `main.m` by changing `nvar` and the corresponding `target3d_*.mat` file.
3. Run:

```matlab
main
```

The script loads the terrain and inspection-point data, runs DMOGWO, and visualizes the task allocation results. The main optimization routine is `MOGWO.m`.

### Stage 2: 3D Path Planning

1. Use the allocation result and inspection-point dataset corresponding to the selected scenario.
2. Set the current folder to `DE-MOGWO`.
3. Check the data files and scenario settings in `main2.m`.
4. Run:

```matlab
main2
```

The script divides the assigned task sequence among UAVs and calls `MGWO.m` to optimize the 3D path between consecutive inspection points. Terrain height, altitude, horizontal turning angle, and vertical turning angle constraints are checked during path generation.

## Comparison Platform

The comparison experiments involving the DE-MOEA algorithm are conducted on the PlatEMO platform. Please refer to the official repository:

- PlatEMO: [https://github.com/BIMK/PlatEMO](https://github.com/BIMK/PlatEMO)
- Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, “PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective Optimization [Educational Forum],” *IEEE Computational Intelligence Magazine*, vol. 12, no. 4, pp. 73–87, 2017.

## Notes

- Run the two stages from their respective directories because the two folders contain utility files with some identical filenames.
- The `.mat` files provide the terrain, inspection-point, and saved-solution data used in the experiments.
- The `.fig` files in `planning results` can be opened directly in MATLAB for visual inspection.
