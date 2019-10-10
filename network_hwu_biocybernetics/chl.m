%free state
for t = 1:ts
    n_flavor_new = n_flavor.*0;
    n_flavor_new(sub2ind([size_flavors, num_rats],schema(p,2)',(1:num_rats))) = 1;
    n_multimodal_new = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context) + g.*multirat_dot_prod(permute(w_multimodal_well,[2 1 3]),n_well));
    n_well_new = relu(multirat_dot_prod(w_multimodal_well,n_multimodal));
    
    n_flavor = n_flavor_new;
    n_multimodal = n_multimodal_new;
    n_well = n_well_new;
end

%anti-hebbian update      
w_flavor_multimodal_subtract = lr.*g.*multirat_cross_prod(n_multimodal,n_flavor);
w_context_multimodal_subtract = lr.*g.*multirat_cross_prod(n_multimodal,n_context);
w_multimodal_well_subtract = lr.*g.*multirat_cross_prod(n_well,n_multimodal);

%clamped state
for t = 1:ts
    if has_hipp
        n_multimodal_new = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context) + g.*multirat_dot_prod(permute(w_multimodal_well,[2,1,3]),n_well) + multirat_dot_prod(w_vhipp_multimodal,n_vhipp));
        n_well_new = relu(multirat_dot_prod(permute(w_well_dhipp,[2 1 3]),n_dhipp));
    else
        n_multimodal_new = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context) + g.*multirat_dot_prod(permute(w_multimodal_well,[2,1,3]),n_well));
    end
    
    n_flavor = n_flavor_new;
    n_multimodal = n_multimodal_new;
    n_well = n_well_new;
end

%combined update
w_flavor_multimodal = w_flavor_multimodal + lr.*g.*multirat_cross_prod(n_multimodal,n_flavor) - w_flavor_multimodal_subtract;
w_context_multimodal = w_context_multimodal + lr.*g.*multirat_cross_prod(n_multimodal,n_context) - w_context_multimodal_subtract;
w_multimodal_well = w_multimodal_well + lr.*g.*multirat_cross_prod(n_well,n_multimodal) - w_multimodal_well_subtract;
