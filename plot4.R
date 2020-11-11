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

## Question 4: Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

library(ggplot2)

Coal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)

CoalSubSCC <-  SCC[Coal,]

NEIcoal <- NEI[(NEI$SCC %in% CoalSubSCC$SCC), ]

q4d <- aggregate(Emissions ~ year, NEIcoal, sum)

q4col <- brewer.pal(4, "BuGn")

png("plot4.png", width=480, height=480)

ggplot(q4d,aes(factor(year),Emissions/1000,fill=year)) +
        geom_bar(position = 'dodge', stat='identity') +
        geom_text(aes(label=round(Emissions/1000,1)), position=position_dodge(width=0.8), vjust=-0.2) +
        facet_grid(.~year,scales = "free",space="free") + 
        labs(x="year", y=expression("Total PM'[2.5]*' Emission (Tons)")) + 
        labs(title=expression('Coal Combustion-related sources Total PM'[2.5]*' Emissions (Kilotons) by Year'))

dev.off()




