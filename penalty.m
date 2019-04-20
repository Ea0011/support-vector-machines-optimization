function [optimal, time] = penalty(objective, pen_1, pen_2, guess, classes)
  start = time();
  
  err = 10^-50;
  max_count = 100;
  cnt = 1;
  
  equality_constraint = @(m) (dot(classes, m)).^2;
  inequality_constraints = @(m) dot((max(0, -m)).^2, ones(1, length(m)));

  optimal_start = -guess;
  penalty_obejctive = @(c1, c2) @(m) objective(m) + c1 * equality_constraint(m) + c2 * inequality_constraints(m);
  
  optimal_found = fminsearch(penalty_obejctive(pen_1, pen_2), optimal_start);
  
  while(cnt <= max_count && norm(optimal_start - optimal_found) >= err 
        && norm(penalty_obejctive(pen_1, pen_2)(optimal_found) - 
        penalty_obejctive(pen_1, pen_2)(optimal_start)) >= err)
        
    optimal_start = optimal_found;
    pen_1 = 10^5 * pen_1;
    pen_2 = 10^5 * pen_2;
    
    optimal_found = fminsearch(penalty_obejctive(pen_1, pen_2), optimal_found);
    cnt = cnt + 1;
  endwhile
  
  optimal = optimal_found;
  
  time = time() - start;
endfunction
