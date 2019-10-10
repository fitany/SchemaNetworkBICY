% Convert population activity to a distribution and calc entropy
function h = calc_entropy(pop)
    %pop = pop + eps;
    pop = pop ./ sum(pop);
    h = -sum(pop.*log(pop)./log(length(pop)));% normalized
    %h = -sum(pop.*log(pop));
end