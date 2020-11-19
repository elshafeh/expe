function [tcue1,tcue2,tcue3] = taco_drawcue(CueInfo)

global scr wPtr

taco_darkenBackground;

fixCrossDimPix  = 40;
xCoords         = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords         = [0 0 0 0];
allCoords       = [xCoords; yCoords];

lineWidthPix    = 7;
DashWidthPix    = 7;

cy1             = scr.yCtr-10;
cy2             = scr.yCtr+10;

if isfield(CueInfo,'t_offset')
    tcue1       = CueInfo.t_offset;
else
    taco_drawFixation;
    tcue1       = Screen('Flip', wPtr);
    taco_darkenBackground;
end

switch CueInfo.type
    case 1 % pre
        switch CueInfo.order
            case 1 % first cue (inf)
                switch CueInfo.attend
                    case 1 % attend first grating
                        Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [scr.xCtr cy2], 2);
                        Screen('LineStipple', wPtr, 0);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [scr.xCtr cy1], 2);
                        
                    case 2 % attend second grating
                        % for some reason unknown to me this was the only
                        % to draw solid lines
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [scr.xCtr cy1], 2);
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [scr.xCtr cy2], 2);
                        
                end
            case 2 % second cue (uninformative)
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [scr.xCtr cy1], 2);
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [scr.xCtr cy2], 2);
        end
    case 2 % retro
        switch CueInfo.order
            case 2 % 2nd cue (inf)
                switch CueInfo.attend
                    case 1 % attend first grating
                        Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [scr.xCtr cy2], 2);
                        Screen('LineStipple', wPtr, 0);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [scr.xCtr cy1], 2);
                        
                    case 2 % attend second grating
                        
                        % for some reason unknown to me this was the only
                        % to draw solid lines
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [scr.xCtr cy1], 2);
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [scr.xCtr cy2], 2);
                        
                end
            case 1 % 1st cue (uninformative)
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [scr.xCtr cy1], 2);
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [scr.xCtr cy2], 2);
        end
end

tcue2           = Screen('Flip', wPtr,tcue1+CueInfo.t_wait - scr.ifi/2);

if IsLinux
    scr.b.sendTrigger(CueInfo.code); % send trigger
end

taco_drawFixation;
tcue3           = Screen('Flip', wPtr,tcue2+CueInfo.dur - scr.ifi/2);