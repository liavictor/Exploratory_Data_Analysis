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

## Question 5: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
library(ggplot2)

vehicle <- subset(SCC, Data.Category == "Onroad")

NEIvehicle <- NEI[(NEI$SCC %in% vehicle$SCC),]

q5d1 <-  subset(NEIvehicle, fips=="24510")

q5d <- aggregate(Emissions ~ year, q5d1, sum)

png("plot5.png", width=480, height=480)

ggplot(q5d,aes(factor(year),Emissions,fill=year)) +
        geom_bar(position = 'dodge', stat='identity') +
        geom_text(aes(label=round(Emissions,1)), position=position_dodge(width=0.8), vjust=-0.2) +
        facet_grid(.~year,scales = "free",space="free") + 
        labs(x="year", y=expression("Total PM'[2.5]*' Emission (Tons)")) + 
        labs(title=expression('Total PM'[2.5]*' Motor Vehicle Emissions (Tons) by Year in Baltimore City'))

dev.off()




