This template demonstrates many of the bells and whistles of the `reprex::reprex_document()` output format. The YAML sets many options to non-default values, such as using `#;-)` as the comment in front of output.

## Code style

Since `style` is `TRUE`, this difficult-to-read code (look at the `.Rmd` source file) will be restyled according to the Tidyverse style guide when it’s rendered. Whitespace rationing is not in effect!

``` r
x <- 1
y <- 2
z <- x + y
z
#;-) [1] 3
```

## Quiet tidyverse

The tidyverse meta-package is quite chatty at startup, which can be very useful in exploratory, interactive work. It is often less useful in a reprex, so by default, we suppress this.

However, when `tidyverse_quiet` is `FALSE`, the rendered result will include a tidyverse startup message about package versions and function masking.

``` r
library(tidyverse)
```

## Chunks in languages other than R

Remember: knitr supports many other languages than R, so you can reprex bits of code in Python, Ruby, Julia, C++, SQL, and more. Note that, in many cases, this still requires that you have the relevant external interpreter installed.

Let’s try Python!

``` python
x = 'hello, python world!'
print(x.split(' '))
#;-) ['hello,', 'python', 'world!']
```

And bash!

``` bash
echo "Hello Bash!";
pwd;
ls | head;
#;-) Hello Bash!
#;-) /Users/enricopirani/Statistica
#;-) README.md
#;-) Starg.ipynb
#;-) Statistica_Python.ipynb
#;-) Statistica_Python.py
#;-) Tufte_sample-exported.html
#;-) Tufte_sample-exported_files
#;-) Tufte_sample-woven-exported.docx
#;-) Tufte_sample-woven-exported.tex
#;-) Tufte_sample-woven.md
#;-) Tufte_sample.Rmd
```

Write a function in C++, use Rcpp to wrap it and …

``` cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector timesTwo(NumericVector x) {
  return x * 2;
}
```

then immediately call your C++ function from R!

``` r
timesTwo(1:4)
#;-) [1] 2 4 6 8
```

## Standard output and error

Some output that you see in an interactive session is not actually captured by rmarkdown, when that same code is executed in the context of an `.Rmd` document. When `std_out_err` is `TRUE`, `reprex::reprex_render()` uses a feature of `callr:r()` to capture such output and then injects it into the rendered result.

Look for this output in a special section of the rendered document (and notice that it does not appear right here).

``` r
system2("echo", args = "Output that would normally be lost")
```

## Session info

Because `session_info` is `TRUE`, the rendered result includes session info, even though no such code is included here in the source document.

<details style="margin-bottom:10px;">
<summary>
Standard output and standard error
</summary>
`/Users/enricopirani/Statistica/tutorial_Rmd_std_out_err.txt`
</details>
<details style="margin-bottom:10px;">
<summary>
Session info
</summary>

``` r
sessioninfo::session_info()
#;-) - Session info ----------------------------------------------------------------------------------------
#;-)  setting  value
#;-)  version  R version 4.3.2 (2023-10-31)
#;-)  os       macOS Ventura 13.6.1
#;-)  system   x86_64, darwin22.6.0
#;-)  ui       unknown
#;-)  language (EN)
#;-)  collate  C
#;-)  ctype    C
#;-)  tz       Europe/Rome
#;-)  date     2024-01-21
#;-)  pandoc   3.1.11.1 @ /usr/local/bin/ (via rmarkdown)
#;-) 
#;-) - Packages --------------------------------------------------------------------------------------------
#;-)  package     * version date (UTC) lib source
#;-)  bslib         0.6.0   2023-11-21 [1] CRAN (R 4.3.2)
#;-)  cachem        1.0.8   2023-05-01 [1] CRAN (R 4.3.2)
#;-)  cli           3.6.2   2023-12-11 [1] CRAN (R 4.3.2)
#;-)  codetools     0.2-19  2023-02-01 [2] CRAN (R 4.3.2)
#;-)  colorspace    2.1-0   2023-01-23 [1] CRAN (R 4.3.2)
#;-)  digest        0.6.33  2023-07-07 [1] CRAN (R 4.3.2)
#;-)  dplyr       * 1.1.4   2023-11-17 [1] CRAN (R 4.3.2)
#;-)  evaluate      0.23    2023-11-01 [1] CRAN (R 4.3.2)
#;-)  fansi         1.0.6   2023-12-08 [1] CRAN (R 4.3.2)
#;-)  farver        2.1.1   2022-07-06 [1] CRAN (R 4.3.2)
#;-)  fastmap       1.1.1   2023-02-24 [1] CRAN (R 4.3.2)
#;-)  forcats     * 1.0.0   2023-01-29 [1] CRAN (R 4.3.2)
#;-)  fs            1.6.3   2023-07-20 [1] CRAN (R 4.3.2)
#;-)  generics      0.1.3   2022-07-05 [1] CRAN (R 4.3.2)
#;-)  ggplot2     * 3.4.4   2023-10-12 [1] CRAN (R 4.3.2)
#;-)  glue          1.6.2   2022-02-24 [1] CRAN (R 4.3.2)
#;-)  gtable        0.3.4   2023-08-21 [1] CRAN (R 4.3.2)
#;-)  highr         0.10    2022-12-22 [1] CRAN (R 4.3.2)
#;-)  hms           1.1.3   2023-03-21 [1] CRAN (R 4.3.2)
#;-)  htmltools     0.5.7   2023-11-03 [1] CRAN (R 4.3.2)
#;-)  jquerylib     0.1.4   2021-04-26 [1] CRAN (R 4.3.2)
#;-)  jsonlite      1.8.8   2023-12-04 [1] CRAN (R 4.3.2)
#;-)  knitr       * 1.45    2023-10-30 [1] CRAN (R 4.3.2)
#;-)  labeling      0.4.3   2023-08-29 [1] CRAN (R 4.3.2)
#;-)  lattice       0.21-9  2023-10-01 [2] CRAN (R 4.3.2)
#;-)  lifecycle     1.0.4   2023-11-07 [1] CRAN (R 4.3.2)
#;-)  lubridate   * 1.9.3   2023-09-27 [1] CRAN (R 4.3.2)
#;-)  magrittr      2.0.3   2022-03-30 [1] CRAN (R 4.3.2)
#;-)  Matrix        1.6-1.1 2023-09-18 [2] CRAN (R 4.3.2)
#;-)  mgcv          1.9-0   2023-07-11 [2] CRAN (R 4.3.2)
#;-)  munsell       0.5.0   2018-06-12 [1] CRAN (R 4.3.2)
#;-)  nlme          3.1-163 2023-08-09 [2] CRAN (R 4.3.2)
#;-)  pillar        1.9.0   2023-03-22 [1] CRAN (R 4.3.2)
#;-)  pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.3.2)
#;-)  purrr       * 1.0.2   2023-08-10 [1] CRAN (R 4.3.2)
#;-)  R.cache       0.16.0  2022-07-21 [1] CRAN (R 4.3.2)
#;-)  R.methodsS3   1.8.2   2022-06-13 [1] CRAN (R 4.3.2)
#;-)  R.oo          1.25.0  2022-06-12 [1] CRAN (R 4.3.2)
#;-)  R.utils       2.12.3  2023-11-18 [1] CRAN (R 4.3.2)
#;-)  R6            2.5.1   2021-08-19 [1] CRAN (R 4.3.2)
#;-)  Rcpp          1.0.11  2023-07-06 [1] CRAN (R 4.3.2)
#;-)  readr       * 2.1.4   2023-02-10 [1] CRAN (R 4.3.2)
#;-)  reprex        2.0.2   2022-08-17 [1] CRAN (R 4.3.2)
#;-)  rlang         1.1.2   2023-11-04 [1] CRAN (R 4.3.2)
#;-)  rmarkdown     2.25    2023-09-18 [1] CRAN (R 4.3.2)
#;-)  sass          0.4.7   2023-07-15 [1] CRAN (R 4.3.2)
#;-)  scales        1.2.1   2022-08-20 [1] CRAN (R 4.3.2)
#;-)  sessioninfo   1.2.2   2021-12-06 [1] CRAN (R 4.3.2)
#;-)  stringi       1.8.2   2023-11-23 [1] CRAN (R 4.3.2)
#;-)  stringr     * 1.5.1   2023-11-14 [1] CRAN (R 4.3.2)
#;-)  styler        1.10.2  2023-08-29 [1] CRAN (R 4.3.2)
#;-)  tibble      * 3.2.1   2023-03-20 [1] CRAN (R 4.3.2)
#;-)  tidyr       * 1.3.0   2023-01-24 [1] CRAN (R 4.3.2)
#;-)  tidyselect    1.2.0   2022-10-10 [1] CRAN (R 4.3.2)
#;-)  tidyverse   * 2.0.0   2023-02-22 [1] CRAN (R 4.3.2)
#;-)  timechange    0.2.0   2023-01-11 [1] CRAN (R 4.3.2)
#;-)  tinytex       0.49    2023-11-22 [1] CRAN (R 4.3.2)
#;-)  tufte       * 0.13    2023-06-22 [1] CRAN (R 4.3.2)
#;-)  tzdb          0.4.0   2023-05-12 [1] CRAN (R 4.3.2)
#;-)  utf8          1.2.4   2023-10-22 [1] CRAN (R 4.3.2)
#;-)  vctrs         0.6.5   2023-12-01 [1] CRAN (R 4.3.2)
#;-)  withr         2.5.2   2023-10-30 [1] CRAN (R 4.3.2)
#;-)  xfun          0.41    2023-11-01 [1] CRAN (R 4.3.2)
#;-)  yaml          2.3.7   2023-01-23 [1] CRAN (R 4.3.2)
#;-) 
#;-)  [1] /usr/local/lib/R/4.3/site-library
#;-)  [2] /usr/local/Cellar/r/4.3.2/lib/R/library
#;-) 
#;-) -------------------------------------------------------------------------------------------------------
```

</details>
