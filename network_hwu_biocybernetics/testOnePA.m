% Test one PA
p = cue;
n_context_pattern = n_context_pattern.*0;
n_context_pattern(schema(:,1),:) = 1;
n_flavor = n_flavor.*0;
n_flavor(schema(p,2),:) = 1;
n_context = relu(multirat_dot_prod(w_pattern_context,n_context_pattern));
[n_context,m,i] = wta(n_context);
if has_hipp
    n_vhipp = relu(multirat_dot_prod(w_context_vhipp,n_context));
    [n_vhipp,m,i] = wta(n_vhipp);
    n_multimodal = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context) + multirat_dot_prod(w_vhipp_multimodal,n_vhipp));
else
    n_multimodal = relu(multirat_dot_prod(w_flavor_multimodal,n_flavor) + multirat_dot_prod(w_context_multimodal,n_context));
end
n_well = relu(multirat_dot_prod(w_multimodal_well,n_multimodal));
n_well = n_well + eps;
perf_cued = n_well(schema(p,1),:)./sum(n_well(schema(:,1),:));
perf_noncued = n_well(schema(noncue,1),:)./sum(n_well(schema(:,1),:));
[h,p,ci,stats] = ttest(perf_cued',perf_noncued')
[h1,p1] = kstest2(perf_cued,perf_noncued)
[h2,p2] = kstest2(perf_cued,(1-perf_cued-perf_noncued)./3)
[h3,p3] = kstest2(perf_noncued,(1-perf_cued-perf_noncued)./3)
if exist('prev_perf_cued')
    [h4,p4] = kstest2(perf_cued,prev_perf_cued)
end
prev_perf_cued=perf_cued;
err_cued = std(perf_cued)./sqrt(num_rats);
err_noncued = std(perf_noncued)./sqrt(num_rats);
err_orig = std((1-perf_cued-perf_noncued))./sqrt(num_rats);
perf_cued = mean(perf_cued);
perf_noncued = mean(perf_noncued);