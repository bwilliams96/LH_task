function exp = getOutcome_desc(exp, trial, phase, desc_step)
    if exp.selected(trial) == 4
        exp.outcome(trial) = exp.desc(desc_step,exp.order(phase,exp.random(trial)));
    else
        exp.outcome(trial) = exp.desc(desc_step,exp.order(phase,exp.selected(trial)));
    end