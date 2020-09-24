function [repRT,repButton,repCorrect] = taco_getResponse

% this first present the response mapping then
% captures responses from keyboard or
% response device in DCCN behavioral cubicles

global scr ctl wPtr

taco_darkenBackground;

switch ctl.maptype
    case 1
        DrawFormattedText(wPtr,'Do They Match? \n\n\nY                     N\n\n', 'center', 'center', scr.black);
    case 2
        DrawFormattedText(wPtr,'Do They Match? \n\n\nN                     Y\n\n', 'center', 'center', scr.black);
end

Screen('Flip', wPtr,ctl.t_offset+ctl.t_wait - scr.ifi/2);

t_report                 	= GetSecs;

if IsLinux
    
    scr.b.clearResponses;
    
    [b_button,response_time]	= scr.b.getResponse(120*120,1); % wait for an hour :)
    list_bitsi           	= [97 100 98 99 1:96];
    repButton            	= find(list_bitsi == b_button);
    
    if repButton > 2
        repButton         	= -1;
    end
    
    scr.b.clearResponses;
    
else
    
    [response_time, keyCode, ~]         = KbWait(-1);
    repButton             	= find(keyCode(ctl.keyValid) == 1);
    
    if isempty(repButton)
        repButton         	= -1;
    end
    
end

repRT                      	= response_time-t_report;

if repButton < 0
    repCorrect              = 0;
else
    if repButton == ctl.expectedRep
        repCorrect          = 1;
    else
        repCorrect          = 0;
    end
end