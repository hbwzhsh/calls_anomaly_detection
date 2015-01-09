# devtools::install_github("twitter/AnomalyDetection")
library(AnomalyDetection)

# data obtaining

calls <- read.csv('calls.csv', header=FALSE, na.strings = "")
colnames(calls) <- c('recvip', 'duration', 'start', 'status', 'peerip', 'direction', 'host', 'line', 'calee', 'caller', 'uniqueid', 'billsec')
calls_complete <- calls[complete.cases(calls), ]

# select pbx062 data

pbx062 <- calls_complete[calls_complete$host == 'pbx000062.ocean-pbx.com', c("start", "direction") ]
table(pbx062$direction)

# filter to incoming
pbx062 <- pbx062[pbx062$direction == 'incoming', ]

# handling datetime
pbx062$start <- as.character(pbx062$start)
pbx062$start <- as.POSIXlt(strptime(pbx062$start, "%Y-%m-%dT%H:%M:%S.000Z"))


minutes_agg <- aggregate(pbx062$direction, by=list(substr(as.character(pbx062$start), 0, 16)), FUN=length)
colnames(minutes_agg) <- c('timestamp', 'in_calls')
minutes_agg$timestamp <- as.POSIXlt(strptime(minutes_agg$timestamp, "%Y-%m-%d %H:%M"))

# filter data: select all from 1/10
minutes_agg <- minutes_agg[minutes_agg$timestamp >= '2014-10-01 00:00:00', ]

res1 = AnomalyDetectionTs(minutes_agg, max_anoms=0.1, direction='both', plot=TRUE)
res1$plot
res2 = AnomalyDetectionVec(minutes_agg[,2], max_anoms=0.02, period=1440, direction='both', only_last=FALSE, plot=TRUE)
res2$plot
res3 = AnomalyDetectionTs(minutes_agg, max_anoms=0.2, direction='both', only_last='hr', plot=TRUE)
