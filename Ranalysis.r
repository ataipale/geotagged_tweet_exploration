#options
options(scipen=20)

#libraries

# data
tweets <- read.csv('id-text-country.csv', header = FALSE, stringsAsFactors = FALSE)
names(tweets) <- c('id','text','country')

## get counts by country
table(tweets$country)
counts_by_country <- with(tweets, aggregate( id, by = list(country), length))

barplot(table(tweets$country))
hist(counts_by_country[,'x'] , breaks = max(counts_by_country$x)/20, xlim= c(0, 2000))
boxplot(counts_by_country$x)

summary(counts_by_country$x)

# filtering on countries that have more than 1000 tweets
tweets_f <- tweets[ tweets$country %in% counts_by_country$Group.1[ counts_by_country$x >= 1000], ]

## country lookup 
lookup_country <- data.frame( code = unique(tweets_f$country), name = c('United States', 'Great Britain', 'Canada', 'Brazil', 'Turkey', 'India', 'Malaysia', 'Philippines', 'South Africa', 'Ireland'))

index <- regexpr("\#\w+", tweets_f$text, perl = TRUE)
hashtags <- regmatches(tweets_f$text, index)