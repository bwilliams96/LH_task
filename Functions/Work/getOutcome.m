function exp = getOutcome(exp, trial, phase)
    exp = updateCount(exp, trial, phase);
    if exp.selected(trial) == 4
        exp.outcome(trial) = exp.learn(exp.counts(exp.order(phase,exp.random(trial))),exp.order(phase,exp.random(trial)));
    else
        exp.outcome(trial) = exp.learn(exp.counts(exp.order(phase,exp.selected(trial))),exp.order(phase,exp.selected(trial)));
    end