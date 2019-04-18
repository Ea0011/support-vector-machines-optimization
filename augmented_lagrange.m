function [optimal] = augmented_lagrange(objective, guess, classes)
  % Constraints derivations
  equality_constraint_1 = @(m) dot(m, classes);
  equality_constraint_2 = @(m) -dot(m, classes);
  inequality_constraint = @(m) -m;
  constraint_function = @(m) [equality_constraint_1(m), equality_constraint_2(m), inequality_constraint(m)];
 
  tolerance = 10^-5;
  e = ones(1, length(classes) + 2);
  x1 = zeros(1, length(classes));
  r = 1;
  l = zeros(1, length(classes) + 2);

  penalty_vector = @(_x, _l, _r) (_l/2) + _r*constraint_function(_x);
  lagrange = @(_l, _r) @(_x) objective(_x) + dot(max(penalty_vector(_x, _l, _r), 0).^2, e);

  % Start optimizing
  x2 = fminsearch(lagrange(l, r), guess);
  l1 = max(l + 2*r*constraint_function(x2), 0);
  if (norm(l1 - l) < 0.5)
   r = r*2;
  endif
  l = l1;

  while (norm(x2 - x1) < tolerance)
    x1 = x2;
    x2 = fminsearch(lagrange(l, r), guess);
    l1 = max(l + 2*r*constraint_function(x2), 0);
    if (norm(l1 - l) < 0.5)
     r = r*2;
    endif
    l = l1;
  endwhile
  
  optimal = x2;
endfunction
