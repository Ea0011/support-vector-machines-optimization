% calculate distances to points from a hyperplane
function [distances] = distances(vars, normal, bias, classes)
    distances = [];

    for i=1:length(vars)
        distances(i, :) = [dot(normal, vars(i, :)) + bias, classes(i)];
    endfor
endfunction
