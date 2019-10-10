% Clear all neurons except the maximum
function gain = sigmoid(x,slope,offset)     
    gain = 1./(1+exp(-slope.*(x-offset)));
end