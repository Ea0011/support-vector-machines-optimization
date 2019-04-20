function [optimal, time] = barrier(objective, pen_1, pen_2, guess, classes)
  start = time();  
  
  eql_constraint = @(m) (dot(m, classes)).^2;
  barrier_function = @(m) -1 / dot(-m, ones(1, length(m)));
  
  err = 10^-50;
  max_count = 100;
  cnt = 1;
  
  optimal_start = guess;
  barrier_objective = @(c1, c2) @(m) objective(m) + c1 * eql_constraint(m) + 1 / c2 * barrier_function(m);
  
  optimal_found = fminsearch(barrier_objective(pen_1, pen_2), optimal_start);
  
  while(cnt <= max_count && norm(optimal_start - optimal_found) >= err &&
        norm(barrier_objective(pen_1, pen_2)(optimal_found) - 
        barrier_objective(pen_1, pen_2)(optimal_start)) >= err)
        
    optimal_start = optimal_found;
    pen_1 = 10^20 * pen_1;
    pen_2 = 10^20 * pen_2;
    
    optimal_found = fminsearch(barrier_objective(pen_1, pen_2), optimal_found);
    cnt = cnt + 1;
  endwhile
  
  optimal = optimal_found;
  
  time = time() - start;
endfunction
