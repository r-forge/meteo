\name{pred.strk}
\alias{pred.strk}
\title{Spatio-temporal regression kriging}
\description{ Function for spatio-temporal regression kriging prediction based on \link[gstat]{krigeST}.}
\usage{
pred.strk(temp,zcol = 1, newdata, pred.id = "tempPred", zero.tol = 0, 
         dynamic.cov = c(1, 2), static.cov = c(1, 2), 
         reg.coef=list( tmean= c(-0.1265044154,0.4051734447,0.4943247727,0.0001837527,-0.0189207588),  
                 tmin = c(-0.9825601517,0.5672140021,0.3344561638, 0.0003119777,-0.0243629638),
                 tmax = c(1.7873573081,0.350228076, 0.5569091092, 0.0002571338,-0.0012988123) ) [[ 'tmean']] ,
         vgm.model=list( tmean=vgmST("sumMetric",
                                space=vgm( 14.13, "Sph", 5903, 1.933),
                                time =vgm(0, "Sph",  0.1, 0),
                                joint=vgm(9.06, "Sph", 2054, 0.474),
                                 stAni=497.9),
                   tmin = vgmST("sumMetric",
                                space=vgm( 22.682, "Sph", 5725, 3.695),
                                time =vgm(0, "Sph",  0.1, 0),
                                joint=vgm(9.457, "Sph",1888, 1.67),
                                 stAni=485),
                    tmax = vgmST("sumMetric",
                                 space=vgm( 8.31, "Sph", 4930, 2.872),
                                 time =vgm(0, "Sph",  0.1, 0),
                                 joint=vgm(11.175, "Sph", 2117, 1.75),
                                 stAni=527) ) [['tmean']] ,
        tiling = TRUE, ntiles = 64, parallel.processing = TRUE, cpus = 3, 
        sp.nmax = 18, time.nmax = 2,fast = FALSE, computeVar = FALSE, 
        do.cv = TRUE, only.cv = FALSE, out.remove = TRUE, threshold.res = 15)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{temp}{object of \link[spacetime]{STFDF-class} containing dependent variable (observations) in space and time.}
  \item{zcol}{variable column name or number showing position in \code{temp@data} }
  \item{newdata}{dynamic and static covariates as \link[spacetime]{STFDF-class} object; spatial and temporal overlay with \code{temp} object must be possible}
  \item{pred.id}{identifier of new variable}
  \item{zero.tol}{distance values less than or equal to this threshold value locations are considered as duplicates, see \link{rm.dupl}, duplicates are removed to avoid singular covariance matrices in kriging.}
  \item{dynamic.cov}{vector of variable column names or numbers showing position of dynamic covariates in \code{newdat@data}; dynamic covariates are spatio-temporal explanatory variables, changing in space and time domain}
  \item{static.cov}{vector of variable column names or numbers showing position of static covariates in \code{newdata@data@sp}; static covariates are spatial explanatory variables changing just in space; static in time dimension}
  \item{reg.coef}{linear regression coefficients; order is assumed as intercept, \code{dynamic.cov}, \code{static.cov}. Coefficients can be defined from user depending on dynamic and static covariates.  At the moment the function contains regression coefficient for mean, minimum and maximum temperature calculated globally for GSOD and ECA&D data set on geometrical temperature trend, MODIS LST-8 day, elevation and TWI, see \link{regdata}. Coefficients for mean temperature are defined by default.}
  \item{vgm.model}{spatio-temporal variogram of regression residuals, see \link[gstat]{vgmST}. At the moment the function contains spatio-temporal variogram model on residuals for mean, minimum and maximum temperature calculated globally for GSOD and ECA&D data set. Regression residuals on geometrical temperature trend, MODIS LST-8 day, elevation and TWI, see \link{regdata}. Ranges are in km. Spatio-temporal variogram for mean temperatures is defined by default.}
  \item{tiling}{for simplified local kriging. Area is divided in tiles and kriging calculation is done for each tile separately, number of observation used per tile is defined with \code{sp.nmax} and \code{time.nmax}. Default is TRUE.}
  \item{ntiles}{number of tiles. Default is 64. Each tile at minimum should contain less observations than \code{sp.nmax}, ideally each tile should contain observations falling in neighboring tiles.}
  \item{parallel.processing}{if TRUE parallel processing is performed via  \link[snowfall]{sfLapply} }
  \item{cpus}{number of processing units}
  \item{sp.nmax}{number of nearest spatial observations that should be used for a kriging prediction for each tile}
  \item{time.nmax}{number of nearest time observations that should be used for a kriging prediction}
  \item{fast}{if TRUE tiling, tiling is done twice to avoid edge effect}
  \item{computeVar}{if TRUE, just variance is computed}
  \item{do.cv}{if TRUE, cross validation leave-one-station-out is performed}
  \item{only.cv}{if TRUE, only cross validation leave-one-station-out is performed without prediction}
  \item{out.remove}{if TRUE, potential outliers are removed. Removing procedure is iterative, all location with residual higher than defined threshold (\code{treshold.res}) are selected. Only location with highest cross validation residual is removed, than cross validation is done again, the procedure removing one by one location run until all locations have residuals under defined threshold.  
}
  \item{threshold.res}{critical threshold for removing potential outliers}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
An list object containing:
  \item{pred}{an object of \link[spacetime]{STFDF-class} with column contains prediction or variance}
  \item{cv}{cross validation information for points used in prediction, as object of \link[spacetime]{STFDF-class}}
  \item{out}{potential outliers, returned as vector of row names of \code{x$cv@sp}, only returned if \code{out.remove=FALSE} }
  \item{remst}{removed locations as an object of \link[sp]{Spatial-class}, if \code{out.remove=TRUE} }
  \item{remobs}{removed locations with observations as an object of \link[spacetime]{STFDF-class}, if \code{out.remove=TRUE} }
}
\references{
%% ~put references to the literature/web site here ~
}
\author{Milan Kilibarda \email{kili@grf.bg.ac.rs}  }
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
 \code{\link{regdata}}
 \code{\link{meteo2STFDF}}
 \code{\link{tgeom2STFDF}}
 
}
\examples{
# prepare data
# load observation - data.frame of mean temperatures
data(dtempc) 
data(stations)
# create STFDF
temp <- meteo2STFDF(dtempc,stations)
str(temp)
# Adding CRS
temp@sp@proj4string <- CRS('+proj=longlat +datum=WGS84')

# load covariates for mean temperatures
data(regdata)
str(regdata)

# Calculate prediction of mean temperatures for "2011-07-05" "2011-07-06"
# global model is used for regression and variogram

res= pred.strk(temp,zcol=1, newdata= regdata[,1:2], threshold.res=10 )

# plot prediction
stplot(res$pred, col.regions=bpy.colors())

# plot cross validation residuals 
stplot(res$cv[,,'resid.cv'] , col.regions=bpy.colors())

# plot locations of removed stations
spplot(res$remst, zcol='station_name' , col.regions=bpy.colors())
# plot removed stations as time-series
stplot(res$remobs[1:3,1:2,c('tempc','pred.cv')], mode='tp')

row.names(res$remobs@sp) = res$remst$station_name
res$remobs[1:3,1:2,c('tempc','pred.cv')]
stplot(res$remobs[1:3,1:2,c('tempc','pred.cv')], mode='tp')

# Calculate prediction of mean temperature for "2011-07-05" "2011-07-06"
# only MODIS is used as covariate

rkmod <-  pred.strk(temp,zcol=1, newdata= regdata[,1:2], threshold.res=10, 
              dynamic.cov='modis', static.cov=NULL,
               reg.coef= c(-0.23,0.7303284),
               vgm.model= vgmST("sumMetric",space=vgm( 18.27, "Sph", 6000, 3.22),
                                           time =vgm(0, "Sph",  0.1, 0),
                                           joint=vgm(8.34, "Sph", 2349, 1.80),
                                           stAni=583) )
                                           
# coeficients and variogram is calculted globally for GSOD and ECA&D obs. for 2011 year 

stplot(rkmod$pred, col.regions=bpy.colors())

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line