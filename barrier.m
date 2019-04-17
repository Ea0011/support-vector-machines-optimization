function [optimal] = barrier(objective, pen_1, pen_2, guess, classes)
  equality_constraint = @(m) (dot(classes, m)).^2;
  barrier_function = @(m) -1 / dot(-m, ones(1, length(m)));
  
  err = 10^-10;
  max_count = 20;
  cnt = 1;
  
  options = optimset('MaxFunEvals', 100);
  
  optimal_start = guess;
  barrier_objective = @(c1, c2) @(m) objective(m) + c1 * equality_constraint(m) + 1 / c2 * barrier_function(m);
  
  optimal_found = fminsearch(barrier_objective(pen_1, pen_2), optimal_start, options);
  
  while(cnt <= max_count && norm(optimal_start - optimal_found) >= err)
    optimal_start = optimal_found;
    pen_1 = 10^10 * pen_1;
    pen_2 = 10^10 * pen_2;
    
    optimal_found = fminsearch(barrier_objective(pen_1, pen_2), optimal_found, options);
    cnt = cnt + 1;
  endwhile
  
  optimal = optimal_found;
endfunction
