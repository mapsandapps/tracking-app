#
# Developer : Mollie Taylor (mollie.taylor@gmail.com)
# Date : 2013
# All code ©2013 Mollie Taylor
# All rights reserved
#

# system() # intern = TRUE?
# file1 <- read.csv(file.choose(),
	# header = TRUE)


extension <- readline("What extension do your files have? (Options: gpx, kml, csv)\n")
# extension <- ".gpx"
extension <- sub("\\.", "", extension) # cuts the period, so they're standardized
# if they have .csv, possibly skip straight to mapping
GPSType <- extension # change once we have more than just .gpx

# glob2rx(".gpx")
gpxFilenames <- Sys.glob(paste("Imported Files/*.", extension, sep = ""))



# there's probably a more efficient way to do this than a loop:

fileNumbers <- 1:length(gpxFilenames)

appendTrack(fileNumbers)