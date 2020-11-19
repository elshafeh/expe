# header
scenario = "bike_pilot_block";

write_codes = true; # send codes to output port

active_buttons = 2;
button_codes   = 1, 2;

default_font_size 			= 30;
default_text_color		 	= 0,0,0; # white
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
the_end					"end"					"The end of the experiment. \nPush G button to continue.";
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
# trials: 208		#
###################

trial instruction;

TEMPLATE "bike_runtrial_four.tem"  randomize {          
cue_1		cue_1_code 	cue_2	cue_2_code	dis_1	dis_1_code	dis_2	dis_2_code	dis_3	dis_3_code	dis_4 dis_4_code	resp; 

LOOP $i 1; #

arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	2;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	cross_default	"cross_default"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	2;
arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	2;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	arrow_stay	"arrow_stay"	arrow_left	"arrow_left"	arrow_left	"arrow_left"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_switch	"arrow_switch"	1;
arrow_right	"arrow_right"	arrow_switch	"arrow_switch"	arrow_right	"arrow_right"	arrow_left	"arrow_left"	arrow_stay	"arrow_stay"	arrow_stay	"arrow_stay"	1;

ENDLOOP;
};

# the end #
trial the_end;
# the end #