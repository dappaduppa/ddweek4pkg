#' fars_read: Convert the csv file content into data frame.
#'
#' This is utility function.
#' This is called internally, called from "fars_read_years"
#' not intended for user call.
#'
#'
#' @source US National Highway Traffic Safety Administration's Fatality Analysis Reporting System.
#' \url{https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars}
#'
#' @source Column level understanding following link/pdf is referred.
#' \url{http://www.nber.org/fars/ftp.nhtsa.dot.gov/fars/FARS-DOC/Analytical User Guide/USERGUIDE-2015.pdf}
#'
#' @importFrom readr read_csv
#'
#' @param filename ( sample : accident_2013.csv.bz2 )
#' @return data frame with the columns, mentioned below.
#'
#' @format A data frame with columns:
#' \describe{
#' \item{STATE}{State (as number)}
#' \item{ST_CASE}{State Case Number}
#' \item{VE_TOTAL}{Number of Vehicle Forms Submitted- ALL}
#' \item{VE_FORMS}{Number of Motor Vehicles in Transport (MVIT)}
#' \item{PVH_INVL}{Number of Parked/Working Vehicles}
#' \item{PEDS}{Number of Forms Submitted for Persons Not in Motor Vehicles}
#' \item{PERNOTMVIT}{Number of Persons Not in Motor Vehicles in Transport (MVIT) }
#' \item{PERMVIT}{Number of Persons in Motor Vehicles in Transport (MVIT) }
#' \item{PERSONS}{Number of Forms Submitted for Persons in Motor Vehicles}
#' \item{COUNTY}{County}
#' \item{CITY}{City}
#' \item{DAY}{Day of Crash}
#' \item{MONTH}{Month of Crash}
#' \item{YEAR}{Year of Crash}
#' \item{DAY_WEEK}{Day of Week}
#' \item{HOUR}{Hour of Crash}
#' \item{MINUTE}{Minute of Crash}
#' \item{NHS}{National Highway System}
#' \item{ROAD_FNC}{Roadway Function Class (discontinued)}
#' \item{ROUTE}{Route Signing}
#' \item{TWAY_ID}{Trafficway Identifier}
#' \item{TWAY_ID2}{Trafficway Identifier}
#' \item{MILEPT}{Milepoint}
#' \item{LATITUDE}{Latitude}
#' \item{LONGITUD}{Longitude}
#' \item{SP_JUR}{Special Jurisdiction}
#' \item{HARM_EV}{First Harmful Event}
#' \item{MAN_COLL}{Manner of Collision}
#' \item{RELJCT1}{Relation to Junction- Within Interchange Area}
#' \item{RELJCT2}{Relation to Junction- Specific Location }
#' \item{TYP_INT}{Type of Intersection}
#' \item{WRK_ZONE}{Work Zone}
#' \item{REL_ROAD}{Relation to Trafficway}
#' \item{LGT_COND}{Light Condition}
#' \item{WEATHER1}{Atmospheric Conditions}
#' \item{WEATHER2}{Atmospheric Conditions}
#' \item{WEATHER}{Atmospheric Conditions}
#' \item{SCH_BUS}{School Bus Related}
#' \item{RAIL}{Rail Grade Crossing Identifier}
#' \item{NOT_HOUR}{Hour of Notification}
#' \item{NOT_MIN}{Minute of Notification}
#' \item{ARR_HOUR}{Hour of Arrival at Scene}
#' \item{ARR_MIN}{Minute of Arrival at Scene}
#' \item{HOSP_HR}{Hour of EMS(Emergency Medical Service. e.g.Ambulance) Arrival at Hospital}
#' \item{HOSP_MN}{Minute of EMS(Emergency Medical Service. e.g.Ambulance) Arrival at Hospital}
#' \item{CF1}{Crash Level Factor 1}
#' \item{CF2}{Crash Level Factor 2}
#' \item{CF3}{Crash Level Factor 3}
#' \item{FATALS}{Fatalities}
#' \item{DRUNK_DR}{The DRUNK_DR data element on the Crash level was incorrectly derived on all person
#' types from 1999 through 2007. Since then, it was derived based on all person types rather than
#' based on Drivers only. Furthermore, the data element name (DRUNK_DR) implies that the
#' individual was drunk, however, it actually captures those individuals whom the police reported
#' alcohol involvement OR who tested positive for alcohol (i.e. their blood alcohol concentration
#' was .01 g/dL or greater). Beginning with the 2008 Final FARS data file, DRUNK_DR has been
#' derived for Drivers only}
#' }
#'
#' Error: throws error if the supplied file "foo" is not found, then throws the following error message
#' "file foo does not exist"
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2013.csv.bz2")
#' }
#'
#'
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' make_filename: For the given "year", format and return filename string(as it is stored in file system).
#'
#' This is utility function.
#' This is called internally, by "fars_read_years", and "fars_map_state" function.
#' not intended for user call.
#'
#' @param year . sample : 2013
#'
#' @return file name : sample : accident_2013.csv.bz2
#'
#' @examples
#' \dontrun{
#' make_filename("2013")
#' }
#'
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("inst/extdata/accident_%d.csv.bz2", year)
}

#' "fars_read_years" function return the dataframe containing
#' 1) MONTH and 2) year
#' For the given vector of "years", in a file.
#'
#' This is utility function.
#' This is called internally, by "fars_summarize_years" function.
#' not intended for user call.
#'
#' @import magrittr
#' @importFrom dplyr mutate select
#'
#' @param years years vector.
#' @return dataframe containing MONTH and year For the given vector of "years", in a file.
#'
#' Error : If the given year is not found with the prepared filename by "make_filename", then
#' error is thrown as "invalid year: ": xxxx
#' where xxxx is invalid year.
#'
#' @examples
#' \dontrun{
#' fars_read_years(c("2013", "2014"))
#' }
#'
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      # print(dat)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}


#' summarize the no of fatals by MONTH, for each year in the spread format.
#'
#'
#' sample input and output
#' ------------------------------------
#' > fars_summarize_years(c(2013,2014))
#' # A tibble: 12 x 3
#' MONTH `2013` `2014`
#' <int>  <int>  <int>
#' 1     1   2230   2168
#' 2     2   1952   1893
#' 3     3   2356   2245
#' 4     4   2300   2308
#' 5     5   2532   2596
#' 6     6   2692   2583
#' 7     7   2660   2696
#' 8     8   2899   2800
#' 9     9   2741   2618
#' 10    10   2768   2831
#' 11    11   2615   2714
#' 12    12   2457   2604
#'
#' @import magrittr
#' @importFrom tidyr spread
#' @importFrom dplyr bind_rows group_by summarize
#'
#' @param years sample c(2013,2014)
#' @return summary of the no of fatals by MONTH, for each year in the spread format.
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(c("2013", "2014"))
#' }
#' @export
#'
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  # print(dat_list)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' Draw the map and point grpah to denote the accidents.
#'
#' This is called by the user.
#'
#' 1) First draw the "state", by getting the min, max . i.e. the given range of lat, long
#' 2) Then "point" it with all "data"(lat, long) of the corresponding state.
#'
#' @param state.num state number
#' @param year year
#'
#' sample state.num and the corresponding state.
#' ---------------------------------------------
#' 01 Alabama
#' 02 Alaska
#' 04 Arizona
#' 05 Arkansas
#' 06 California
#' 08 Colorado
#' 09 Connecticut
#' 10 Delaware
#' 11 District
#' 12 Florida
#' 13 Georgia of Columbia
#' 15 Hawaii
#' 16 Idaho
#' 17 Illinois
#' 18 Indiana
#' 19 Iowa
#' 20 Kansas
#' 21 Kentucky
#' 22 Louisiana
#' 23 Maine
#' 24 Maryland
#' 25 Massachusetts
#' 26 Michigan
#' 27 Minnesota
#' 28 Mississippi
#' 29 Missouri
#' 30 Montana
#' 31 Nebraska
#' 32 Nevada
#' 33 New Hampshire
#' 34 New Jersey
#' 35 New Mexico
#' 36 New York
#' 37 North Carolina
#' 38 North Dakota
#' 39 Ohio
#' 40 Oklahoma
#' 41 Oregon
#' 42 Pennsylvania
#' 43 Puerto Rico
#' 44 Rhode Island
#' 45 South Carolina
#' 46 South Dakota
#' 47 Tennessee
#' 48 Texas
#' 49 Utah
#' 50 Vermont
#' 51 Virginia
#' 52 Virgin Islands (since 2004)
#' 53 Washington
#' 54 West Virginia
#' 55 Wisconsin
#' 56 Wyoming
#'
#' Error:
#'    1) If the state.num is not valid, then
#'        "invalid STATE number: <state.num/>" is thrown.
#'    2) If there are no data found for the given state.num and year, then
#'        "no accidents to plot" is thrown.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#'
#' @examples
#' \dontrun{
#'   fars_map_state(1,2013)
#'   fars_map_state(2,2013)
#'   fars_map_state(36,2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
