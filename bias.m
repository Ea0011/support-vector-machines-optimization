% calculates bias based on the results of the optimization, faster but prone to error
function [b] = bias(classes, vars, optimal, normal)
  [max_value_1, max_index_1] = max(optimal);
  optimal(max_index_1) = -Inf;
  [max_value_2, max_index_2] = max(optimal);

  b = 1 / 2 * (classes(max_index_1) + classes(max_index_2) - dot(vars(max_index_1, :) + vars(max_index_2, :), normal));

  %-------- Calculating the margins --------%

  % Separate classes
  positive_class_points = [];
  negative_class_points = [];
  raw_positive_classes = [];
  raw_negative_classes = [];

  for classIndex = 1:length(classes)
    if (classes[classIndex] == 1)
      positive_class_points = [positive_class_points, vars[classIndex]];
      raw_positive_classes = [raw_positive_classes, 1];
    endif
    if (classes[classIndex] == -1)
      negative_class_points = [negative_class_points, vars[classIndex]];
      raw_negative_classes = [raw_negative_classes, -1];
    endif
  endfor

  % Distances
  positive_point_distances = distances(positive_class_points, normal, b, raw_positive_classes);
  negative_point_distances = distances(negative_class_points, normal, b, raw_negative_classes);

  [_, closest_positive_point_index] = min(abs(positive_point_distances));
  [_, closest_negative_point_index] = min(abs(negative_point_distances));

  % Biases for each class
  % TODO!: return from the function once checked
  closest_positive = positive_class_points(closest_negative_point_index, :);
  closest_negative = negative_class_points(closest_negative_point_index, :);

  closest_positive_bias = -closest_positive(2) * normal(2) - closest_positive(1) * normal(1);
  closest_negative_bias = -closest_negative(2) * normal(2) - closest_negative(1) * normal(1);

endfunction
