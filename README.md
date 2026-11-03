# Population Autokorrelated Kernel Density Estimate (PKDE)

MoveApps

Github repository: https://github.com/ctmm-initiative/ctmmMoveApp_akdepop

## Description
Calculate mean home-range size, the joint home-range of the sample of tracked animals (=distribution of samples) and the population home range.

## Documentation
The app starts with a calculated autocorrelated kernel density estimates for several animals and then calculates a population mean home-range size, the joint home-range of the sample and the population home-range (utility distributions = UD).

Please see details of the Populaiton-level Autokorrelated Kernel Density Estimation in the help files of the functions within the ctmm R package: [akde](https://ctmm-initiative.github.io/ctmm/reference/akde.html) and [meta](https://ctmm-initiative.github.io/ctmm/reference/meta.html). 

### Input data
`ctmm UD with Data and Model` including the aKDE UD for all tracks

### Output data
`ctmm UD with Data and Model` including the pKDE UD and aKDE UDs for all tracks

### Artefacts

`akdepop_summary.pdf`: A figure of the home-range area (95 % isopleth) of each individual with its 95 % confidence interval, as also reported in `akde_summary.csv` of the akde App. The bottom row (`mean`) shows the mean home-range area of an individual in the population, i.e. the `mean_individual_area` of `akdepop_summary.csv`. The vertical line marks this mean.

`akdepop_summary.csv`: A table of three area estimates, each at the 95 % isopleth with the lower (`low`) and upper (`high`) bounds of the 95 % confidence interval around the estimate (`est`). All areas are given in square kilometers (column `unit`). The column `quantity` identifies the estimate:

- `mean_individual_area`: The home-range area of an average individual of the population (from `ctmm::meta()`). For example: "in this population, an individual's home range is on average XX km²".
- `sample_range_area`: The area of the combined range of the tracked individuals (the 95 % contour of the mean of their UDs, from `mean()`). This is the range of the population if the population consisted only of the tracked individuals.
- `population_range_area`: The estimated range area of the whole population (from `ctmm::pkde()`). It accounts for individuals of the population that were not tracked, and is therefore usually much larger than `sample_range_area`. It is most meaningful if the tracked individuals are a representative sample of the population.

- `dist_of_sample_and_pop.pdf`: A plot of the distribution of samples (i.e. the tracked animals) and the distribution of the population home range (i.e., the population home-range as infered from the sample) as map. 

- `dist_pop.gpkg`: A geopackage of the population home range at the 95 % isopleth. 

- `dist_pop.tif`: The utilization distribution (UD) of the population home range.

- `dist_sample.gpkg`: A geopackage of the sample home range at the 95 % isopleth. 

- `dist_sample.tif`: The utilization distribution (UD) of the sample home range.

### Settings 
none

### Most common errors
Please issue an issue [here](https://github.com/ctmm-initiative/ctmmMoveApp_akdepop/issues) if you repeatedly encounter a specific error.

### Null or error handling
none at the moment
