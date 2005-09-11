%------------------------------------------------------------------------------%
% HGNC - hourglass corrections, node to cell

function hg = hgnc( f, i, iq, j, k, l )

switch iq
case 1, hg = ...
  - f(j,k,l,i) - f(j+1,k+1,l+1,i) ...
  - f(j+1,k,l,i) - f(j,k+1,l+1,i) ...
  + f(j,k+1,l,i) + f(j+1,k,l+1,i) ...
  + f(j,k,l+1,i) + f(j+1,k+1,l,i);
case 2, hg = ...
  - f(j,k,l,i) - f(j+1,k+1,l+1,i) ...
  + f(j+1,k,l,i) + f(j,k+1,l+1,i) ...
  - f(j,k+1,l,i) - f(j+1,k,l+1,i) ...
  + f(j,k,l+1,i) + f(j+1,k+1,l,i);
case 3, hg = ...
  - f(j,k,l,i) - f(j+1,k+1,l+1,i) ...
  + f(j+1,k,l,i) + f(j,k+1,l+1,i) ...
  + f(j,k+1,l,i) + f(j+1,k,l+1,i) ...
  - f(j,k,l+1,i) - f(j+1,k+1,l,i);
case 4, hg = ...
  - f(j,k,l,i) + f(j+1,k+1,l+1,i) ...
  + f(j+1,k,l,i) - f(j,k+1,l+1,i) ...
  + f(j,k+1,l,i) - f(j+1,k,l+1,i) ...
  + f(j,k,l+1,i) - f(j+1,k+1,l,i);
otherwise error 'iq'
end

