## ----echo=TRUE----------------------------------------------------------------
options("teal.basic_table_args" = teal.widgets::basic_table_args(title = "ENV_TITLE"))
library(shiny)
library(teal.widgets)
library(magrittr)

basic_table_args <- list(
  default = basic_table_args(prov_footer = "USER_FOOTER"),
  table1 = basic_table_args(subtitles = "USER_SUBTITLES_TABLE1"),
  table2 = basic_table_args(subtitles = "USER_SUBTITLES_TABLE2")
)

app <- shinyApp(
  ui = fluidPage(
    shinyjs::useShinyjs(),
    div(verbatimTextOutput("table1"))
  ),
  server = function(input, output, session) {
    dev_table_args <- teal.widgets::basic_table_args(show_colcounts = TRUE)

    table_expr <- substitute(
      expr = {
        tt <- f_table_expr %>%
          rtables::split_cols_by("Species") %>%
          rtables::analyze(vars = "Sepal.Length", afun = function(x) {
            rtables::in_rows(
              "Mean" = rtables::rcell(mean(x), format = "xx.xx"),
              "Range" = rtables::rcell(range(x), format = "xx.xx - xx.xx")
            )
          })
        table2 <- rtables::build_table(tt, iris)
        table2
      },
      env = list(f_table_expr = parse_basic_table_args(
        teal.widgets::resolve_basic_table_args(
          user_table = basic_table_args$table2,
          user_default = basic_table_args$default,
          module_table = dev_table_args
        )
      ))
    )
    output$table1 <- renderPrint(eval(table_expr))
  }
)

## ----echo=TRUE, eval = FALSE--------------------------------------------------
#  runApp(app)

