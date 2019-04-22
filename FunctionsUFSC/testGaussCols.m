function [H, out, p] = testGaussCols(M)
% test if all columns of the matrix M are normal distributions using the
% swtest, ignoring NaN columns
% if H = 0, all columns can be considered to come from a normal
% distribution. else, not.
% out is the hypothesis test for each column
% p is the significance value of the kstest for each column

% References:
%
% - Royston P. "Remark AS R94", Applied Statistics (1995), Vol. 44,
%   No. 4, pp. 547-551.
%   AS R94 -- calculates Shapiro-Wilk normality test and P-value
%   for sample sizes 3 <= n <= 5000. Handles censored or uncensored data.
%   Corrects AS 181, which was found to be inaccurate for n > 50.
%   Subroutine can be found at: http://lib.stat.cmu.edu/apstat/R94

[~,cols] = size(M);

m = mean(M);
s = std(M);

nanidx = find(isnan(m));

out = 2*ones(1,cols-length(nanidx));
p = 2*ones(1,cols-length(nanidx));
for c = 1:cols
    %convert to standard distribution
    if ~ismember(c,nanidx)
        M2 = (M(:,c)-m(c))/s(c);
        [out(c), p(c)] = swtest(M2); %out=0 data is gaussian
    else
        out(c) = NaN;
        p(c) = NaN;
    end
end

H = sum(out(~isnan(out)));