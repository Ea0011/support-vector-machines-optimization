function [optimal] = penalty(objective, pen_1, pen_2, guess, classes)
  err = 10^-10;
  max_count = 20;
  cnt = 1;
  
  equality_constraint = @(m) (dot(classes, m)).^2;
  inequality_constraints = @(m) dot((max(0, -m)).^2, ones(1, length(m)));
  
  options = optimset('MaxFunEvals', 100);

  optimal_start = -guess;
  penalty_obejctive = @(c1, c2) @(m) objective(m) + c1 * equality_constraint(m) + c2 * inequality_constraints(m);
  
  optimal_found = fminsearch(penalty_obejctive(pen_1, pen_2), optimal_start, options);
  
  while(cnt <= max_count && norm(optimal_start - optimal_found) >= err)
    optimal_start = optimal_found;
    pen_1 = 10^10 * pen_1;
    pen_2 = 10^10 * pen_2;
    
    optimal_found = fminsearch(penalty_obejctive(pen_1, pen_2), optimal_found, options);
    cnt = cnt + 1;
  endwhile
  
  optimal = optimal_found;
endfunction
