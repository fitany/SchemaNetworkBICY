% Test network
pair_scores = zeros(size(schema,1),num_rats);
for p = 1:size(schema,1)
    n_context_pattern = n_context_pattern.*0;
    n_context_pattern(schema(:,1),:) = 1;
    n_flavor = n_flavor.*0;
    n_flavor(schema(p,2),:) = 1;
    n_context = relu(multirat_dot_prod(w_pattern_context,n_context_pattern));
    [n_context,m,i] = wta(n_context);
    %{
    if has_hipp
        n_vhipp = relu(multirat_dot_prod(w_context_vhipp,n_context));
        [n_vhipp,m,i] = wta(n_vhipp);
        n_multimodal = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context) + multirat_dot_prod(w_vhipp_multimodal,n_vhipp));
    else
        n_multimodal = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context));
    end
    n_well = relu(multirat_dot_prod(w_multimodal_well,n_multimodal));
    n_well = n_well + eps;
    %}
    for t = 1:ts
        n_flavor_new = n_flavor.*0;
        n_flavor_new(schema(p,2),:) = 1;
        n_multimodal_new = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context) + g.*multirat_dot_prod(permute(w_multimodal_well,[2 1 3]),n_well));
        n_well_new = relu(multirat_dot_prod(w_multimodal_well,n_multimodal));

        n_flavor = n_flavor_new;
        n_multimodal = n_multimodal_new;
        n_well = n_well_new;
    end
    n_well = n_well + eps;
    pair_scores(p,:) = n_well(schema(p,1),:)./sum(n_well(schema(:,1),:));
end

score = mean(pair_scores);

n_flavor_new = n_flavor.*0;
n_flavor_new(schema(p,2),:) = 1;
n_multimodal_new = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context) + g.*multirat_dot_prod(permute(w_multimodal_well,[2 1 3]),n_well));
n_well_new = relu(multirat_dot_prod(w_multimodal_well,n_multimodal));

n_flavor = n_flavor_new;
n_multimodal = n_multimodal_new;
n_well = n_well_new;