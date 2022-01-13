# SFBayMPRiskCharacterization
Author: Scott Coffin, Ph.D.
Division of Drinking Water
State Water Resources Control Board
scott.coffin@waterboards.ca.gov

This project is to support the listing process for microplastics in the San Francisco Bay. Included are scripts that align blank-corrected microplastics occurence data collected by San Francisco Estuary Institute and reported in [Zhu et. al (2021)](https://pubs.acs.org/doi/10.1021/acsestwater.0c00292) according to the methods described in [Koelmans et al (2020)](https://pubs.acs.org/doi/10.1021/acs.est.0c02982). Default assumptions for probability distributions of microplastics particles in marine surface waters from [Kooi et al (2021)](https://linkinghub.elsevier.com/retrieve/pii/S0043135421006278) are applied to align the data to a common size distribution of 1-5,000 um particles. Aligned concentration data are compared to risk thresholds derived by Mehinto et. al (in review) and derived by Dr. Scott Coffin in [another github repo](https://github.com/ScottCoffin/aq_mp_tox_modelling/blob/master/Concentration%20data/SSD_Working_Framework_Count_aligned.Rmd).

Eco-toxicological risk thresholds may also be derived rapidly and manually without code using the [interactive RShiny application ToMEx](https://sccwrp.shinyapps.io/aq_mp_tox_shiny_demo/).
