library("dplyr")

# Load and unzip the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "household_power_consumption.zip")
unzip("household_power_consumption.zip")

# Read, filter en mutate the data
# Calculate the max sub metering to create canvas of right size in plot 3 and 4
hpc <- read.csv("household_power_consumption.txt", sep = ";", na.strings = "?") %>%
       filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
       mutate(datetime=as.POSIXct(strptime(paste(Date,Time), "%d/%m/%Y %H:%M:%S")), Max_Sub_metering=pmax(Sub_metering_1, Sub_metering_2, Sub_metering_3))

# Set locale so labels are in english
Sys.setlocale(category = "LC_ALL", locale = "english")

# Plot to png
png(filename="plot4.png", width = 480, height = 480, units = "px")
par(mfcol=c(2,2))

# plot 1
with(hpc, plot(datetime, Global_active_power, type="n", xlab="", ylab="Global Active Power"))
with(hpc, lines(datetime, Global_active_power))

# plot 2
with(hpc, plot(datetime, Max_Sub_metering, type="n", xlab="", ylab="Energy sub metering"))
with(hpc, lines(datetime, Sub_metering_1, col="black"))
with(hpc, lines(datetime, Sub_metering_2, col="red"))
with(hpc, lines(datetime, Sub_metering_3, col="blue"))
legend("topright", lty=1, bty = "n", col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# plot 3
with(hpc, plot(datetime, Voltage, type="n"))
with(hpc, lines(datetime, Voltage))

# plot 4
with(hpc, plot(datetime, Global_reactive_power, type="n"))
with(hpc, lines(datetime, Global_reactive_power))
dev.off()
