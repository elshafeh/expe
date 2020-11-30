function nw_b_flg            = h_chk_if_new_block(Info,ix)

if ix > 1
    if Info.TrialInfo(ix,:).nbloc ~= Info.TrialInfo(ix-1,:).nbloc
        nw_b_flg  	= 1;
    else
        nw_b_flg	= 0;
    end
else
    nw_b_flg     	= 1;
end