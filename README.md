# SFBayMPRiskCharacterization
Author: Scott Coffin, Ph.D.
Division of Drinking Water
State Water Resources Control Board
scott.coffin@waterboards.ca.gov

This repository contains code and data that produces all analytical output and figures associated with Coffin et al. (2022), "Risk Characterization of Microplastics in San Francisco Bay, California".

Included are scripts that align blank-corrected microplastics occurence data collected by San Francisco Estuary Institute and reported in [Zhu et. al (2021)](https://pubs.acs.org/doi/10.1021/acsestwater.0c00292) according to the methods described in [Koelmans et al (2020)](https://pubs.acs.org/doi/10.1021/acs.est.0c02982). Size probability distributions of microplastics particles in marine surface waters from [Kooi et al (2021)](https://linkinghub.elsevier.com/retrieve/pii/S0043135421006278) are applied to rescale the data to a common size distribution of 1-5,000 um particles.

Aligned concentration data are compared to risk thresholds derived by Mehinto et. al (2022) and derived in [another github repo](https://github.com/ScottCoffin/aq_mp_tox_modelling/blob/master/Concentration%20data/SSD_Working_Framework_Count_aligned.Rmd). Eco-toxicological risk thresholds may also be derived rapidly and manually without code using the [interactive RShiny application ToMEx](https://sccwrp.shinyapps.io/aq_mp_tox_shiny_demo/).

Three principal scripts are used. Fit_MLE_mantaData.R generates maximum likelihood estimates for particle length size distribution values using microplastics data in San Francisco Bay according to the methods described in [Kooi et al. (2021)](https://www.sciencedirect.com/science/article/pii/S0043135421006278). As described in Coffin et al. (2022), the site-specific size distribution values are not used for risk characterization due to their high uncertainty and the fact that those data were not collected with the intention of performing such analyses. However, these data are used as part of a sensitivity analysis using the script risk_characterization_ZhuAlpha.Rmd. The principal risk characterization reported in Coffin et al. (2022) is performed using risk_characterization_KooiAlpha.Rmd, with all output listed in output/data/kooi and output/figures/kooi.
