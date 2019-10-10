% Clear all neurons except the maximum
function [n,m,i] = wta(n)     
    [m,i] = max(n);
    n = n.*0;
    if size(n,2)==1
        n(i) = m;
    else
        n(sub2ind(size(n),i,1:size(n,2))) = m;
    end
end