function taco_headlocaliserbreak

global wPtr scr stim Info

taco_darkenBackground;
DrawFormattedText(wPtr, 'Please wait while we double-check where your head is :)', 'center', 'center', scr.black);
Screen('Flip', wPtr);

if strcmp(Info.MotorResponse,'yes')
    KbWait(-1);
end

taco_drawFixation;
Screen('Flip', wPtr);