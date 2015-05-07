library(shiny)
library(wordcloud)
library(RColorBrewer)

pal2 <- brewer.pal(8,'Dark2')

shinyServer(function(input, output) {
	
	output$wordcloud <- renderPlot({

        with(top_hashtags[ top_hashtags$country == input$country_code,] , wordcloud(hashtag, freq, scale=c(8,1), min.freq=1, max.words= input$num_of_words, random.order=FALSE, rot.per=.15, colors = pal2))

        })

		
}) # close shinyServer
				