#' Plot a bar chart
#'
#' @param data The data frame to plot
#' @param x_col The name of the column to use for the x-axis
#' @param y_col The name of the column to use for the y-axis
#' @importFrom ggplot2
#' @importFrom stats sd
#' @return A bar chart
#' @export
plot_bar_chart <- function(data, x_col, y_col) {
  ggplot2::ggplot(data, aes(x = x_col, y = y_col)) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    theme_minimal()
}


