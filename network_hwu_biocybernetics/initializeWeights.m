%
w_pattern_context = .3+.5.*rand(size_contexts,size_context_pattern,num_rats);
w_pattern_context = w_pattern_context ./ sqrt(sum(w_pattern_context.^2,2)); % normalization
w_context_multimodal = .3+.5.*rand(size_multimodal,size_contexts,num_rats);
w_flavor_multimodal = .3+.5.*rand(size_multimodal,size_flavors,num_rats);
w_multimodal_well = .3+.5.*rand(size_wells, size_multimodal,num_rats);


w_vhipp_multimodal = -10.*ones(size_multimodal,size_vhipp,num_rats);
w_vhipp_multimodal(randi(numel(w_vhipp_multimodal),1,floor(numel(w_vhipp_multimodal)*P))) = 0;
%skip_length = size_vhipp;
%skip_length = P;
%for c = 1:size(w_vhipp_multimodal,2)
%   w_vhipp_multimodal((mod(c,skip_length)+1):skip_length:end,c,:) = 0; 
%end

w_well_dhipp = .3+.5.*rand(size_dhipp,size_wells,num_rats);
w_flavor_dhipp = .3+.5.*rand(size_dhipp,size_flavors,num_rats);
w_vhipp_dhipp =.3+.5.*rand(size_dhipp,size_vhipp,num_rats);
%normalize all weights going to dhipp as one weight vector
w_vhipp_dhipp = w_vhipp_dhipp ./ sqrt(sum(w_vhipp_dhipp.^2,2)+sum(w_flavor_dhipp.^2,2)+sum(w_well_dhipp.^2,2));
w_flavor_dhipp = w_flavor_dhipp./ sqrt(sum(w_vhipp_dhipp.^2,2)+sum(w_flavor_dhipp.^2,2)+sum(w_well_dhipp.^2,2));
w_well_dhipp = w_well_dhipp ./ sqrt(sum(w_vhipp_dhipp.^2,2)+sum(w_flavor_dhipp.^2,2)+sum(w_well_dhipp.^2,2));
w_context_vhipp = .3+.5.*rand(size_vhipp,size_contexts,num_rats);
w_context_vhipp = w_context_vhipp ./ sqrt(sum(w_context_vhipp.^2,2));

% Weights to LC
w_context_familiarity = .0001.* ones(1,size_contexts,num_rats);
w_dhipp_novelty = ones(1,size_dhipp,num_rats);