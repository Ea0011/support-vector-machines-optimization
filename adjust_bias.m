% adaptive method to calculate bias, does not rely on the result of the optimization problem, slower but yields better results
function [adjusted_bias, margin_bias_1, margin_bias_2] = adjust_bias(vars, normal, classes, cl, lb)
  % iset intial bias to 0
  bias = 0;
  
  dists_to_points = distances(vars, normal, bias, classes);

  % find the closest point to the line
  [_, min_index] = min(abs(dists_to_points));
  closest_class = classes(min_index(1));
  % find the closest point of the opposite class
  [_, closest_opposite_class] = min(abs(dists_to_points()(dists_to_points(:, 2) == -closest_class)));
  % if opposite class is the negative class add half the number of classes to get the actual index not the in negative classes
  if (closest_class == 1)
    closest_opposite_class = floor(length(classes) / 2) + closest_opposite_class;
  endif

  % set the line to pass through the closest point of the opposite class
  bias = -vars(closest_opposite_class, :)(2) * normal(2) - vars(closest_opposite_class, :)(1) * normal(1);
  opposing_bias = bias;
  margin_bias_1 = bias;
  
  % calculate new distances to points
  dists_to_points = distances(vars, normal, bias, classes);
  
  % find the closest point of the opposite class again
  [_, closest_opposite_class] = min(abs(dists_to_points(dists_to_points(:, 2) == closest_class)));
  
  if (closest_class == -1)
    closest_opposite_class = floor(length(classes) / 2) + closest_opposite_class;
  endif
  
  % set the lint to pass throgh that point
  bias = -vars(closest_opposite_class, :)(2) * normal(2) - vars(closest_opposite_class, :)(1) * normal(1);
  margin_bias_2 = bias;
  
  % get the bias so that the line passes through the middle of two classes
  adjusted_bias = abs(bias + opposing_bias) ./ 2;
endfunction
