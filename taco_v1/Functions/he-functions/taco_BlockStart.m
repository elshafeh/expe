function taco_BlockStart

global wPtr scr stim Info

taco_darkenBackground;
DrawFormattedText(wPtr, scr.Pausetext, 'center', 'center', scr.black);
Screen('Flip', wPtr);

if strcmp(Info.MotorResponse,'yes')
    if IsLinux
        taco_response_wait;
    else
        KbWait(-1);
    end
end

if IsLinux
    scr.b.sendTrigger(250); % start trigger
end

taco_drawFixation;
Screen('Flip', wPtr);