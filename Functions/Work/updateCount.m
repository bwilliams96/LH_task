function exp = updateCount(exp, trial, phase)
    if exp.selected(trial) == 4
        exp.random(trial) = randi([1 3],1);
        exp.counts(exp.order(phase,exp.random(trial))) = exp.counts(exp.order(phase,exp.random(trial))) +1;
        exp.counts(4) = exp.counts(4) + 1;
    else
        exp.counts(exp.order(phase,exp.selected(trial))) = exp.counts(exp.order(phase,exp.selected(trial))) + 1;
    end
