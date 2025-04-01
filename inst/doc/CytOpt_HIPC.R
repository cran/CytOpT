## ----knitrsetup, include = FALSE, eval=TRUE-----------------------------------
# Set environment variables to limit thread usage while building the vignette
Sys.setenv(
        OMP_NUM_THREADS = "1",
        MKL_NUM_THREADS = "1",
        OPENBLAS_NUM_THREADS = "1",
        VECLIB_MAXIMUM_THREADS = "1"
      )

library(reticulate)
# this vignette requires python 3.7 or newer to run
eval_is <- tryCatch({
  numeric_version(py_config()$version) >= "3.7" && py_numpy_available() && 
    py_module_available("scipy") && py_module_available("sklearn")
}, error = function(e) FALSE)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = eval_is
)

## ----pkg and data loading, eval=TRUE------------------------------------------
library(CytOpT)
data("HIPC_Stanford")

## ----Stanford_1228_1A_head, echo=FALSE----------------------------------------
knitr::kable(head(HIPC_Stanford_1228_1A))

## ----goldstandard-------------------------------------------------------------
gold_standard_manual_prop <- c(table(HIPC_Stanford_1369_1A_labels) /
                                 length(HIPC_Stanford_1369_1A_labels))

## ----optimization-------------------------------------------------------------

set.seed(123)
res <- CytOpT(X_s = HIPC_Stanford_1228_1A, X_t = HIPC_Stanford_1369_1A, 
              Lab_source = HIPC_Stanford_1228_1A_labels,
              theta_true = gold_standard_manual_prop,
              method="minmax", monitoring = TRUE)

## ----results------------------------------------------------------------------
summary(res)

## ----plots, fig.width = 7, fig.asp = .8, fig.retina=2-------------------------
plot(res)

## ----BA, fig.width = 7, fig.asp = .6, fig.retina = 2--------------------------
Bland_Altman(res$proportions)

