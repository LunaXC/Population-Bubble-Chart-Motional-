library(dplyr)

shinyServer(function(input, output, session) {
  p = read.csv("Population.csv")
  p = p[!p$STATE == 0,]
  p = p[,-(1:3)]
  Year = as.numeric(c(rep("2011", 52),rep("2012", 52), rep("2013", 52), rep("2014", 52), rep("2015", 52), rep("2016", 52)))
  state = as.factor(rep(p$STATE, 6))
  state = factor(state)
  stname = rep(p$NAME, 6)
  population = as.numeric(c(p$POPESTIMATE2011, p$POPESTIMATE2012, p$POPESTIMATE2013, p$POPESTIMATE2014, p$POPESTIMATE2015, p$POPESTIMATE2016))
  Rbirth = as.numeric(c(p$RBIRTH2011, p$RBIRTH2012, p$RBIRTH2013, p$RBIRTH2014, p$RBIRTH2015, p$RBIRTH2016))
  Rdeath = as.numeric(c(p$RDEATH2011, p$RDEATH2012, p$RDEATH2013, p$RDEATH2014, p$RDEATH2015, p$RDEATH2016))
  pop = data.frame(state, stname, Year, population, Rbirth, Rdeath)
  
  
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  defaultColors <- c("#dc1111", "#dc2811", "#dc4311", "#dc5b11", 
                     "#dc7611", "#dc9111", "#dcac11", "#dcc711",
                     "#d8dc11", "#c0dc11", "#a9dc11", "#91dc11",
                     "#76dc11", "#5edc11", "#47dc11", "#2fdc11",
                     "#14dc11", "#11dc28", "#11dc40", "#11dc58",
                     "#11dc6f", "#11dc87", "#11dc9f", "#11dcb6",
                     "#11dcce", "#11d1dc", "#11badc", "#11a2dc",
                     "#118adc", "#1173dc", "#115edc", "#114adc",
                     "#1136dc", "#1121dc", "#1411dc", "#2811dc",
                     "#3c11dc", "#5111dc", "#6211dc", "#7311dc",
                     "#8011dc", "#8e11dc", "#9b11dc", "#9b11dc",
                     "#b611dc", "#cb11dc", "#dc11d8", "#dc11c4",
                     "#dc11b3", "#dc119b", "#dc1180", "#dc1165")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(pop$state)
  )
  
  yearData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    df <- pop %>%
      filter(Year == input$year) %>%
      select(stname, Rbirth, Rdeath, state, population) %>%
      arrange(state)
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          "Birth Rate VS Death Rate",
          input$Year),
        series = series
      )
    )
  })
})
