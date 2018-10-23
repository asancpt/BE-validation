# setup ----

library(tidyverse)

# plots ----

read_csv('data/Conc.csv') %>% 
  ggplot(aes(TIME, CONC, color = TRT)) +
  geom_point() +
  geom_line() +
  facet_wrap(. ~ SUBJ) +
  theme_bw() +
  labs(color = 'Treatment', x = 'Time (h)', y = 'Concentration (ng/mL)')

library(ggsci)
read_csv('data/Conc.csv') %>% 
  mutate(label = paste(SUBJ, GRP, sep = ',') %>% as_factor()) %>% 
  filter(!SUBJ %in% c(3, 12, 26)) %>% 
  ggplot(aes(TIME, CONC, color = TRT)) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  facet_wrap(. ~ label, ncol = 7) +
  ggsci::scale_colour_aaas() +
  theme_bw() +
  theme(legend.position="top") +
  labs(color = 'Treatment', x = 'Time (h)', y = 'Concentration (ng/mL)')
ggsave('assets/conc-time.pdf', width = 10, height = 6)

# results_nca ----

read_csv() %>% 
  select(SUBJ, GRP, PRD, TRT, AUCLST, CMAX)

results_nca <- read_csv('data/Conc.csv') %>% 
  as.data.frame() %>% 
  NonCompart::tblNCA(c('SUBJ', 'GRP', 'PRD', 'TRT'), 'TIME', 'CONC')

write_csv(results_nca, 'data/results_nca.csv')

# raw ----

raw_NCAResult4BE <- results_nca %>% 
  select(SUBJ, GRP, PRD, TRT, AUCLST, CMAX, TMAX) %>% 
  mutate_at(vars(GRP, TRT), funs(as_factor)) %>% 
  filter(!SUBJ %in% c(3, 12, 26)) %>% 
  rename(AUClast = AUCLST, Cmax = CMAX, Tmax = TMAX)

write_csv(raw_NCAResult4BE, 'data/raw_NCAResult4BE.csv')

# comparison ----

head(BE::NCAResult4BE)
head(raw_NCAResult4BE)

BE::NCAResult4BE %>% summarise_all(funs(mean, sd))
raw_NCAResult4BE %>% summarise_all(funs(mean, sd))
