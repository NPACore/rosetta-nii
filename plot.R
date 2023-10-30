#!/usr/bin/env Rscript

# 20231030WF - init
#   read in hyperfine stats for each language. files generted by Makefile
library(dplyr); library(tidyr); library(ggplot2)
benchmarks <-
   Sys.glob('out/*/*.csv') |>
   lapply(\(f) tryCatch(read.csv(f) %>%
                          mutate(f=gsub('out/|-stats.csv','',f)),
                        error=\(e) NULL)) |>
   bind_rows()

bclean <- benchmarks |>
   separate(f,c('proc','host','app'),sep='[-/]') |>
   mutate(impl=gsub(' .*|scripts/','',command) %>%
               gsub('.*\\.','',.),
          proc=gsub('_+', ' ', proc)) |>
   filter(!grepl('target/',impl))

brank <- bclean |>
   group_by(proc,host,app) |>
   mutate(r=rank(`mean`))

ggplot(brank) +
   aes(x=impl, y=`r`,
       color=stringr::str_wrap(proc,20),
       label=round(`mean`,2)) +
   geom_point() +
   geom_text(size=2, vjust=1, hjust=-.25, color='black',aes(color=NULL)) +
   facet_wrap(~app, scales="free_x") +
   cowplot::theme_cowplot() +
   labs(title='Preformace Rank per Implementations (lower better)',
        x='Implementation', y='Rank', color="Processor")+
   theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust=0),
        legend.position='top')
ggsave('out/rank_plot.png',width=10.6,height=6)
