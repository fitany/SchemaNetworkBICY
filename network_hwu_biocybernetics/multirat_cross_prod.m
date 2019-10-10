% x (AxR)
% y (BxR)
% result (AxBxR)
function result = multirat_cross_prod(x,y)
    if size(x,2)==1
        result = x*y';
    else
        result = zeros(size(x,1),size(y,1),size(y,2));
        for i = 1:size(x,2)
            result(:,:,i) = x(:,i)*y(:,i)';
        end
    end
end