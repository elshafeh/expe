function spatialfilter     = h_ramaComputeFilter(avg,leadfield,vol)

cfg                         =   [];

if length(avg.label) < 200
    cfg.channel             = 1:54;
    cfg.elec                = vol.elec;
    vol                     = rmfield(vol,'elec');
end

cfg.method                  =   'lcmv';
cfg.grid                    =   leadfield;
cfg.headmodel               =   vol;
cfg.lcmv.keepfilter         =   'yes';
cfg.lcmv.fixedori           =   'yes';
cfg.lcmv.projectnoise       =   'yes';
cfg.lcmv.keepmom            =   'yes';
cfg.lcmv.projectmom         =   'yes';
cfg.lcmv.lambda             =   '5%' ;

source                      =   ft_sourceanalysis(cfg, avg); clear avg ;
spatialfilter               =   cat(1,source.avg.filter{:});  clear source cfg