% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mpt_formula.R, R/brms_setup.R
\name{mpt_formula}
\alias{mpt_formula}
\alias{stancode.mpt_formula}
\alias{standata.mpt_formula}
\title{Set up MPT model formula}
\usage{
mpt_formula(
  formula,
  ...,
  response,
  model,
  data_format = "long",
  brms_args = list()
)

\method{stancode}{mpt_formula}(
  object,
  data,
  default_prior_intercept = "normal(0, 1)",
  default_prior_coef = "normal(0, 0.5)",
  default_priors = TRUE,
  tree,
  log_p = FALSE,
  link = "probit",
  ...
)

\method{standata}{mpt_formula}(object, data, tree, ...)
}
\arguments{
\item{formula}{An object of class \code{formula} providing a symbolic description
of the regression model and hierarchical structure applied to MPT model
parameters. If only one formula is given, the left-hand-side (LHS) needs to
give the response variable and the right-hand-side (RHS) gives the model
structure for all parameters.}

\item{...}{for \code{mpt_formula()}, optional additional \code{formula} objects
providing a symbolic description of the regression model and hierarchical
structure applied to the remaining MPT model parameters. For the
\code{mpt_formula} methods, additional arguments passed to the corresponding
default methods.}

\item{response}{one sided formula or character vector giving the name of the
response variable. Cannot be missing if a \code{formula} is specified for each
parameter and the data are given in long format (see \code{data_format} arg)}

\item{model}{An \code{mpt_model} object as created by \code{\link[=make_mpt]{make_mpt()}}.}

\item{data_format}{character string indicating whether the formula is to be
generated for fitting data in long format / non-aggregated data (\code{long},
the default), where a single variable contains trial-level responses, or
for data in wide format / aggregated data (\code{wide}), where a separate column
for each response category contains the respective frequency.}

\item{brms_args}{A \code{list} of additional arguments passed to
\code{\link[brms:brmsformula]{brms::brmsformula()}}, such as \code{center}, which is the function ultimately
creating the formula for fitting the model.}

\item{object}{An object of class \code{mpt_formula}}

\item{data}{\code{data.frame} containing the variables in \code{formula}. Data needs to
be on an observation-level (i.e., each row is one response/observation) and
cannot be aggregated in any way.
TODO: change this}

\item{default_prior_intercept}{character string describing the prior applied
to the fixed-effect intercepts for each MPT model parameter on the
unconstrained scale (if \code{default_priors = TRUE}). The default, \code{"normal(0, 1)"} implies a flat prior on the MPT parameter scale.}

\item{default_prior_coef}{character string describing the prior applied to
the non-intercept fixed-effect parameters for each MPT model parameter on
the unconstrained scale (if \code{default_priors = TRUE}).}

\item{default_priors}{logical value indicating whether (the default, \code{TRUE})
or not (\code{FALSE}) the priors specified via the \code{default_prior_intercept} and
\code{default_prior_coef} argument should be applied.}

\item{tree}{one-sided formula or character specifying the variable in \code{data}
indicating the tree (or item type) of a given observation. The values of
the \code{tree} variable need to match the names of the trees in \code{model}. Can be
omitted for models with only one tree.}

\item{log_p}{logical value indicating whether the likelihood should be
evaluated with probabilities (the default, \code{FALSE}) or log
probabilities (\code{TRUE}). Setting \code{log_p} to \code{TRUE} can help
in case of convergence issues but might be slower.}

\item{link}{character specifying the link function for transforming from
unconstrained space to MPT model parameter (i.e., 0 to 1) space. Default is
\code{"probit"}.}
}
\value{
An object of class \code{mpt_formula} which is a list containing the
following slots:
\enumerate{
\item \code{formulas}: A \code{list} of formulas for each MPT model parameter.
\item \code{response}: A one-sided \code{formula} given the response variable on the RHS.
\item \code{brms_formula}: The \code{brmsformula} object created by \code{\link[brms:brmsformula]{brms::brmsformula()}}.
\item \code{model}: The \code{mpt_model} object passed in the \code{model} argument.
\item \code{data_format}: see the corresponding argument
}

The \link[brms:stancode]{brms::stancode} and \link[brms:standata]{brms::standata} methods for \code{mpt_formula} objects
return the same objects as the corresponding default \code{brms} methods (which
are internally called).
}
\description{
\code{mpt_formula()} sets up model formula(s) that specify the regression
structure and hierarchical structure for MPT model formulas. The regression
structure allows to vary parameters across both between-participants and
within-participants conditions. By using \code{lme4}/\code{brms} style syntax (e.g.
\code{(1|id)}) the random-effects (i.e., a hierarchical structure) can be defined.
For \code{mpt_formula} objects, \link[brms:stancode]{brms::stancode} and \link[brms:standata]{brms::standata} methods are
provided.
}
\details{
There are two ways of using \code{mpt_formula()} function:
\enumerate{
\item Specify a single formula that applies to all MPT model parameters (passed
via \code{model}). In this case, the LHS of the formula needs to give the
response variable if data is in long format (LHS is ignored if an LHS
is given for a formula for data in wide format / aggregated data).
\item Specify a formula for each MPT model parameter of the \code{model}.
In this case, the LHS of each formula needs to give the parameters name.
Furthermore, the name of the response variable needs to be passed via the
\code{response} argument for data in long format.
}
}
\examples{

## Model with 4 parameters: Dn, Do, g1x, g2x
EQNFILE <- system.file("extdata", "u2htm.eqn", package = "mptstan")
u2htsm_model <- make_mpt(EQNFILE)
u2htsm_model

## formulas are given for following data
str(skk13)

#### simplest possible formula: ~ 1
## no random-effects and there is only one set of parameters (i.e., no
## differences across conditions).
## Same model holds for all MPT model parameters
(f1 <- mpt_formula(resp ~ 1, model = u2htsm_model))

#### model with condition effects: ~ race
## Each parameter differs across the race variable
(f2 <- mpt_formula(resp ~ race, model = u2htsm_model))

### model with simple by-participant random effects
## because race is within-subject factor, we need random slopes for race
## this model only has correlations within one MPT model parameter
(f3 <- mpt_formula(resp ~ race + (race|id), model = u2htsm_model))

### model with correlated by-participant random effects
## to employ full latent-trait structure (Klauer, 2010), we need to have
## correlations across MPT model parameters
(f4 <- mpt_formula(resp ~ race + (race|p|id), model = u2htsm_model))

### model with crossed random-effects for participants and items:
## because race is a between-item factor (i.e., race is nested within) the item
## factor, we only have random intercepts for item, but they are correlated as
## well.
(f5 <- mpt_formula(resp ~ race + (race|p|id) + (1|i|item), model = u2htsm_model))

### we can also specify an individual structure for each parameters.
## In this case, we need to specify the response variable separately.
(f6 <- mpt_formula(
  Do ~ race + (race|p|id) + (1|i|item),
  Dn ~ race + (race|p|id) + (1|i|item),
  g1x ~ race + (race|p|id) + (1|i|item),
  g2x ~ race + (race|p|id) + (1|i|item),
  response = ~ resp,
  model = u2htsm_model))

all.equal(f5, f6) ## TRUE

### can be more interesting, if we want different structures for each parameter
(f7 <- mpt_formula(
  Do ~ 1 + (1|p|id) + (1|i|item),
  Dn ~ race + (race|p|id) + (1|i|item),
  g1x ~ 1 + (1|p|id) + (1|i|item),
  g2x ~ race + (race|p|id) + (1|i|item),
  response = ~ resp,
  model = u2htsm_model))
}
