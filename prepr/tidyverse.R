library(gganimate)
source('02_functions.R')

set.seed(42)
wide <- tibble(
    id = rep(1:2),
    x = letters[1:2],
    y = letters[3:4],
    z = letters[5:6]
)

long <- tidyr::gather(wide, key, val, x:z)

proc_data <- function(x, .id = "x", color_fun = colorize_keys, color_when = c("after", "before"), ...) {
    color_when <- match.arg(color_when)
    n_colors <- max(x$id)
    
    if (color_when == "before") x <- color_fun(x, n_colors, ...)
    
    x <- x %>%
        mutate(.y = -row_number()) %>%
        tidyr::gather("label", "value", setdiff(colnames(x), c(".y", "color"))) %>%
        mutate(value = as.character(value)) %>%
        group_by(.y) %>%
        mutate(
            .x = 1:n(),
            .id = .id,
            .width = 1
        ) %>%
        ungroup(.y)
    
    if (color_when == "after") x <- color_fun(x, n_colors, ...)
    x
}


colorize_wide_tidyr <- function(df, n_colors, key_col = "id") {
    n_colors <- n_colors + length(setdiff(unique(df$label), key_col))
    colors <- scales::brewer_pal(type = "qual", "Set1")(n_colors)
    
    df$value_int <- as.integer(gsub("[a-zA-Z]", "0", df$value))
    max_id_color <- max(df$value_int)
    
    df %>%
        bind_rows(
            filter(df, .y == "-1") %>% mutate(.y = 0)
        ) %>%
        mutate(
            idcp = max_id_color - 1L,
            idc = case_when(
                label == "id" ~ value_int,
                TRUE ~ map_int(label, ~which(. == unique(label))) + idcp
            )
        ) %>%
        select(-idcp, -value_int) %>%
        mutate(
            idc   = ifelse(.y == 0 & label == "id", 100, idc),
            value = ifelse(.y == 0, label, value),
            .id   = ifelse(.y == 0, "n", .id),
            color = colors[idc],
        ) %>%
        filter(!is.na(color)) %>%
        mutate(alpha = ifelse(label != "id" & .y < 0, 0.6, 1.0)) %>%
        select(-idc)
}


pv_wide <-
    wide %>%
    proc_data("0-wide", colorize_wide_tidyr) %>%
    mutate(frame = 1, .id = "0-wide")

pv_long <-
    wide %>%
    tidyr::pivot_longer(x:z, names_to = "key", values_to = "val") %>%
    proc_data("3-tall", color_fun = function(x, y) x) %>%
    split(.$label)

pv_long$id <-
    pv_wide %>%
    filter(label == "id") %>%
    select(value, color) %>%
    left_join(pv_long$id, ., by = "value") %>%
    mutate(alpha = 1)

pv_long$key <-
    pv_wide %>%
    filter(label != "id") %>%
    select(label, color) %>%
    left_join(pv_long$key, ., by = c("value" = "label")) %>%
    distinct() %>%
    mutate(alpha = 1)

pv_long$val <-
    pv_wide %>%
    filter(label != "id", .y < 0) %>%
    select(value, color) %>%
    left_join(pv_long$val, ., by = "value") %>%
    mutate(alpha = 0.6)

pv_long <- bind_rows(pv_long) %>% mutate(frame = 2)

pv_wide <- pv_wide %>%
    # add (hidden) copies of cells that are duplicated in the long form
    copy_rows(value %in% 1:2, n = 2) %>%
    copy_rows(value %in% c("x", "y", "z"))

pv_long_labels <-
    tibble(id = 1, a = "id", x = "key", y = "val") %>%
    proc_data("4-label") %>%
    filter(label != "id") %>%
    mutate(color = "#FFFFFF", .y = 0, .x = .x -1, frame = 2, alpha = 0, label = recode(label, "a" = "id"))

pv_wide_labels <-
    tibble(id = 1, a = "id") %>%
    proc_data("2-label") %>%
    filter(label != "id") %>%
    mutate(color = "#FFFFFF", .y = 0, .x = .x -1, frame = 1, alpha = 0, label = recode(label, "a" = "id"))

# An intermediate step with key and value in the right margin
pv_wide_intermediate <-
    bind_rows(pv_wide, pv_long_labels) %>%
    mutate(
        frame = 1.5,
        .id = sub("^\\d", "1", .id),
        .x = ifelse(value %in% c("key", "val"), 5, .x),
        .y = ifelse(value == "val", -1.5, .y)
    )

# Fly "key" and "value" up into title to reset
pv_wide_extra_labels <-
    pv_long_labels %>%
    filter(value %in% c("key", "val")) %>%
    mutate(alpha = 0, frame = 1, .id = "0-label") %>%
    mutate(
        .x = 3.66,
        .y = ifelse(value == "key", 2, 1)
    )

pv_long_extra_keys <-
    map_dfr(
        seq_len(nrow(wide) - 1),
        ~ filter(pv_wide, .y > -1) # Extra key blocks in long column
    )

n_key_cols <- length(setdiff(colnames(wide), "id"))

pv_long_extra_id <-
    map_dfr(
        seq_len(n_key_cols - 1),
        ~ filter(pv_wide, .x == 1) # Extra id column blocks for long column
    )

pivot_longer(
    wide, cols=x:z, names_to='key', values_to='val'
)

titles <- list(
    wider = 'pivot_wider(long,\n   names_from = key,\n  values_from = val)',
    longer_int = '\n     cols = x:z,\n   names_to = "key",\n  values_to = "val" ',
    longer = 'pivot_longer(wide, cols=x:z, names_to="key", values_to="val")'
)

pv_data <-
    bind_rows(
        pv_wide,
        # pv_wide_labels,
        # pv_wide_extra_labels,
        # pv_wide_intermediate,
        pv_long,
        pv_long_labels,
        # pv_long_extra_keys,
        pv_long_extra_id,
    ) %>%
    mutate(
        label = ifelse(value %in% setdiff(colnames(wide), "id"), "key", label),
        label = ifelse(value %in% c("key", "val"), "zzz", label),
        .text_color = ifelse(grepl("label", .id), "black", "white"),
        .text_size = ifelse(grepl("label", .id), 8, 12),
        .text_color = case_when(
            frame != 1 | grepl("label", .id) ~ .text_color,
            .y == 0 ~ color,
            TRUE ~ .text_color
        ),
        # hide "key" and "val" text in first frame
        .text_alpha = ifelse(value %in% c("key", "val") & frame == 1, 0, 1),
        # hide background of x,y,z column names in first frame
        alpha = ifelse(value %in% c("x", "y", "z") & frame == 1, 0, alpha)
    ) %>%
    mutate(frame = factor(frame, levels = c(1, 1.5, 2))) %>%
    select(.x, .y, everything())

animated_titles <- as.character(cut(
    1:120,
    breaks = 6,
    labels = c("wide", titles$longer, titles$longer, titles$longer, "long", titles$wider)
))

views <-
    pv_data %>%
    group_by(frame) %>%
    summarize(across(c(.x, .y), list(min = min, max = max))) %>%
    mutate(
        across(ends_with("min"), ~ .x - 0.5),
        across(ends_with("max"), ~ .x + 0.5)
    )

pv_data <- pv_data %>% mutate(frame = ifelse(frame==1, 2, 1))

pv_anim_plot <-
    plot_data(pv_data) +
    aes(group = value) +
    theme(
        plot.title = element_text(family = "Fira Mono", size = 16, lineheight = 1.3, margin = margin(b = 50)),
        plot.title.position = 'plot',
        plot.margin = margin(t = 75, unit = "pt")
    )


pv_anim <-
    animate_plot(pv_anim_plot, transition_length = 1) +
    # zoom with smooth transitions: fixed y but make space in the x axis
    view_zoom_manual(
        xmin = views$.x_min,
        xmax = views$.x_max,
        ymin = rep(min(views$.y_min), times = nrow(views)),
        ymax = rep(min(views$.y_max), times = nrow(views)),
        ease = "quintic-out"
    ) +
    # labs(title = '{case_when(frame < 24 ~ "wide", frame < 41 ~ titles$longer, frame < 61 ~ titles$longer_int, 
         # frame < 81 ~ titles$longer, frame < 101 ~ "long", TRUE ~ titles$wider)}') +
    # labs(title = '{animated_titles[frame]}') +
    ease_aes("sine-in-out", x = "exponential-in-out", y = "exponential-in-out", alpha = "circular-in-out")

pv_anim_wide2long <- animate(pv_anim, width = 600, height = 700, nframes = 60, end_pause = 0)
anim_save('/home/dalab1/project/web-dev/blog/my_staff/my_course/ggplot2/content/basics/figs/pivot_longer.gif', pv_anim_wide2long)

pv_anim_long2wide <- animate(pv_anim, data=pv_data%>%filter(! .id %in% c('0-wide', '1-wide')), width=600, height=700, nframes=60)
