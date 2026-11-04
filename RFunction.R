library(ctmm)
library(sf)

rFunction <- function(data) {
  # Population-level estimates need at least 2 individuals. With only one,
  # ctmm still returns results, but the population range is meaningless
  # (it collapses to a tiny area around the locations).
  n_ind <- length(data[[2]])
  if (n_ind < 2) {
    stop(
      "The input contains ", n_ind, " individual(s). Population-level ",
      "home-range estimates require UDs of at least 2 individuals."
    )
  }

  # Plot of each individual's home-range area and the population mean. The
  # numbers for the summary table are taken from a second call below, which
  # returns them in square meters (with units = TRUE ctmm picks the unit itself)
  pdf(appArtifactPath("akdepop_summary.pdf"))
  ctmm::meta(data[[2]], plot = TRUE)
  dev.off()
  meta <- ctmm::meta(data[[2]], plot = FALSE, units = FALSE)
  
  # pop means
  MEAN <- mean(data[[2]]) # distribution of the sample
  PKDE <- pkde(data[[3]], data[[2]]) # distribution of the population
  
  EXT <- extent(list(MEAN, PKDE))
  COL <- c("red", "black", "blue")
  
  pdf(appArtifactPath("dist_of_sample_and_pop.pdf"))
  par(mfrow = c(1,2))
  plot(data[[3]], MEAN, col = COL, ext = EXT)
  title("Distribution of the sample")
  plot(data[[3]], PKDE, col = COL, ext = EXT)
  title("Distribution of the population")
  par(mfrow = c(1,1))
  dev.off()
  
  # Summary table of the three area estimates (95% contour, with 95% CIs).
  ci_m2 <- rbind(
    meta[1, , drop = FALSE],                         # row "mean" of meta()
    summary(MEAN, units = FALSE)$CI[1, , drop = FALSE],
    summary(PKDE, units = FALSE)$CI[1, , drop = FALSE]
  )
  
  # Ensure all outputs are in a standard unit. ctmm otherwise picks an
  # appropriate unit, for each, but this limits comparability
  ci_km2 <- ci_m2 / 1e6

  summary_table <- data.frame(
    quantity = c(
      "mean_individual_area",
      "sample_range_area",
      "population_range_area"
    ),
    description = c(
      "Mean home-range area of an individual in the population (ctmm::meta)",
      "Area of the combined range of the tracked individuals (mean of their UDs)",
      "Estimated range area of the whole population, including untracked individuals (ctmm::pkde)"
    ),
    low = ci_km2[, "low"],
    est = ci_km2[, "est"],
    high = ci_km2[, "high"],
    unit = "square kilometers"
  )
  write.csv(summary_table, appArtifactPath("akdepop_summary.csv"), row.names = FALSE)
  
  sf::st_as_sf(ctmm::SpatialPolygonsDataFrame.UD(MEAN, level.UD = 0.95)) |> 
    sf::st_write(appArtifactPath("dist_sample.gpkg"), append = FALSE)
  
  sf::st_as_sf(ctmm::SpatialPolygonsDataFrame.UD(PKDE, level.UD = 0.95)) |> 
    sf::st_write(appArtifactPath("dist_pop.gpkg"), append = FALSE) 
  
  writeRaster(MEAN, appArtifactPath("dist_sample.tif"), overwrite = TRUE)
  writeRaster(PKDE, appArtifactPath("dist_pop.tif"), overwrite = TRUE)
  
  return(data)
  
}
