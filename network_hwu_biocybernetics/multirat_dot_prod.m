% W (AxBxR)
% x (BxR)
% result (AxR)
function result = multirat_dot_prod(W,x)
    if size(W,3)==1
        result = W*x;
    else
        result = zeros(size(W,1),size(x,2));
        for i = 1:size(W,3)
            result(:,i) = W(:,:,i)*x(:,i);
        end
    end
end