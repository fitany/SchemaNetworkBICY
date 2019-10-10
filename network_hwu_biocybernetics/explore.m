%train context and indices. run for only one time step, so no need to save states
n_context_pattern = n_context_pattern.*0;
n_context_pattern(schema(:,1),:) = 1;
n_flavor = n_flavor.*0;
n_flavor(sub2ind([size_flavors, num_rats],schema(p,2)',(1:num_rats))) = 1;
n_context = relu(multirat_dot_prod(w_pattern_context,n_context_pattern));
mPFC_activity = [mPFC_activity; n_context(:,1)'];
[n_context,m,i_context] = wta(n_context);

n_well = n_well.*0;
n_well(sub2ind([size_wells, num_rats],schema(p,1)',(1:num_rats))) = 1;

if has_hipp
    n_vhipp = relu(multirat_dot_prod(w_context_vhipp,n_context));
    vHPC_activity = [vHPC_activity; n_vhipp(:,1)'];
    [n_vhipp,m,i] = wta(n_vhipp);
    n_dhipp = relu(.1.*multirat_dot_prod(w_vhipp_dhipp,n_vhipp) + multirat_dot_prod(w_flavor_dhipp,n_flavor) + multirat_dot_prod(w_well_dhipp,n_well));
    dHPC_activity = [dHPC_activity; n_dhipp(:,1)'];
    [n_dhipp,m_dhipp,i_dhipp] = wta(n_dhipp);
    w_vhipp_dhipp = w_vhipp_dhipp + lr_explore.*multirat_cross_prod(n_dhipp,n_vhipp);
    w_flavor_dhipp = w_flavor_dhipp + lr_explore.*multirat_cross_prod(n_dhipp,n_flavor);
    w_well_dhipp = w_well_dhipp + lr_explore.*multirat_cross_prod(n_dhipp,n_well);
end
w_pattern_context = w_pattern_context +  lr_pattern .* multirat_cross_prod(n_context,n_context_pattern);
w_pattern_context = w_pattern_context ./ sqrt(sum(w_pattern_context.^2,2)); % normalization

% LC Update
novelty = relu(multirat_dot_prod(w_dhipp_novelty,n_dhipp));
familiarity = multirat_dot_prod(w_context_familiarity,n_context);
old_familiarity = familiarity;
familiarity = 1./(1+exp(-200.*(familiarity-.03)));%-600,.01

% LC weights
if has_hipp
    w_dhipp_novelty = w_dhipp_novelty - lr_explore.*multirat_cross_prod(novelty,n_dhipp);
end
w_context_familiarity = w_context_familiarity + lr_pattern.*multirat_cross_prod(familiarity,n_context);

% Normalize all weights going to dhipp as one weight vector
if has_hipp
    w_vhipp_dhipp = w_vhipp_dhipp ./ sqrt(sum(w_vhipp_dhipp.^2,2)+sum(w_flavor_dhipp.^2,2)+sum(w_well_dhipp.^2,2));
    w_flavor_dhipp = w_flavor_dhipp./ sqrt(sum(w_vhipp_dhipp.^2,2)+sum(w_flavor_dhipp.^2,2)+sum(w_well_dhipp.^2,2));
    w_well_dhipp = w_well_dhipp ./ sqrt(sum(w_vhipp_dhipp.^2,2)+sum(w_flavor_dhipp.^2,2)+sum(w_well_dhipp.^2,2));
    w_context_vhipp = w_context_vhipp ./ sqrt(sum(w_context_vhipp.^2,2));
end

if e < settle_step && has_hipp
    LC_max = max(familiarity.*novelty,LC_max);
    familiarity_max = familiarity;
    novelty_max = novelty;
end

if e == settle_step
    if constant_epochs
        epochs = repmat(epochs_param,1,num_rats);
    else
        if has_hipp
            epochs = repmat(default_epochs,1,num_rats) + LC_max.*boost_epochs;
        else
            epochs = repmat(default_epochs,1,num_rats);
        end
    end
    if exist('total_epochs','var')
        total_epochs = total_epochs + epochs;
    end
    schema_activity = [schema_activity; LC_max];
    novelty_activity = [novelty_activity; novelty_max];
    familiarity_activity = [familiarity_activity; familiarity_max];
    active_schema = [active_schema; i_context];
end