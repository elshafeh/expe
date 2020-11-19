# header
scenario = "bike_pilot_practice";

write_codes = true; # send codes to output port

active_buttons = 2;
button_codes   = 1, 2;

default_font_size 			= 30;
default_text_color		 	= 0,0,0; # black
default_background_color 	= 128,128,128;  # grey


# SDL code
begin;

########################################
### define all the  Arrows/cues 		 ###
########################################

TEMPLATE "cue.tem" {};

######################################
### define all the required trials ###
######################################

# instruction trials, use template
TEMPLATE "trial.tem" {
name 						trlcode				content;
instruction				"instruct"			"Instruction:\nIndicate as fast as possible where to move.\nG = Go Left H = Go Right\n\nPush G button to continue.";
the_end					"end"					"The end of the practice. \nPush G button to continue.";
};

# trial: feedback correct
trial {
	picture {
		bitmap cross_correct;
		x = 0; y = 0;
		};
	duration 	= 200;
	code 			= "correct";
	port_code 	= 16;
}correct;

# trial: feedback incorrect
trial {
	picture {
		bitmap cross_incorrect;
		x = 0; y = 0;
		};
	duration 	= 200;
	code 			= "incorrect";
	port_code 	= 48;
}incorrect;

# trial: feedback no response (=incorrect)
trial {
	picture {
		bitmap cross_incorrect;
		x = 0; y = 0;
		};
	duration 	= 200;
	code 			= "noresp";
	port_code 	= 80;
}noresp;


#############################
### the actual experiment ###
#############################


###################
# block 1 	   	#
# trials: 32		#
###################

trial instruction;

# 1 block of 32 trials
TEMPLATE "bike_runtrial.tem"  randomize {          
cue_1		cue_1_code 	cue_2	cue_2_code	dis_1	dis_2	dis_3	resp; 

LOOP $i 2; # 2*16 = 32 trials

arrow_left  	11		arrow_stay			60	cross_default	cross_default	cross_default	1; # left / stay / no dist
arrow_left  	12		arrow_switch		70	cross_default	cross_default	cross_default	2; # left / switch / no dist
arrow_right  	13		arrow_stay			60	cross_default	cross_default	cross_default	2; # right / stay / no dist
arrow_right  	14		arrow_switch 		70	cross_default	cross_default	cross_default	1; # right / switch / no dist

arrow_left  	11		arrow_stay			60	cross_default	cross_default	cross_default	1; # left / stay / no dist
arrow_left  	12		arrow_switch		70	cross_default	cross_default	cross_default	2; # left / switch / no dist
arrow_right  	13		arrow_stay			60	cross_default	cross_default	cross_default	2; # right / stay / no dist
arrow_right  	14		arrow_switch 		70	cross_default	cross_default	cross_default	1; # right / switch / no dist

arrow_left  	21		arrow_stay 		 	60	arrow_switch	arrow_stay		arrow_switch 	1; # left / stay / dis typ-1
arrow_left  	22		arrow_switch 		70	arrow_switch	arrow_stay		arrow_switch 	2; # left / switch / dis typ-1
arrow_right  	23		arrow_stay 		 	60	arrow_switch	arrow_stay		arrow_switch 	2; # right / stay / dis typ-1
arrow_right  	24		arrow_switch 		70	arrow_switch	arrow_stay		arrow_switch 	1; # right / switch / dis typ-1

arrow_left  	31		arrow_stay 		 	60	arrow_stay		arrow_switch	arrow_stay 	1; # left / stay / dis typ-2
arrow_left  	32		arrow_switch 		70	arrow_stay		arrow_switch	arrow_stay 	2; # left / switch / dis typ-2
arrow_right  	33		arrow_stay 		 	60	arrow_stay		arrow_switch	arrow_stay 	2; # right / stay / dis typ-2
arrow_right  	34		arrow_switch 		70	arrow_stay		arrow_switch	arrow_stay 	1; # right / switch / dis typ-2


ENDLOOP;
};

# the end #
trial the_end;
# the end #