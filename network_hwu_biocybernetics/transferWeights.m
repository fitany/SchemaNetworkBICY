 if ~has_hipp
    if transferIn
        w_pattern_context = w_pattern_context_HPC;
        w_context_multimodal = w_context_multimodal_HPC;
        w_flavor_multimodal = w_flavor_multimodal_HPC;
        w_multimodal_well = w_multimodal_well_HPC;
        w_vhipp_multimodal = w_vhipp_multimodal_HPC;
        w_well_dhipp = w_well_dhipp_HPC;
        w_flavor_dhipp= w_flavor_dhipp_HPC;
        w_vhipp_dhipp = w_vhipp_dhipp_HPC;
    else
        w_pattern_context_HPC = w_pattern_context;
        w_context_multimodal_HPC = w_context_multimodal;
        w_flavor_multimodal_HPC = w_flavor_multimodal;
        w_multimodal_well_HPC = w_multimodal_well;
        w_vhipp_multimodal_HPC = w_vhipp_multimodal;
        w_well_dhipp_HPC = w_well_dhipp;
        w_flavor_dhipp_HPC = w_flavor_dhipp;
        w_vhipp_dhipp_HPC = w_vhipp_dhipp;
    end
 else
    if transferIn
        w_pattern_context = w_pattern_context_control;
        w_context_multimodal = w_context_multimodal_control;
        w_flavor_multimodal = w_flavor_multimodal_control;
        w_multimodal_well = w_multimodal_well_control;
        w_vhipp_multimodal = w_vhipp_multimodal_control;
        w_well_dhipp = w_well_dhipp_control;
        w_flavor_dhipp = w_flavor_dhipp_control;
        w_vhipp_dhipp = w_vhipp_dhipp_control;
    else
        w_pattern_context_control = w_pattern_context;
        w_context_multimodal_control = w_context_multimodal;
        w_flavor_multimodal_control = w_flavor_multimodal;
        w_multimodal_well_control = w_multimodal_well;
        w_vhipp_multimodal_control = w_vhipp_multimodal;
        w_well_dhipp_control = w_well_dhipp;
        w_flavor_dhipp_control = w_flavor_dhipp;
        w_vhipp_dhipp_control = w_vhipp_dhipp;
    end
 end