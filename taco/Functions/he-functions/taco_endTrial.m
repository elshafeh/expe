function tfin = taco_endTrial

global stim wPtr Info ctl scr

if strcmp(Info.runtype,'train')
    
    if ctl.correct == 1
        stim.Fix.color          = scr.green; % repmat(scr.green, [1,3]);
    else
        stim.Fix.color          = scr.red; % repmat(scr.red, [1,3]);
    end
    
    taco_darkenBackground;
    JY_VisExptTools('draw_fixation', stim.Fix);
    Screen('Flip', wPtr);
    WaitSecs(0.2);
    taco_drawFixation;
    tfin                        = Screen('Flip', wPtr);
    WaitSecs(0.2)
    
    
else
    taco_darkenBackground;
    taco_drawFixation;
    tfin                        = Screen('Flip', wPtr);
end