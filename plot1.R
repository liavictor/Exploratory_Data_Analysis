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

## Question 1: Have total emissions from PM2.5 decreased in the United States
## from 1999 to 2008? Using the base plotting system,
## make a plot showing the total PM2.5 emission from all sources

#install.packages("sqldf")
library(sqldf)
library(RColorBrewer)

q1d <- sqldf('SELECT year, sum(Emissions) as Emissions FROM NEI group by year')

# or aggreagate: q1d1 <- aggregate(Emissions ~ year, NEI, sum)

q1col <- brewer.pal(4, "Accent")

png("plot1.png", width=480, height=480)

q1 <- barplot(height=(q1d$Emission)/1000
              ,names.arg = q1d$year
              ,ylim=c(0,8000)
              ,xlab="year"
              ,ylab=expression('Total PM'[2.5]*' Emission (Kilotons)')
              ,main=expression('Total PM'[2.5]*' Emissions (Kilotons) by Year in United States')
              ,col=q1col)
text(x = q1
     ,y = round(q1d$Emissions/1000,2)
     ,label = round(q1d$Emissions/1000,2)
     ,pos = 3
     ,cex = 0.8
     ,col = "black")

dev.off()
