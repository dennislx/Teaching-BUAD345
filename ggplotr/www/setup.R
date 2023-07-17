if(!require('pacman')){
    install.packages('pacman')
}
pacman::p_load(
    tidyverse, formatR, countdown, fontawesome,
    glue, patchwork, ggrepel, esquisse, scales
)
pacman::p_load_gh('rstudio/learnr')

knitr::opts_chunk$set(
    echo = TRUE, out.width = "100%", fig.width = 6, fig.height=3, message = FALSE, 
    warning = FALSE, comment = "", cache = FALSE, error = FALSE
)

custom_checker <- function(check_code, evaluate_result, last_value, ...){
    check_result <- eval(parse(text=check_code))
    if(all.equal(last_value, check_result)){
        list(message = learnr::random_praise(), correct = TRUE, location = "append")
    } else {
        list(message = learnr::random_encouragement(), correct = FALSE, location = "append")
    }
}

learnr::tutorial_options(
    exercise.cap = basename(getwd()),
    exercise.checker = custom_checker,
    exercise.blanks = "___+"
)

question <- function(title, ...) {
    learnr::question(
        title, ..., random_answer_order=T, allow_retry=T
    )
}


print_data <- function(data) {
    data %>%
        as.data.frame() %>%
        print(row.names = FALSE)
}

tbl_memdb <- function(df, name = NULL, overwrite = TRUE) {
    name <- ifelse(is.null(name), deparse(substitute(df)), name)
    dplyr::copy_to(
        dbplyr::src_memdb(), df,
        name = name, overwrite = overwrite
    )
}

copy_to <- function(
        dest, df, name = deparse(substitute(df)), overwrite = TRUE) {
    dplyr::copy_to(dest, df, name, overwrite, temporary = FALSE)
}

connect_to <- function(path=':memory:'){
    con <- DBI::dbConnect(RSQLite::SQLite(), path)
    listTbl <- DBI::dbListTables(con)
    matches <- grepl("sqlite_.*", listTbl)
    cat(glue("Available Data: {paste(listTbl[!matches], collapse=' | ')}"))
    return(con)
}

add_www <- function(file='.', cwd=getwd()) {
    here(cwd, 'www', file)
}

add_img <- function(x, ...){
    if (length(list(...)) == 0){
        knitr::include_graphics(add_www(x))
    } else{
        knitr::include_graphics(sapply(c(x, ...), FUN=add_www))
    }
}
