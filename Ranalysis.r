# read file
hash <- read.csv('text-hashtag-id-co.csv', header = FALSE)
names(hash) <- c('long','lat','hashtag')

length(unique(hash$hashtag)) # number of unique hashtags
counts <- with(hash, aggregate(long, list(hashtag), length)) # occurences of hashtags
max(counts$x) 
#hist(counts$x)
counts[ counts$x == max(counts$x),] # hashtag with maximum occurrences
summary(counts$x)  # distribution of frequencies per hashtag
#hist(counts$x, xlim = c(0, 100), breaks = max(counts$x)/10) # prettier pic

nrow(counts)*0.75
nrow(counts[ counts$x >= 2,]) # number of hashtags with more than 2 occurrencies
summary(counts$x[ counts$x >= 2]) # summary of counts when cpunts >= 2

library(sp)
library(rworldmap)
data(countriesCoarseLessIslands) # loading world map
#plot(countriesCoarseLessIslands) # plot map
hash_coords <- SpatialPoints(hash[1:2]) # make SpatialPoint dataframe from regular coordinates

#plot(countriesCoarseLessIslands)
#points(hash_coords)  # map of the world with points on top

proj4string(hash_coords) <- proj4string(countriesCoarseLessIslands) # assign coordinate/projection system to hash_coords (we need it to be the same as the polygons for the spatial join)

spatial_join <- over(hash_coords, countriesCoarseLessIslands) # overlay points and assign to polygon

#plot(countriesCoarseLessIslands)
#points(hash_coords[5,], col = 'red') # plotting first 5 points to check that they have been assigned to the right country

hash$country <- spatial_join$POSTAL # attching country code to long-lat-hashtag

counts_by_country <- aggregate(hash$long, list(hash$country), length) # counts of occurrencies by country

summary(counts_by_country$x)

hash_filtered <- hash[ hash$country %in% counts_by_country$Group.1[ counts_by_country$x >= 1000], ] # filtering on countries with freq >= 1000
hash_filtered$country <- factor(hash_filtered$country)

#lookup <- data.frame(country_code = sort(unique(hash_filtered$country)), country_name = c('Australia','Brazil', 'Canada', 'Spain', 'Uk', 'Italy', 'India','Indonesia', 'Malaysia', 'Philippines', 'Thailand','United States'))

hash_per_country <- aggregate( hash_filtered$long, list(hash_filtered$hashtag, hash_filtered$country), length)
names(hash_per_country) <- c('hashtag','country','freq')

tmp <- split( hash_per_country, hash_per_country$country)
tmp2 <- lapply(tmp, function(x) { out <- x[ order(-x$freq), ]; return(out[1:100,]) })
top_hashtags <- do.call('rbind', tmp2)


pal2 <- brewer.pal(8,'Dark2')
wordcloud(us$hashtag, us$freq, scale=c(8,.2),min.freq=3, max.words=20, random.order=FALSE, rot.per=.15, colors=pal2)


with(top_hashtags[ top_hashtags$country == 'GB',] , wordcloud(hashtag, freq, scale=c(8,.2), min.freq=3, max.words=50, random.order=FALSE, rot.per=.15, colors = pal2))