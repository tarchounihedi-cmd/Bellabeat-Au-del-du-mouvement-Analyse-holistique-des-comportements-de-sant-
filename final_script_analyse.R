# ==============================================================================
# ANALYSE BELLABEAT - Étude de cas Google Data Analytics
# Auteur : [Votre Nom]
# Description : Analyse multi-niveaux (données quotidiennes et agrégées)
# ==============================================================================

library(tidyverse)

# ------------------------------------------------------------------------------
# PHASE 1 : Analyse des données quotidiennes (bellabeat.activity_sleep.csv)
# ------------------------------------------------------------------------------
data_daily <- read_csv("bellabeat.activity_sleep.csv")

data_daily <- data_daily %>%
  mutate(
    sleep_hours = TotalMinutesAsleep / 60,
    light_minutes = LightlyActiveMinutes,
    very_minutes = VeryActiveMinutes
  )

# Modèle 1 : Activité légère vs Sommeil quotidien
model_light <- lm(sleep_hours ~ light_minutes, data = data_daily)
summary(model_light) # p-value = 0.505

# ------------------------------------------------------------------------------
# PHASE 2 : Analyse des moyennes agrégées (bq_activity_sleep_calories.csv)
# ------------------------------------------------------------------------------
data_avg <- read_csv("bq_activity_sleep_calories.csv")

# Modèle 2 : Impact de l'intensité sur les calories (moyennes par utilisateur)
model_calories <- lm(avg_calories ~ avg_light_activity_minutes + avg_very_active_minutes, data = data_avg)
summary(model_calories) # Résultat significatif pour very_active (p < 0.01)

# Modèle 3 : Modèle final holistique (Sommeil expliqué par Activité + Calories)
model_final <- lm(
  avg_sleep_minutes ~ avg_light_activity_minutes + avg_very_active_minutes + avg_calories,
  data = data_avg
)
summary(model_final) # Résultat global non significatif (p = 0.80)

# ------------------------------------------------------------------------------
# VISUALISATION FINALE
# ------------------------------------------------------------------------------
ggplot(data_avg, aes(x = avg_calories, y = avg_sleep_minutes / 60)) +
  geom_point(alpha = 0.7, color = "darkorchid", size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
  labs(
    title = "Relation entre Dépense Énergétique et Sommeil",
    subtitle = "L'augmentation des calories brûlées n'induit pas une hausse du temps de sommeil",
    x = "Calories moyennes (kcal)",
    y = "Heures de sommeil moyennes",
    caption = "Analyse Bellabeat - Données agrégées"
  ) +
  theme_minimal()