function taco_BlockEnd(ix)

global wPtr scr stim Info

%% -- force it to wait for input
h_emptybitsi;
WaitSecs(stim.dur.InstructionPause);
h_emptybitsi;
%% -- force it to wait for input

i1                                          = ix(1);
i2                                          = ix(end);
bloc_perf                                   = cell2mat(Info.TrialInfo.repCorrect(i1:i2));
bloc_perf                                   = sum(bloc_perf)/length(bloc_perf);

endtext1                                    = [num2str(bloc_perf) '\n\n! GREAT JOB !'];

h_emptybitsi;

if IsLinux
    scr.b.sendTrigger(251); % end trigger
end

endtext2                                    = '\n\n\nPlease Take Some Rest :) \n\n\n And press any button to continue';

taco_darkenBackground;
DrawFormattedText(wPtr, [endtext1 endtext2], 'center', 'center', scr.black);
Screen('Flip', wPtr);

if strcmp(Info.MotorResponse,'yes')
    if IsLinux
        taco_response_wait;
    else
        KbWait(-1);
    end
end

taco_darkenBackground;
taco_drawFixation;
Screen('Flip', wPtr);
WaitSecs(stim.dur.InstructionPause);