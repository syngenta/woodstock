
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


tagList(
  h4("This Tool"),
  #This text was written by Roger Murfitt
  "This tool was developed in Syngenta to support risk assessments for Birds and Mammals. It aims to provide experts with information on typical rainfall amounts and temperature averages for locations in Europe for consideration with seed residue field trials dissipation data. Data sources are FOCUS Weather Data files.",
  hr(),
  h4("Getting Started"),
  #The following html makes an ordered list of instructions.
  HTML(
    "<ol><li>",
    "Consult the <i class=\"fa fa-book\"></i></sup> <b>Data Sources</b> tab to decide what data sources you want to compare against. Enter your selection in the input sidebar",
    "</li><li>",
    "Enter the date range you are interested in. (e.g. crop sowing period)",
    "</li><li>",
    "Set a day period (DAA) you are interested in (the default is set to the date range specified above)",
    "</li><li>",
    "(optional) Enter an observed rainfall in mm",
    "</li><li>",
    "Hit the <i class=\"fa fa-refresh\"></i> <b>Calculate</b> button",
    "</li><li>",
    "Use the: <i class=\"fa fa-table\"></i></sup> <b>Aggregated Data</b>, <i class=\"fa fa-line-chart\"></i></sup> <b>Graph</b>, and <i class=\"fa fa-percent\"></i></sup> <b>Percentile Statistics</b> tabs to view the results"
    ,
    "</li></ol>"
  ),
  hr(),
  h4("Notes"),
  "When a Date Range input goes over the February-March boundary, leap years will be included in the data output. This leads to the Start and End Date being different in leap years compared to non leap years (though the day period remains constant). If February 29th is selected as a start or end date in the Date range input, February 28th will be used for non leap years.",
  br(),
  tags$a(href = "https://esdac.jrc.ec.europa.eu/projects/focus-dg-sante", "Read about the underlying FOCUS data"),
  h4("Contacts"),
  "Developed by Michael Bird in 2017",
  tags$a(href = "https://github.com/Syngenta/woodstock", "Browse the source code on GitHub"),
  #HTML("<p>Developed by Michael Bird<sup><i class=\"fa fa-resistance\"></i></sup> in 2017 </p>"),
  br(),
  "Email:",
  code("open.publishing@syngenta.com"),
  #make a button that auto opens email client with subject heading about this tool
  HTML(
    "<a href= \"mailto:open.publishing@syngenta.com?Subject=Woodstock%20The%20Rainfall%20Tool:\" target=\"_top\"> <i class=\"fa fa-reply\"></i> </a>"
  ),
  h4("Licence"),
  "Woodstock is made available on a free to use basis subject to the conditions stated in the software licence (GPL v2). By downloading, installing, distributing or using Woodstock you are agreeing to these terms."
  )
