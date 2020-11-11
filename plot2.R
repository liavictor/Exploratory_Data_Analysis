## Exploratory Data Analysis Course Project #2
## Prepare dataset: step 1 download and unzip the file
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destFile <- "exdata_data_NEI_data.zip"
if (!file.exists(destFile)){
        download.file(URL, destfile = destFile, mode='wb')
}
if (!file.exists("./Source_Classification_Code.rds")){
        unzip(destFile)
}
## Prepare dataset: step 2 read rds datasets from unzipped rds files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


## Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (\color{red}{\verb|fips == "24510"|}fips == "24510") 
## from 1999 to 2008? Use the base plotting system to make a plot answering this question.
#install.packages("sqldf")
library(sqldf)
library(RColorBrewer)

q2d <- sqldf('SELECT year, sum(Emissions) as Emissions from NEI where fips = "24510" group by year')

# or subset & aggreagate: subnei <- subset(NEI, fips == "24510" )
#                         q2d2 <- aggregate(Emissions ~ year, subnei, sum)

q2col <- brewer.pal(4, "Set3")

png("plot2.png", width=480, height=480)

q2 <- barplot(height=(q2d$Emission)/1000
              ,names.arg = q2d$year
              ,xlab="year"
              ,ylim=c(0,4)
              ,ylab=expression('Total PM'[2.5]*' Emission (Kilotons)')
              ,main=expression('Total PM'[2.5]*' Emissions (Kilotons) by Year in Baltimore City, Maryland')
              ,col=q2col)

text(x = q2
     ,y = round(q2d$Emissions/1000,2)
     ,label = round(q2d$Emissions/1000,2)
     ,pos = 3
     ,cex = 0.8
     ,col = "black")

dev.off()

