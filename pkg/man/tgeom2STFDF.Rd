\name{tgeom2STFDF}
\alias{tgeom2STFDF}
\title{Calculate geometrical temperature trend
}
\description{Calculate geometrical temperature trend for mean, minimum or maximum temperature.
}
\usage{
tgeom2STFDF(grid, time, endTime=delta(time), variable = "mean",ab=NULL)
}
\arguments{
  \item{grid}{ object of \link[sp]{Spatial-class} (Points, Grid or Pixels) with associated coordinate reference systems (\link[sp]{CRS-class}). If                       CRS is not defined longitude latitude is assumed. }
  \item{time}{object holding time information, reasonably it is day (calendar date), or vector of days
}
   \item{endTime}{end time points. for one day calculation endTime must be defined, as next day}
  \item{variable}{ character;\code{'mean'}, \code{'min'} or \code{'max'} ; geometrical temperature trend is calculated for mean, minimum or maximum; \code{'mean'} is default. }
    \item{ab}{Predefined coefficients to be used instead of incorporated.}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{ \link[spacetime]{STFDF} object with calculated \code{temp_geo} geometrical temperature trend. The calculated values are stored in \code{obj@data} slot.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{Milan Kilibarda \email{kili@grf.bg.ac.rs} }
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
pos <- SpatialPoints(coords = cbind(19.22,45.33)) # create one point from lon lat
tg1 <- tgeom2STFDF(pos,as.POSIXct("2011-01-01"), endTime=as.POSIXct("2011-01-02") )  # temp_geom for 1st Jan 2011
tg1

tg365<- tgeom2STFDF(pos,time = seq(as.POSIXct("2011-01-01"), as.POSIXct("2011-12-31"), by="day") ) # temp_geom for the 2011 at pos location
stplot(tg365, mode='ts')

data(regdata) 
str(regdata@sp) # DEM and TWI data for Serbia at 1 km resolution
spplot(regdata@sp, zcol='dem', col.regions=bpy.colors() )

# temp_geom for Serbia 1st and 2nd Jully 2011
tgSrb<- tgeom2STFDF(regdata@sp,time = seq(as.POSIXct("2011-07-01"), as.POSIXct("2011-07-02"), by="day") ) 

stplot(tgSrb, col.regions = bpy.colors() ) # temp_geom for "2011-07-01" , "2011-07-02"

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line