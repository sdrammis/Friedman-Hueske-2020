function [aic,bic] = aicbic_final(logL,numParam,numObs)
%AICBIC Akaike and Bayesian information criteria
%
% Syntax:
%
%   [aic,bic] = aicbic(logL,numParam,numObs)
%
% Description:
%
%   Given optimized log-likelihood function values logL obtained by fitting
%   a model to data, compute the Akaike (AIC) and Bayesian (BIC)
%   information criteria. Since information criteria penalize models with
%   additional parameters, aic and bic select models based on both goodness
%   of fit and parsimony. When using either AIC or BIC, models that
%   minimize the criteria are preferred.
%
% Input Arguments:
%
%   logL - Vector of optimized log-likelihood objective function values
%     associated with parameter estimates of various models.
%
%   numParam - Number of estimated parameters associated with each value 
%     in logL. numParam may be a scalar applied to all values in logL, or a 
%     vector the same length as logL. All elements of numParam must be 
%     positive integers.
%
% Optional Input Argument:
%
%   numObs - Sample sizes of the observed data associated with each 
%     value of logL. numObs is required for computing BIC, but not AIC.
%     numObs may be a scalar applied to all values in logL, or a vector the
%     same length as logL. All elements numObs must be positive integers. 
%
% Output Arguments:
%
%   aic - Vector of AIC statistics associated with each logL objective
%     function value. The AIC statistic is defined as:
%
%     	aic = -2*logL + 2*numParam
%
%   bic - Vector of BIC statistics associated with each logL objective
%     function value. The BIC statistic is defined as:
%
%     	bic = -2*logL + numParam*log(numObs)
%
% Reference:
%
%   [1] Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%       Forecasting and Control", 3rd edition, Prentice Hall, 1994.
%
% See also ARIMA, GARCH, VGXVARX, VGXINFER, VGXCOUNT.

% Copyright 1999-2010 The MathWorks, Inc.   

% Ensure the optimized logL is a vector:

if numel(logL) == length(logL)  % Check for a vector
    
   rowLL = (size(logL,1) == 1); % Flag a row vector for outputs
   logL = logL(:);              % Convert to a column vector
   
else
    
   error(message('econ:aicbic:NonVectorLogL'))
     
end

% Ensure numParam is a scalar, or compatible vector, of positive integers:

if (nargin < 2)

   error(message('econ:aicbic:UnspecifiedNumParam'))

else

   if numel(numParam) ~= length(numParam) % Check for a vector
       
      error(message('econ:aicbic:NonVectorNumParam'))
        
   end

   numParam = numParam(:);

   if any(round(numParam)-numParam) || any(numParam <= 0)
       
      error(message('econ:aicbic:NonPositiveNumParam'))
        
   end

   if length(numParam) == 1
      numParam = numParam(ones(length(logL),1)); % Scalar expansion
   end

   if length(numParam) ~= length(logL)
       
      error(message('econ:aicbic:VectorLengthMismatch1'))
        
   end

end

% Ensure numObs is a scalar, or compatible vector, of positive integers:

if nargout >= 2

   if nargin < 3
       
      error(message('econ:aicbic:UnspecifiedNumObs'))
        
   end

   if numel(numObs) ~= length(numObs) % Check for a vector
       
      error(message('econ:aicbic:NonVectorNumObs'))
        
   end

   numObs  =  numObs(:);

   if any(round(numObs)-numObs) || any(numObs <= 0)
       
      error(message('econ:aicbic:NonPositiveNumObs'))
        
   end

   if length(numObs) == 1
      numObs = numObs(ones(length(logL),1)); % Scalar expansion
   end

   if length(numObs) ~= length(logL)
       
      error(message('econ:aicbic:VectorLengthMismatch2'))
        
   end

end

% Compute aic:

aic = -2*logL + 2*numParam;

% Compute bic if requested:

if nargout >= 2

   bic = -2*logL + numParam.*log(numObs);

else

   bic = [];

end

% Re-format outputs for compatibility with the logL input. When logL is
% input as a single row vector, pass the outputs as a row vectors. 

if rowLL
    
   aic = aic(:)';
   bic = bic(:)';
   
end