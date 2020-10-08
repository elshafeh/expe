function taco_instructstim(nstim)

global wPtr scr stim Info

taco_darkenBackground;

intruct_text{1}         = '\n\nClick to see your low frequency sitmulus\n\n';
intruct_text{2}         = '\n\nClick to see your high frequency sitmulus\n\n';


DrawFormattedText(wPtr, intruct_text{nstim}, 'center', 'center', scr.black);
Screen('Flip', wPtr);

if strcmp(Info.MotorResponse,'yes')
    if IsLinux
        taco_response_wait;
    else
        KbWait(-1);
    end
end

taco_drawFixation;
Screen('Flip', wPtr);

if IsLinux
    scr.b.clearResponses;
end