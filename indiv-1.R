library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(dplyr)
library(devtools)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)
data <- read.csv("data/athlete_events_2000.csv")

app$layout(
    dbcContainer(
        list(
            dccGraph(id='plot-area'),
            dccDropdown(
                id='col-select',
                options = list(
                    list(label = 'Male', value = 'Male'),
                    list(label = 'Female', value = 'Female')
                    ),
                value = 'Male'
            ), 
            dccDropdown(
                id='col-select-2',
                options = list(
                    list(label = '2008', value = 2008),
                    list(label = '2016', value = 2016)
                ),
                value = 2008
            )
            
        )
        
        
    )
    
    
)
app$callback(
    output('plot-area', 'figure'),
    list(input('col-select', 'value'), input('col-select-2', 'value')),
    function(xcol, xcol2) {
        data_2 <- data %>% filter(Sex == xcol & Year == xcol2)
        p <- ggplot(data_2) +
            aes(x = Age) +
            geom_histogram(fill = 'red') +
            ggthemes::scale_color_tableau() +
            labs(x = "Age", y = "Number of medals",
                 title = "Number of medals won in 2008 and 2016 across age")
        ggplotly(p)
    }
)

app$run_server(debug = T, host = '0.0.0.0')

