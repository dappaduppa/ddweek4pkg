% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_fucntions.R
\name{fars_read_years}
\alias{fars_read_years}
\title{"fars_read_years" function return the dataframe containing
1) MONTH and 2) year
For the given vector of "years", in a file.}
\usage{
fars_read_years(years)
}
\arguments{
\item{years}{years vector.}
}
\value{
dataframe containing MONTH and year For the given vector of "years", in a file.

Error : If the given year is not found with the prepared filename by "make_filename", then
error is thrown as "invalid year: ": xxxx
where xxxx is invalid year.
}
\description{
This is utility function.
This is called internally, by "fars_summarize_years" function.
not intended for user call.
}
\examples{
\dontrun{
fars_read_years(c("2013", "2014"))
}

}
