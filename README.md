
<!-- README.md is generated from README.Rmd. Please edit that file -->

# discursive

<!-- badges: start -->
<!-- badges: end -->

This package implements a simple but powerful framework to measure
political sophistication based on open-ended survey responses.
Discursive sophistication captures the complexity of individual attitude
expression by quantifying its relative size, range, and constraint. For
more information on the measurement approach see: Kraft, Patrick W.
2023. “Women Also Know Stuff: Challenging the Gender Gap in Political
Sophistication.” American Political Science Review (forthcoming).

## Installation

`discursive` is now available on CRAN! You can install the latest
version with:

``` r
install.packages("discursive")
```

Alternatively, you can install the development version of discursive
from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("pwkraft/discursive")
```

## Example

``` r
library(discursive)
cces$discursive <- discursive(data = cces,
                              openends = c(paste0("oe0", 1:9), "oe10"),
                              meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female"),
                              args_prepDocuments = list(lower.thresh = 10, verbose = FALSE),
                              args_stm = list(K = 25, seed = 12345, verbose = FALSE),
                              dictionary = dict_sample, progress = FALSE)$output$discursive
#> Building corpus... 
#> Converting to Lower Case... 
#> Removing punctuation... 
#> Removing stopwords... 
#> Removing numbers... 
#> Stemming... 
#> Creating Output...
head(cces)
#>   age female educ_cont pid_cont educ_pid
#> 1  58      1         2        1        2
#> 2  70      1         4        1        4
#> 3  23      1         4        6       24
#> 4  29      1         6        2       12
#> 5  28      1         4        2        8
#> 6  57      1         2        2        4
#>                                                                                                                                                                                                                                   oe01
#> 1                                                                                                                                                                                          Check for past arrests or mental conditions
#> 2 Necessary to provide adequate information for anyone who wishes to purchase a weapon. This will prevent anyone not of sound mind to have a weapon. Also, anyone who has committed a serious crime should need further investigation.
#> 3                                                                                                                                                                                      so guns do not get into the wrong peoples hands
#> 4                                                                                                                                                                                                         Less illegal guns on streets
#> 5                                                                                                                                                                            We want to protect the greater society by double checking
#> 6                                                                                                                                                to make sure the person doesn't have a criminal history or they are mentally unstable
#>                                                                                                oe02
#> 1                                                                            More and quicker sales
#> 2    These thinkers fear that anything at all will weaken the second amendment to the Constitution.
#> 3                                                                                to use for hunting
#> 4                                                Unfair everyone should have the right to beat arms
#> 5 That background checks shouldn’t matter because they are just wanting a gun for hunting purposes.
#> 6                      it is against everyone's right to bear arms and it is an invasion of privacy
#>                                                                                                                         oe03
#> 1                                                                                                         Abortion is murder
#> 2 Mostly from religious organizations some of whom refer to the bible. They may not understand that it's not about religion.
#> 3                                                                women have the right to make decisions about their own body
#> 4                                                                                     People will be more careful having sex
#> 5                                                                                                    That it is a human life
#> 6                                                                                                 it is murder of the unborn
#>                                                                                                               oe04
#> 1                                                                                                  Right to decide
#> 2 A woman should have the absolute right to decide what happens to her body as do men. Roe v Wade provides choice.
#> 3                                                                            you should not be able to kill a baby
#> 4                                                                                               Demeaning to women
#> 5                                                       It is the women’s right to do what she wants with her body
#> 6                                                      women have the right to decide what to do with their bodies
#>                                                                                                                                                                                 oe05
#> 1                                                                                                                                                     Provide a better life for them
#> 2 This is the only fair and just way to provide legal status to these people who know nothing but the US, have been educated here and work to provide a better life for them and us.
#> 3                                                                                                                                                    America is the home for chances
#> 4                                                                                                                                        People are people let them pursue happiness
#> 5                                                                                                                                               This is their home and all they know
#> 6                                                                                                  American is built on the idea of being a melting pot with open arms to immigrants
#>                                                              oe06
#> 1                                    Overpopulating and less jobs
#> 2                                                                
#> 3                  people need to earn their way into our country
#> 4                                                We can help them
#> 5                                       They are still immigrants
#> 6 they drain the system resources and some of them are terrorists
#>                                                                                      oe07
#> 1                                                                       Is not affordable
#> 2                                               Costs too much and was a Democratic idea.
#> 3                                      everyone had a chance to be covered by health care
#> 4                                                                                        
#> 5                              It is costing us too much money and we have better options
#> 6 it forces people to purchase something against their will that they may or may not want
#>                                                                                    oe08
#> 1                                                    More money for insurance companies
#> 2 All Americans deserve healthcare just like most of the world's progressive countries.
#> 3                              not everyone thinks its a requirement to have healthcare
#> 4                                                     People need affordable healthcare
#> 5                                    Keep protecting the ones we are already protecting
#> 6                                                   it helps more people have insurance
#>                                                 oe09
#> 1                                                   
#> 2           Just another ridiculous Republican idea.
#> 3       We keep a line of trade with other countries
#> 4                                                   
#> 5 Since they are out of the country we should charge
#> 6 we have to pay them tariffs so they can pay us too
#>                                                                           oe10
#> 1                                                                             
#> 2 This just irritates our allies and hurts our workers, companies and farmers.
#> 3                              We close the line of trade with other countries
#> 4                                                          Less big government
#> 5                                                           It is just trading
#> 6                                    it isn't good for international relations
#>    discursive
#> 1  0.07362755
#> 2  1.27235839
#> 3  0.32848993
#> 4 -0.17371927
#> 5  0.79568885
#> 6  0.50372490
```

<!-- What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so: -->
<!-- ```{r cars} -->
<!-- summary(cars) -->
<!-- ``` -->
<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this. You could also use GitHub Actions to re-render `README.Rmd` every time you push. An example workflow can be found here: <https://github.com/r-lib/actions/tree/v1/examples>. -->
<!-- You can also embed plots, for example: -->
<!-- ```{r pressure, echo = FALSE} -->
<!-- plot(pressure) -->
<!-- ``` -->
<!-- In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN. -->
