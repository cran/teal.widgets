## ----echo=TRUE, warning=FALSE, message=FALSE----------------------------------
library(shiny)
library(ggplot2)
library(teal.widgets)

options("teal.ggplot2_args" = teal.widgets::ggplot2_args(labs = list(caption = "Caption from options")))

user_ggplot2_args <- list(
  default = ggplot2_args(
    labs = list(title = "User default title"),
    theme = list(legend.position = "right", legend.direction = "vertical")
  ),
  plot1 = ggplot2_args(
    labs = list(title = "User title"),
    theme = list(legend.position = "right", legend.direction = "vertical")
  )
)

app <- shinyApp(
  ui = fluidPage(
    shinyjs::useShinyjs(),
    div(plotOutput("plot1"))
  ),
  server = function(input, output, session) {
    dev_ggplot2_args <- ggplot2_args(
      labs = list(subtitle = "Dev substitle"),
      theme = list(legend.position = "none")
    )

    f_ggplot2_expr <- parse_ggplot2_args(
      resolve_ggplot2_args(
        user_plot = user_ggplot2_args$plot1,
        user_default = user_ggplot2_args$default,
        module_plot = dev_ggplot2_args
      )
    )

    plot_expr <- substitute(
      expr = {
        gg <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
          geom_point() +
          ggplot_expr_labs +
          ggplot_expr_theme
        print(gg)
      },
      env = list(ggplot_expr_labs = f_ggplot2_expr$labs, ggplot_expr_theme = f_ggplot2_expr$theme)
    )
    print(plot_expr)
    output$plot1 <- renderPlot(eval(plot_expr))
  }
)

## ----echo=TRUE, eval = FALSE--------------------------------------------------
#  shinyApp(app$ui, app$server)

