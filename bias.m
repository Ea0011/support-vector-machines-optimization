function [b] = bias(classes, vars, optimal, normal)
  [max_value_1, max_index_1] = max(optimal);
  optimal(max_index_1) = -Inf;
  [max_value_2, max_index_2] = max(optimal);

  b = 1 / 2 * (classes(max_index_1) + classes(max_index_2) - dot(vars(max_index_1, :) + vars(max_index_2, :), normal));
endfunction
