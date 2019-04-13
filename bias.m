function [b] = bias(classes, vars, optimal, normal, threshold)
  b = 0;
  cnt = 0;

  for i = 1:length(optimal)
    if optimal(i) > threshold
      cnt = cnt + 1;
      b = b + 1 / classes(i) - dot(vars(i, :), normal);
    endif
  endfor

  b = b / cnt;
endfunction
