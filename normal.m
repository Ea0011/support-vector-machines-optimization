function [w] = normal(optimal, data, classes)
  w = [];
  kernelized_normal = 0;
  for i = 1:length(data(1, :))
    acc = 0;
    for j = 1:length(classes)
      acc = acc + optimal(j) * classes(j) * data(j, :)(i);
    endfor
    w(i) = acc;
    acc = 0;
  endfor
  
  w = w / norm(w);
endfunction