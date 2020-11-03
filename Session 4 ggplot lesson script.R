
#----------R Training Session 4-------------#
#       Data Visualization: ggplot          #
#-------------------------------------------#

# ggplot allows the user to make customizable graphs and plots using a 
# highly flexible grammar of graphics. For simple visuals, there are three 
# main arguments needed: DATA, AESTHETIC MAPPINGS, GEOMS
# other arguments include, labels, scales, statistics, & themes



#-------------------------------------------------------
# ---- (0) Loading Tidyverse Package----- 
#--------------------------------------------------------
# Ggplot is part of Tidyverse. We will use dplyr as well, so let's just load Tidyverse
install.packages("tidyverse")
library(tidyverse)



#--------------------------------------------------------
# ---- (1) Introducing ggplot----- 
#--------------------------------------------------------

# Let's introduce a very simple ggplot example.
# This example uses the pre-loaded mpg datset, which stores information on various automobiles
# tip: when coding for aes(), the order of variables is x,y

# View the dataset
View(mpg)

# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

#. 0. Warm-up: type each of the following lines 5 times, but don't execute the code. 
# Seriously.....do it:

# ggplot()
# data = mpg,
# mapping = aes(x,y) +
# geom_line ()



# Now, first plot
# the hwy column tell us the highway fuel economy 
# the displ column tells us the size of the engine

ggplot(data = mpg, mapping = aes(displ, hwy)) +
  geom_point()

# change the geom to line graph
ggplot(data = mpg, mapping = aes(displ, hwy)) +
  geom_line()

# change the variables
# 'cty' tells us the city fuel economy 
ggplot(data = mpg, mapping = aes(cty, hwy)) +
  geom_line()

# what happens here?
ggplot(data = mpg, mapping = aes(cty, hwy)) +
  geom_point()
# goes back to scatter plot

# combination graph 
ggplot(data = mpg, mapping = aes(cty, hwy)) +
  geom_point() +
  geom_line ()


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 1. Using the mpg dataset, please create a line graph with the variables, 
# cty and displ. cty is y-axis, displ is x-axis 
# 1a. Using same variables, add a scatter plot too 





#--------------------------------------------------------
# ---- (2) Adding addtional arguments, ie. options----- 
#--------------------------------------------------------

# when coding options, depending on the value, it should be coded in either
# the aesthetic argument, or the geom argument or neither
# values that represent a variable in the data should be in aesthetic argument
# values that are manually set should be in geom argument (ex: 3, 0.4, "blue")


# adding color
# for list of colors in R: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
ggplot(data = mpg, mapping = aes(displ, hwy)) +
  geom_point(color = "blue")

ggplot(data = mpg, mapping = aes(displ, hwy)) +
  geom_point(color = "dark green")

# stratifying data points by a group
# drv represents drivetrain. what happens?
ggplot(data = mpg, mapping = aes(cty, hwy, color = drv)) +
  geom_point ()


# adding size (default is 1 for manual setting)
ggplot(data = mpg, mapping = aes(displ, hwy)) +
  geom_point(size = 4)

ggplot(data = mpg, mapping = aes(displ, hwy)) +
  geom_point(size = 0.4)

# adding different shapes for points on scatter plots  
ggplot(data = mpg, mapping = aes(cty, hwy, shape = drv)) +
  geom_point ()

# combining different options
# pay attention to where the options go
ggplot(data = mpg, mapping = aes(cty, hwy, shape = drv, color = drv)) +
  geom_point (size = 3)

#add labels and title
# the scale_ argument allows for additional options if desired
# scale_x_continuous for continuous variables
# scale_x_discrete for categorical or text 
ggplot(data = mpg, mapping = aes(cty, hwy, shape = drv, color = drv)) +
  geom_point (size = 3) +
  scale_x_continuous(name = "City MPG") +
  scale_y_continuous(name = "Highway MPG") + 
  ggtitle("City & Highway Fuel Economy")

# modifying the legend
# legends only appear for options other than X,Y!
ggplot(data = mpg, mapping = aes(cty, hwy, shape = drv, color = drv)) +
  geom_point (size = 3) +
  scale_x_continuous(name = "City MPG") +
  scale_y_continuous(name = "Highway MPG") + 
  ggtitle("City & Highway Fuel Economy") +
  labs(shape = "Drivetrain", color = "Drivetrain")

# removing legend 
ggplot(data = mpg, mapping = aes(cty, hwy)) +
  geom_point (size = 3) +
  scale_x_continuous(name = "City MPG") +
  scale_y_continuous(name = "Highway MPG") + 
  ggtitle("City & Highway Fuel Economy") +
  theme(legend.position = "none")

# adding themes. there are many themes..
ggplot(data = mpg, mapping = aes(cty, hwy, shape = drv)) +
  geom_point () + 
  theme_bw()

# theme_classic() removes gridlines and plot outlines
ggplot(data = mpg, mapping = aes(cty, hwy, shape = drv, color = drv)) +
  geom_point (size = 3) +
  scale_x_continuous(name = "City MPG") +
  scale_y_continuous(name = "Highway MPG") + 
  ggtitle("City & Highway Fuel Economy") +
  labs(shape = "Drivetrain", color = "Drivetrain")+
  theme_classic()


# ------------------
# bubble graph 
# ------------------
# a bubble graph is just a scatter plot where the width of the point is determined by a variable
# the option for varying the transparency of a bubble is 'alpha'

ggplot(data = mpg, mapping = aes(hwy, cty, size = displ )) +
  geom_point(alpha = .15, color = "dark blue") +
  ggtitle("MPG with Engine Size as Width of Bubble")+
  theme_classic()




# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2. Using the mpg dataset, please create a scatter plot with the variables, 
# cty and displ. cty is y-axis, displ is x-axis 
# 2a. Using same variables, add a color option where color equals drv (hint: aes or geom?)
# 2b. Then, add a size option where size equals hwy
# 2c. Instead of size being equal to hwy, make it 3 and think about where it goes in the code
# 2d. change the transparency level to 0.2 
# 2e. add labels: title: Engine size and City MPG, x-axis: Engine Size, y-axis: city MPG








#--------------------------------------------------------
# ---- (3) Line Graphs using MSD ----- 
#--------------------------------------------------------
# first step is to import the txt file:
txt <- read_tsv(file = "RawData/ex2_data.txt", 
                col_types = cols(MechanismID        = "c",
                                 AgeAsEntered       = "c",            
                                 AgeFine            = "c",     
                                 AgeSemiFine        = "c",    
                                 AgeCoarse          = "c",      
                                 Sex                = "c",     
                                 resultStatus       = "c",     
                                 otherDisaggregate  = "c",     
                                 coarseDisaggregate = "c",     
                                 FY2017_TARGETS     = "d",
                                 FY2017Q1           = "d",      
                                 FY2017Q2           = "d",      
                                 FY2017Q3           = "d",      
                                 FY2017Q4           = "d",      
                                 FY2017APR          = "d",
                                 FY2018Q1           = "d",
                                 FY2018Q2           = "d",
                                 FY2018_TARGETS     = "d",
                                 FY2019_TARGETS     = "d"))

# We want a line graph that shows trend over time for positives(HTS_TST_POS) found over 3 quarters
# the first step is transforming our data so we can build this graph
# we need to have a dataset with the time periods, their aggregate HTS_TST value, 
# and both need to be in column form. 
# this happens in multiple steps and is part of the transform step in the data model

# by default, line graphs require two continuous variables  
pos1 <-txt %>%
  filter(indicator=="HTS_TST_POS" & standardizedDisaggregate=="Total Numerator") %>% 
  select(FY2017Q4, FY2018Q1, FY2018Q2) %>% 
  gather(period) %>% 
  group_by(period) %>% 
  summarise(htsvalue = sum(value, na.rm=TRUE)) %>%
  ungroup()
  

# using the group option allows us to use a non-continuous variable
ggplot(data=pos1, mapping = aes(period, htsvalue, group = 1)) +
  geom_line() + 
  scale_x_discrete(name = "Time Period")+
  scale_y_continuous(name = "# of HIV Positives")+
  ggtitle("# of Positives Over Time") +
  theme_classic()


# what if we want to add additional groups like FundingAgency? one line per group 
pos2<-txt %>%
  filter(indicator=="HTS_TST_POS" & standardizedDisaggregate=="Total Numerator") %>% 
  select(FundingAgency, FY2017Q4, FY2018Q1, FY2018Q2) %>% 
  gather(period, value, FY2017Q4, FY2018Q1, FY2018Q2) %>% 
  group_by(FundingAgency, period) %>% 
  summarise(htsvalue = sum(value, na.rm=T)) %>%
  ungroup()

ggplot(data=pos2, mapping = aes(period, htsvalue, color = FundingAgency, group = FundingAgency))+
  geom_line() + 
  scale_x_discrete(name = "Time Period")+
  scale_y_continuous(name = "# of HIV Positives")+
  ggtitle("# of Positives Over Time") +
  theme_classic()


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 3. Import the ex2_data.txt dataset and name it test. Feel free to copy and paste the code 
# from the lesson script above 
# Find out how many patients are newly receiving treatment over the past three quarters 
# 3a. Create an intermediate dataset that has data for TX_NEW total numerator and 
# aggregate totals from 17Q4-18Q2 just like the way it was done in the lesson example 
# 3b. create a line graph with period on x-axis and aggregate values on Y -axis, use group =1 statement
# 3c. add axis labels and title. use scale_x_discrete for x-axis label
# 3d. Choose a theme and/or other options if you wish 








#--------------------------------------------------------
# ---- (4) Bar Graphs ----- 
#--------------------------------------------------------

# bar graphs require a single discrete variable

# for our first example, we will do a simple analysis
# what does the output tell us?
ggplot(data= txt, mapping = aes(FundingAgency)) +
  geom_bar(width = .8) +
  theme_classic() +
  ggtitle ("Who entered more data here?")



# let's graph something more meaningful for our second example, 
# let's graph the number of HIV tests given by OU
# geom for bar graph is geom_bar

# first, transform the dataset
hts <- filter(txt, indicator == "HTS_TST" & standardizedDisaggregate == "Total Numerator")

ggplot(data=hts, mapping = aes(OperatingUnit)) + 
  geom_bar()

# we don't want the count. So we need to choose a different statistic. 
# in order to show a frequency on the Y axis, we need to add a Y-axis to the mapping argument and 
# use stat = "identity" argument 
# this is called a statistical transformation 

ggplot(data= hts, mapping = aes(OperatingUnit, FY2018Q2)) + 
  geom_bar(stat = "identity")
  
# let's look at the PSNUs in Westeros
hts2 <- filter(hts, OperatingUnit == "Westeros")
ggplot(data= hts2, mapping = aes(PSNU, FY2018Q2)) + 
  geom_bar(stat = "identity")


# to do a stacked bar graph, the 'fill' option must be used in the mapping argument 
# this example stacks the PSNUs in each bar
ggplot(data= hts, mapping = aes(OperatingUnit, FY2017Q4, fill = PSNU)) + 
  geom_bar(stat = "identity") +
  theme_classic() +
  ggtitle ("Number of HIV tests by OU and their PSNUs")




# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4.  Use the test dataset to start with
# 4a. Transform the data. Keep only TX_NEW, Total Numerator in the dataset
# 4b. Create a bar chart for OperatingUnit
# 4c. We don't want count, so add FY2018Q2 as the y value, 
#     and figure out how to display frequency in the graph
# 4d. Display a stacked bar graph instead, with FundingAgency as the 'fill' option
# 4e. Add a title of your choice 
# 4f. Add a theme of your choosing, make it elegant 







#--------------------------------------------------------
# ---- (5) Histogram & Density Plot ----- 
#--------------------------------------------------------

# histogram shows the count of the appearance of a certain value
# histograms require a single continuous variable

ggplot(data = mpg, mapping = aes(hwy)) + 
  geom_histogram(fill="tomato3")+
  theme_classic() +
  ggtitle("Class of Car by Highway MPG")

# with binwidth
ggplot(data = mpg, mapping = aes(hwy)) + 
  geom_histogram(fill="tomato3", binwidth = 5)+
  theme_classic() +
  ggtitle("Class of Car by Highway MPG")

# changing # of bins (in other words, how many bars there are)
ggplot(data = mpg, mapping = aes(hwy)) + 
  geom_histogram(fill="tomato3", bins = 10)+
  theme_classic() +
  ggtitle("Class of Car by Highway MPG")

# adding a group to make staced bars
ggplot(data = mpg, mapping = aes(hwy, fill=class)) + 
  geom_histogram()+
  theme_classic() +
  ggtitle("Class of Car by Highway MPG")

# density plot is another form of a histogram 
# again these also require a continuous variable 
ggplot(data = mpg, mapping = aes(class, fill = class)) + 
  geom_density() +
  theme_classic()



#--------------------------------------------------------
# ---- (6) Violin Graph ----- 
#--------------------------------------------------------

# these graphs are good for showing distribution and frequency of values within a group 
# requires a discrete variable and a continuous variable

ggplot(mpg, aes(class, cty, color = class)) +
geom_violin() + 
  ggtitle("City MPG vs Class of vehicle") +
  scale_x_discrete(name = "Class of Vehicle") +
  scale_y_continuous(name = "City MPG")+
  theme_classic()+
  theme(legend.position = "none")
     


#--------------------------------------------------------
# ---- (7) Faceting (facet_wrap)----- 
#--------------------------------------------------------

# faceting creates small multiples, which is a series of graphs 
# with the same scale and axes that allow for easy comparisons 
# uses facet_wrap arugment

#must use the ~ in facet_wrap argument 
ggplot(data = mpg, mapping = aes(cty, hwy)) + 
  geom_point() +
  facet_wrap(~drv)

#by type of automobile
ggplot(data = mpg, mapping = aes(cty, hwy)) + 
  geom_point() +
  facet_wrap(~class)

#specifying columns or rows
ggplot(data = mpg, mapping = aes(cty, hwy)) + 
  geom_point() +
  facet_wrap(~class, ncol = 2)

# separate scales
ggplot(data = mpg, mapping = aes(cty, hwy)) + 
  geom_point() +
  facet_wrap(~class, scale = "free")  

#fully loaded
ggplot(data = mpg, mapping = aes(cty, hwy, color = class)) + 
  geom_point() +
  facet_wrap(~class, scale = "free") + 
  theme_classic() +
  scale_x_continuous(name = "city MPG")+
  scale_y_continuous(name = "highway MPG") +
  theme(legend.position = "none")


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 5. Using the mpg dataset, create a scatterplot with displ on the x axis and hwy on the y axis
# 5a. add a facet_wrap and facet on model. 
# 5b. that was a joke...too many graphs. Facet on manufacturer instead.
# Are some creating more efficient vehicles than others?
# 5c. add axis labels, displ is engine size, hwy is highway MPG
# 5d. add a theme of your choice
# 5e. make the number of columns 3 by using ncol in the facet_wrap argument
# 5f. add the color option to the mapping argument, color should be year. See anything interesting?
# don't be afraid to expand the plot menu to view the plot better!






#--------------------------------------------------------
# ---- (8) Global vs Local ----- 
#--------------------------------------------------------

# ------- Exercise Question(s) -------------
# Let's discuss:

# What will be the difference between the outputs below? 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))


# ------------

# arguments in the ggplot line will be global, they will extend to every geom listed
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

# arguments in the geom line(s) will be local to that geom only
ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))


# the upshot here is that is makes a difference where the options and the argument are laid out
# if you are creating many plots with the same parameters and options, then placing the options
# in the global ggplot line makes more sense
# however, if each plot will have different options and features, then you need to code the options
# into the geom arguments 




#--------------------------------------------------------
# ---- (9) Exporting Graphs (ggsave) ----- 
#--------------------------------------------------------

# all you need to input is the filename for the export, 
# and R will export the last graph that was produced

# 1. Create a plot
# The plot is displayed on the screen
ggplot(mtcars, aes(wt, mpg)) 
+ geom_point()
# 2. Then, save the plot to a pdf or png
ggsave("Outputs/myplot.pdf")
ggsave("Outputs/myplot.png")

# use options width and height to change the fit of the graph in the output file
ggsave("Outputs/myplot.pdf", width = 5, height = 5)


# ------- Exercise Question(s) -------------
# Find your favorite plot from the lesson, run it, and export it as "Outputsfavplot.pdf":







#--------------------------------------------------------
# ---- (10) Additinoal visualizations using MER data ----- 
#--------------------------------------------------------
sites <- read_tsv("./RawData/ICPI_TRAINING_GoT_site_lat_long_MER_20181017.txt")

View(sites)

## Looking at yield of sites by volume 
# caculate yield:
sites2 <- sites %>% mutate(yield = hts_tst_pos/hts_tst)

# Plotly version of the graph 
bub1 <- ggplot(data = sites2, 
               mapping = aes(hts_tst, yield, 
                             size = hts_tst_pos,
                             fill = f_c)) +
  geom_point(shape = 21) +
  theme_bw() 



#--------------------------------------------------------
# ---- (11) GGplotly ----- 
#--------------------------------------------------------

# ggplotly allows a graph that is produced with ggplot to have interactive properties 
# below is an example. Please run the code and play with the outputs. 

if(!require(plotly)){
  install.packages("plotly")
}
library(plotly)


ggplotly(bub1)


# Plot from section 4
plot1 <- ggplot(data= hts, mapping = aes(OperatingUnit, FY2018Q2, fill = PSNU)) + 
  geom_bar(stat = "identity") +
  theme_classic() 

ggplotly(plot1)


# Plot from section 3
plot2 <- ggplot(data=pos2, mapping = aes(period, htsvalue, color = FundingAgency, group = FundingAgency))+
  geom_line() + 
  scale_x_discrete(name = "Time Period")+
  scale_y_continuous(name = "# of HIV Positives")+
  ggtitle("# of Positives Over Time") +
  theme_classic()

ggplotly(plot2)


 



