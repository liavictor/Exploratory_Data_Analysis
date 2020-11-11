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

## Question 6: Compare emissions from motor vehicle sources in Baltimore City with emissions from 
## motor vehicle sources in Los Angeles County, California (\color{red}{\verb|fips == "06037"|}fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

library(sqldf)
library(ggplot2)

vehicle <- subset(SCC, Data.Category == "Onroad")

NEIvehicle <- NEI[(NEI$SCC %in% vehicle$SCC),]

q6d <- sqldf('SELECT year, fips, case when fips="24510" then "Baltimore City, MD" else "Los Angeles County, CA" end as CityName,
             sum(Emissions) as Emissions from NEIvehicle where fips in ("24510","06037") group by year, fips')

png("plot6.png", width=700, height=480)

ggplot(q6d,aes(factor(year),Emissions,fill=year)) +
        geom_bar(position = 'dodge', stat='identity') +
        geom_text(aes(label=round(Emissions,1)), position=position_dodge(width=0.8), vjust=-0.2) +
        facet_grid(.~CityName,scales="free",space="free") + 
        labs(x="year", y=expression("Total PM'[2.5]*' Emission (Tons) ")) + 
        labs(title=expression('Baltimore City and Los Angels County Total PM'[2.5]*' Motor Vehicle Emissions (Tons) by Year'))


dev.off()




