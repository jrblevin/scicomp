*! version 1.0.0  2012-11-06
*! Maximum likelihood probit estimation in Mata
*! Jason R. Blevins

program define mataprobit, eclass
   version 11
   syntax varlist(fv) [if] [in]
   marksample touse

   /*
    * Sanity checks
    */
   quietly count if `touse'
   if `r(N)' == 0 {
     error 2000
   }

   /*
    * Parse dependent and independent variables.
    */
   gettoken y xvars : varlist
   _fv_check_depvar `y'
   if "`xvars'" == "" {
     di as err "No independent variables specified"
     exit 102
   }
   local nvar: word count `xvars'

   /* Store coefficient names */
   local coeffs "`xvars' _cons"

   /* Let Mata handle estimation */
   mata: probit("`y'", "`xvars'", "`touse'")

   /* Collect postestimation results */
   matrix b = r(b)
   matrix V = r(V)
   matrix start = r(start)
   local N = r(N)
   matrix coleq b = ""
   matrix colnames b = `coeffs'
   matrix coleq V = ""
   matrix roweq V = ""
   matrix colnames V = `coeffs'
   matrix rownames V = `coeffs'

   ereturn post b V, depname("`y'") obs(`N') esample(`touse')
   ereturn scalar N = r(N)
   ereturn matrix start = start
   ereturn local cmdname "mataprobit"
   ereturn local title "Mata Probit"

   /* Format and display results */
   di
   ereturn display
end

version 11
mata:
mata set matastrict on

/*
 * Main interface function for Probit estimation in Mata.
 */
void probit(string scalar yvar,
            string scalar xvars,
            string scalar touse)
{
  external real scalar K, N
  external real rowvector start
  external real colvector Y
  external real matrix X
  real rowvector beta_hat
  real scalar err, nmiter
  real colvector YY
  real matrix XX

  /* Obtain dependent variable and regressors */
  st_view(YY, ., tokens(yvar), touse)
  st_view(XX, ., tokens(xvars), touse)

  /* Number of observations and regressors */
  N = rows(YY)
  K = cols(XX) + 1

  /* Store local copy of data for manipulation and estimation */
  Y = YY
  X = XX, J(N,1,1)

  /* Starting values */
  start = J(1,K,0)

  /* Set up optimization problem */
  S = optimize_init()
  optimize_init_evaluator(S, &mlprobit_gf2()) /* Objective function */
  optimize_init_params(S, start)              /* Pass starting values */
  optimize_init_which(S, "max")               /* Maximize the function */
  optimize_init_evaluatortype(S, "gf2")       /* Objective function type */
  optimize_init_technique(S, "nr")            /* Newton Raphson */
  err = _optimize(S)                          /* Maximize the function */

  /* Return values */
  if (err == 0) {
    beta_hat = optimize_result_params(S)
    V = optimize_result_V_oim(S)
  }
  else {
    beta_hat = .
    V = .
  }

  /* Store additional results */
  st_matrix("r(b)", beta_hat)
  st_matrix("r(V)", V)
  st_matrix("r(start)", start)
  st_numscalar("r(N)", N)
}

/*
 * Maximum likelihood probit objective function, gradient, and
 * Hessian.
 */
void mlprobit_gf2(todo, param, loglik, grad, H)
{
  external real scalar K, N
  external real rowvector start
  external real colvector Y
  external real matrix X
  real colvector beta, idx, f0, f1, ones
  real scalar i

  /* Stata stores parameter vectors as rows */
  beta = param'

  /* Precalculate linear index and likelihood values */
  idx = X * beta
  ones = J(N,1,1)
  f0 = normal(idx)

  /* Log likelihood function */
  loglik = Y :* ln(f0) + (ones - Y) :* ln(ones - f0)

  if (todo >= 1) {
    /* Gradient */
    f1 = normalden(idx)
    grad = (Y :* (f1 :/ f0) - (ones - Y) :* (f1 :/ (ones - f0))) :* X

    if (todo >= 2) {
      /* Hessian */
      H = J(K,K,0)
      for (i = 1; i <= N; i++) {
        if (Y[i] > 0) {
          H = H + (idx[i] * f1[i] / f0[i] + f1[i]^2 / f0[i]^2) ///
            * X[i,.]' * X[i,.]
        }
        else {
          H = H + (f1[i]^2 / (1 - f0[i])^2 - idx[i] * f1[i] / (1 - f0[i])) ///
            * X[i,.]' * X[i,.]
        }
      }
      H = -H
    }
  }
}

end
