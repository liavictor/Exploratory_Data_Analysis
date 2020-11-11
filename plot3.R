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

## Question 3: Of the four types of sources indicated by the \color{red}{\verb|type|}type (point, nonpoint, onroad, nonroad) variable, 
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
## Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.
#install.packages("sqldf")
#install.packages("ggplot2")
library(sqldf)
library(ggplot2)


q3d <- sqldf('SELECT year, type, sum(Emissions) as Emissions from NEI where fips = "24510" group by year, type')

png("plot3.png", width = 800, height = 600)

ggplot(q3d,aes(factor(year),Emissions,fill=type)) +
        geom_bar(position = 'dodge', stat='identity') +
        geom_text(aes(label=round(Emissions,1)), position=position_dodge(width=0.8), vjust=-0.2) +
        facet_grid(.~type,scales = "free",space="free") + 
        labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title=expression("Total PM"[2.5]*" Emissions (Tons) by Year and Source Type in Baltimore City, Maryland"))

dev.off()




