clearNeurons;
scores = zeros(days,num_rats);
schema_activity = [];
novelty_activity = [];
familiarity_activity = [];
active_schema = [];
mPFC_activity = [];
vHPC_activity = [];
dHPC_activity = [];
fprintf('\nRunning day ');
for d = 1:days
    fprintf('%i,', d);
    e = 1;
    LC_max = zeros(1,num_rats);
    epochs = 100; % starter number to kick off while loop
    while e < max(floor(epochs))
        % Clear neurons again to avoid interference
        clearNeurons;
        % Note: random roaming of rat is not simulated, just the roaming to
        % food areas
        p = randi(size(schema,1),num_rats,1); % pick random pair
        %exploratory state
        explore;
        chl;
        e = e+1;
        done_rat = find(floor(epochs)==e);
        if ~isempty(done_rat)
            %test
            testSchema;
            for i=1:length(done_rat)
                scores(d,done_rat(i)) = score(done_rat(i));
            end
        end  
	end
end