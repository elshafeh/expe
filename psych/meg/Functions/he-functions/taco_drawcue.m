function [tcue1,tcue2,tcue3] = taco_drawcue(CueInfo)

global scr wPtr

mon_width       = scr.size(1);   % horizontal dimension of viewable screen (cm)
v_dist          = 100;   % viewing distance (cm)
ppd             = pi * (scr.rect(3)-scr.rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
dot_w           = 0.1;
s               = dot_w * ppd;                                        % line size (pixels)

taco_darkenBackground;

fixCrossDimPix  = 60;

yCoords         = [-fixCrossDimPix fixCrossDimPix 0 0]; %
xCoords         = [0 0 0 0]; %

allCoords       = [xCoords; yCoords];

lineWidthPix    = s; %7;
DashWidthPix    = s; %7;

cy1             = scr.xCtr-20; % 10
cy2             = scr.xCtr+20; % 10

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
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [cy2 scr.yCtr ], 2);
                        Screen('LineStipple', wPtr, 0);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [cy1 scr.yCtr], 2);
                        
                    case 2 % attend second grating
                        % for some reason unknown to me this was the only
                        % to draw solid lines
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [cy1 scr.yCtr], 2);
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [cy2 scr.yCtr], 2);
                        
                end
            case 2 % second cue (uninformative)
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [cy1 scr.yCtr], 2);
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [cy2 scr.yCtr], 2);
        end
    case 2 % retro
        switch CueInfo.order
            case 2 % 2nd cue (inf)
                switch CueInfo.attend
                    case 1 % attend first grating
                        Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [cy2 scr.yCtr], 2);
                        Screen('LineStipple', wPtr, 0);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [cy1 scr.yCtr ], 2);
                        
                    case 2 % attend second grating
                        
                        % for some reason unknown to me this was the only
                        % to draw solid lines
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [cy1 scr.yCtr ], 2);
                        Screen('LineStipple', wPtr, 1, 1, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
                        Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [cy2 scr.yCtr], 2);
                        
                end
            case 1 % 1st cue (uninformative)
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]); % 
                Screen('DrawLines', wPtr, allCoords,DashWidthPix, scr.black, [cy1 scr.yCtr], 2);
                Screen('LineStipple', wPtr, 1, 1, [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]);
                Screen('DrawLines', wPtr, allCoords,lineWidthPix, scr.black, [cy2 scr.yCtr], 2);
        end
end

tcue2           = Screen('Flip', wPtr,tcue1+CueInfo.t_wait - scr.ifi/2);

if IsLinux
    scr.b.sendTrigger(CueInfo.code); % send trigger
end

taco_drawFixation;
tcue3           = Screen('Flip', wPtr,tcue2+CueInfo.dur - scr.ifi/2);