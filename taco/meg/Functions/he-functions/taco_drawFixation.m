function taco_drawFixation

global scr wPtr stim

taco_darkenBackground;
stim.Fix.color          = repmat(scr.gray/2, [1,3]);
JY_VisExptTools('draw_fixation', stim.Fix);