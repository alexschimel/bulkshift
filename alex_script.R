# Load the necessary libraries
library(terra)
library(bulkshift)

# Define the root folder
root_folder <- "C:/Users/Schimel_Alexandre/Data/GIS/Sore_Sunmore/data/Sore_Sunmore_backscatter"

# Load the raster files from the specified root folder
bs01 <- rast(file.path(root_folder, "hydrograf-0108_bs01_EM3002D.tif"))
bs02 <- rast(file.path(root_folder, "hydrograf-0208_bs01_EM3002D.tif"))

# Count the number of non-null pixels in each raster
total_pixels_bs01 <- global(bs01, fun="notNA", na.rm=TRUE)[1,1]
total_pixels_bs02 <- global(bs02, fun="notNA", na.rm=TRUE)[1,1]

# Count the number of non-null pixels in their overlap
common_extent <- intersect(ext(bs01), ext(bs02))
bs01_crop <- crop(bs01, common_extent)
bs02_crop <- crop(bs02, common_extent)
bs02_crop <- resample(bs02_crop, bs01_crop)
overlap <- mask(bs01_crop, bs02_crop)
total_pixels_overlap <- global(overlap, fun = "notNA", na.rm = TRUE)[1, 1]

# Print the pixel counts
cat("Total non-null pixels in bs01:", total_pixels_bs01, "\n")
cat("Total non-null pixels in bs02:", total_pixels_bs02, "\n")
cat("Total pixels in overlap:", total_pixels_overlap, "\n")

# Apply the bulkshift function
b <- bulkshift(shift = bs02, target = bs01, mosaic = TRUE)

par(mfrow = c(1,1))
plot(b$shifted)

# Plot the difference between the datasets
# par(mfrow = c(2, 2))
# bExplore(x = bs02, y = bs01)
