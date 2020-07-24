
# Copyright Syngenta Limited 2020
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
#                                                                    your option) any later version.
# 
# THIS PROGRAM IS MADE AVAILABLE FOR DISTRIBUTION WITHOUT ANY FORM OF WARRANTY TO THE 
# EXTENT PERMITTED BY APPLICABLE LAW.  THE COPYRIGHT HOLDER PROVIDES THE PROGRAM \"AS IS\" 
# WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT  
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
# PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM LIES
# WITH THE USER.  SHOULD THE PROGRAM PROVE DEFECTIVE IN ANY WAY, THE USER ASSUMES THE
# COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION. THE COPYRIGHT HOLDER IS NOT 
# RESPONSIBLE FOR ANY AMENDMENT, MODIFICATION OR OTHER ENHANCEMENT MADE TO THE PROGRAM 
# BY ANY USER WHO REDISTRIBUTES THE PROGRAM SO AMENDED, MODIFIED OR ENHANCED.
# 
# IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL THE 
# COPYRIGHT HOLDER BE LIABLE TO ANY USER FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL,
# INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
# PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE
# OR LOSSES SUSTAINED BY THE USER OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO 
# OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER HAS BEEN ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGES.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


Make_Temp_Graph <- function(input,MyTable ){
Percentiles <-
  as.numeric(unlist(strsplit(input$PercentilesRaw, ","))) / 100
validate(need(
  all(Percentiles >= 0 & Percentiles <= 1),
  "Percentiles should be between 0 and 100"
))

quantiles <-
  quantile(MyTable$Avg.Temp, Percentiles) #Calculate quantiles from agg data

Obs.Percentile <-
  ecdf(MyTable$Avg.Temp)(input$Observed.Temp) # Find where the observed rain falls in the distribution

locations <-
  paste(c(input$FOCUSGWSelected, input$FOCUSSWSelected),
        collapse = " & ")

MyQuan = data.frame(
  x = c(quantiles, NA),
  #quantile value
  y = c(Percentiles, NA),
  #coresponding percentile
  Percentile = as.character(c(100 * Percentiles, "Observed Temperature")) #human friendly print value
)
if (!is.null(input$Observed.Temp)) {
  MyQuan[nrow(MyQuan), 1] <- input$Observed.Temp
  MyQuan[nrow(MyQuan), 2] <- Obs.Percentile
  #used to detect if a rainvalue is needed to be plotted.
} else{
  MyQuan <- MyQuan %>% dplyr::filter(Percentile != "Observed Temperature")
}
MyQuan$Label <- paste0("Percentile: ",format(100* MyQuan$y,digits = 4), "\nObserved Temperature: ", round(MyQuan$x,2))
nudgeX <- max(MyTable$Avg.Temp)/12
#--------------------
# Plotting parameters
#--------------------

p <- MyTable %>%
  ggplot(aes(x = Avg.Temp)) +
  stat_ecdf() + #CDF function
  geom_point(data = na.omit(MyQuan),
             aes(x = x, y = y, color = Percentile),
             size = 5) +
  geom_label_repel(data = na.omit(MyQuan),
                   aes(label=Label,x=x,y=y,color=Percentile),nudge_y = -0.025,nudge_x = nudgeX, show.legend = F)+
  labs(
    x = paste("Average observed temperature (C) in a", input$Period2, "day period falling between",format(as.Date(input$dateRange[1]),format="%d %B"), "and",format(as.Date(input$dateRange[2]),format="%d %B")),
    y = "Cumulative distribution",
    title = paste(
      "A Cumulative Distribution Function plot describing temperature with the following parameters:"
    ),
    subtitle = paste0(
      if (!is.na(input$Observed.Temp)) {
        paste0("Observed temperature: ",
               input$Observed.Temp, "C",
               "\n")
      } else{
        paste0("")
      },
      "Date range: ",
      format(as.Date(input$dateRange[1]),format="%d %B"),
      " to ",
      format(as.Date(input$dateRange[2]),format="%d %B"),
      "\n",
      "Period: ",
      input$Period2,
      " days",
      "\n",
      "Locations: ",
      locations
    ),
    caption =
      if (!is.na(ecdf(MyTable$Avg.Temp)(input$Observed.Temp))) {
        paste0("Observed Temp falls in the ",
               format(round(
                 100 * ecdf(MyTable$Avg.Temp)(input$Observed.Temp), 2
               ),
               nsmall = 2),
               " percentile")
      } else{
        ""
      }
    
  ) +
  scale_colour_discrete(drop = TRUE) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.1)) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  # set transparency
  theme_minimal()
p
}
