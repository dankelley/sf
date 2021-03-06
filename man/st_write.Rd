% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.R, R/db.R
\name{st_write}
\alias{st_write}
\alias{st_write.sfc}
\alias{st_write.sf}
\alias{st_write.data.frame}
\alias{write_sf}
\alias{dbWriteTable,PostgreSQLConnection,character,sf-method}
\alias{dbWriteTable,DBIObject,character,sf-method}
\title{Write simple features object to file or database}
\usage{
st_write(obj, dsn, layer, ...)

\method{st_write}{sfc}(obj, dsn, layer, ...)

\method{st_write}{sf}(
  obj,
  dsn,
  layer = NULL,
  ...,
  driver = guess_driver_can_write(dsn),
  dataset_options = NULL,
  layer_options = NULL,
  quiet = FALSE,
  factorsAsCharacter = TRUE,
  update = driver \%in\% db_drivers,
  delete_dsn = FALSE,
  delete_layer = FALSE,
  fid_column_name = NULL
)

\method{st_write}{data.frame}(obj, dsn, layer = NULL, ...)

write_sf(..., quiet = TRUE, delete_layer = TRUE)

\S4method{dbWriteTable}{PostgreSQLConnection,character,sf}(
  conn,
  name,
  value,
  ...,
  row.names = FALSE,
  overwrite = FALSE,
  append = FALSE,
  field.types = NULL,
  factorsAsCharacter = TRUE,
  binary = TRUE
)

\S4method{dbWriteTable}{DBIObject,character,sf}(
  conn,
  name,
  value,
  ...,
  row.names = FALSE,
  overwrite = FALSE,
  append = FALSE,
  field.types = NULL,
  factorsAsCharacter = TRUE,
  binary = TRUE
)
}
\arguments{
\item{obj}{object of class \code{sf} or \code{sfc}}

\item{dsn}{data source name (interpretation varies by driver - for some drivers, dsn is a file name, but may also be a
folder or contain a database name) or a Database Connection (currently
official support is for RPostgreSQL connections)}

\item{layer}{layer name (varies by driver, may be a file name without extension); if layer is missing, the
\link{basename} of \code{dsn} is taken.}

\item{...}{other arguments passed to \link{dbWriteTable} when \code{dsn} is a
Database Connection}

\item{driver}{character; name of driver to be used; if missing and \code{dsn} is not a Database Connection, a driver name is guessed from \code{dsn};
\code{st_drivers()} returns the drivers that are available with their properties; links to full driver documentation
are found at \url{http://www.gdal.org/ogr_formats.html}.}

\item{dataset_options}{character; driver dependent dataset creation options; 
multiple options supported.}

\item{layer_options}{character; driver dependent layer creation options; 
multiple options supported.}

\item{quiet}{logical; suppress info on name, driver, size and spatial reference}

\item{factorsAsCharacter}{logical; convert \code{factor} objects into 
character strings (default), else into numbers by \code{as.numeric}.}

\item{update}{logical; \code{FALSE} by default for single-layer drivers but 
\code{TRUE} by default for database drivers as defined by \code{db_drivers}.
For database-type drivers (e.g. GPKG) \code{TRUE} values will make 
\code{GDAL} try to update (append to) the existing data source, e.g. adding
a table to an existing database, or adding records to a layer. See also the
next two arguments and Details.}

\item{delete_dsn}{logical; delete data source \code{dsn} before attempting 
to write?}

\item{delete_layer}{logical; delete layer \code{layer} before attempting to
write?}

\item{fid_column_name}{character, name of column with feature IDs; if
specified, this column is no longer written as feature attribute.}

\item{conn}{DBIObject}

\item{name}{A character string specifying the unquoted DBMS table name,
or the result of a call to \code{\link[DBI:dbQuoteIdentifier]{dbQuoteIdentifier()}}.}

\item{value}{a \link{data.frame} (or coercible to data.frame).}

\item{row.names}{Add a \code{row.name} column, or a vector of length \code{nrow(obj)}
containing row.names; default \code{FALSE}.}

\item{overwrite}{Will try to \code{drop} table before writing; default \code{FALSE}.}

\item{append}{Append rows to existing table; default \code{FALSE}.}

\item{field.types}{default \code{NULL}. Allows to override type conversion from R
to PostgreSQL. See \code{dbDataType()} for details.}

\item{binary}{Send geometries serialized as Well-Known Binary (WKB);
if \code{FALSE}, uses Well-Known Text (WKT). Defaults to \code{TRUE} (WKB).}
}
\value{
\code{obj}, invisibly; in case \code{obj} is of class \code{sfc}, 
it is returned as an \code{sf} object.
}
\description{
Write simple features object to file or database
}
\details{
Columns (variables) of a class not supported are dropped with a warning. 

When updating an existing layer, records are appended to it if the updating
object has the right variable names and types. If names don't match an 
error is raised. If types don't match, behaviour is undefined: GDAL may
raise warnings or errors or fail silently.

When deleting layers or data sources is not successful, no error is emitted. 
\code{delete_dsn} and \code{delete_layer} should be
handled with care; the former may erase complete directories or databases.
}
\examples{
nc = st_read(system.file("shape/nc.shp", package="sf"))
st_write(nc, paste0(tempdir(), "/", "nc.shp"))
st_write(nc, paste0(tempdir(), "/", "nc.shp"), delete_layer = TRUE) # overwrites
data(meuse, package = "sp") # loads data.frame from sp
meuse_sf = st_as_sf(meuse, coords = c("x", "y"), crs = 28992)
# writes X and Y as columns:
st_write(meuse_sf, paste0(tempdir(), "/", "meuse.csv"), layer_options = "GEOMETRY=AS_XY") 
st_write(meuse_sf, paste0(tempdir(), "/", "meuse.csv"), layer_options = "GEOMETRY=AS_WKT",
  delete_dsn=TRUE) # overwrites
\dontrun{
 library(sp)
 example(meuse, ask = FALSE, echo = FALSE)
 try(st_write(st_as_sf(meuse), "PG:dbname=postgis", "meuse_sf",
     layer_options = c("OVERWRITE=yes", "LAUNDER=true")))
 demo(nc, ask = FALSE)
 try(st_write(nc, "PG:dbname=postgis", "sids", layer_options = "OVERWRITE=true"))
}
}
\seealso{
\link{st_drivers}
}
