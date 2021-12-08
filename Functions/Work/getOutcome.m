function [exp, outcome] = getOutcome(exp, trial, phase)
    exp = updateCount(exp, trial, phase);
    outcome = exp