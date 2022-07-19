function exp = getOutcome(exp, trial, phase)
    exp = updateCount(exp, trial, phase);
    exp.outcome(trial) = exp.learn(exp.counts(exp.order(phase,exp.selected(trial))),exp.order(phase,exp.selected(trial)));
    end