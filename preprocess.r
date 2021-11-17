###############################################################################
##
## MALDI-TOF Translator from Bruker to mzML
##
## Alejandro Guerrero-López
##
###############################################################################
args <- commandArgs(trailingOnly = TRUE)
###############################################################################
## Load libraries
## MALDIquant()
## MALDIquantForeign()
##
#install.packages(c("MALDIquant","MALDIquantForeign"))
###############################################################################

library("MALDIquant")
library("MALDIquantForeign")

###############################################################################
## Load data
###############################################################################
path <- "data/maldi_pure"
spectra1 <- importBrukerFlex(path)

##### PREPROCESS FOLLOWING PAPER INSTRUCTIONS:

spectra <- smoothIntensity(spectra, method="SavitzkyGolay", halfWindowSize=5)
spectra <- removeBaseline(spectra, method="TopHat")
spectra <- calibrateIntensity(spectra, method="TIC")
peaks <- detectPeaks(spectra, method="MAD", halfWindowSize=20, SNR=2)
peaks <- binPeaks(peaks, tolerance=0.004)
peaks <- filterPeaks(peaks, minFrequency=0.9)


###############################################################################
## Save data
###############################################################################
path_save <- paste0(path, '/mzml/')
# path_save <- paste0(path, args[2])
## Save Rdata object
save(spectra1, file='mzml')
# save(spectra1, file=args[2])

## Export
exportMzMl(spectra1, path=path_save)
