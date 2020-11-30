function loca_end

global wPtr scr stim Info
h_emptybitsi;


endtext2                    = '\n\n\nPlease Take Some Rest :) \n\n\n And press any button to continue';

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