library(shiny)

shinyUI(pageWithSidebar(

	headerPanel('Template'),
	
	sidebarPanel(
		selectInput(inputId = 'country_name', label = 'Select Country', choices = as.character(lookup_names$country_name), selected = 'AE'),

		sliderInput(inputId = 'num_of_words', label = 'Number of words plotted', min = 20, max = 120, value = 30)
		
	),  ## close sidebarPanel
	
	mainPanel(
		plotOutput( outputId = 'wordcloud')
		)	## close mainPanel
	)	## close pageWithSidebar
)	## close shinyUI