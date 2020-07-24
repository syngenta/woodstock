
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



#server.R


shinyServer(function(input, output, session) {
  
  #I've seperated the different elements of the server.R into seperate files for
  #better readability (and hopefully easier maintenance). Hopefully the file 
  #names are descriptive but incase not...
  #
  # -reactive_events has any parts of the apps that could be phrased as "if X 
  #  happens, do Y",the only current use is to change the theme.
  # -reactive_ui has any user interface inputs that require calculation or 
  #  reactivity
  # -outputs has any user interface outputs, these usually require
  #  calculations and rely on reactive_values
  # -reactive_values has all the R data objects used in outputs, most of these 
  #  are calcultated on a button press
  # -download_managers has all the code needed to enable downloads of results 
  source("server_elements/Woodstock_reactive_events.R", local = T)
  source("server_elements/Woodstock_reactive_ui.R", local = T)
  source("server_elements/Woodstock_outputs.R", local = T)
  source("server_elements/Woodstock_reactive_values.R", local = T)
  source("server_elements/Woodstock_download_managers.R", local = T)
  source("server_elements/Woodstock_make_rain_graph.R",local = T)
  source("server_elements/Woodstock_make_temp_graph.R",local = T)
  source("server_elements/Woodstock_calculate_average_temp.R",local = T)
  source("server_elements/Woodstock_calculate_cumulative_rain.R",local=T)
 
  met_data <- read.csv("data/met_data.csv")
  
  
  session$onSessionEnded(function() {
   stopApp()
  })
  
  
})
