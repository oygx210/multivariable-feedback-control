function [ret,x0,str,ts,xts]=COLAS_LIN(t,x,u,flag);
%COLAS_LIN	is the M-file description of the SIMULINK system named COLAS_LIN.
%	The block-diagram can be displayed by typing: COLAS_LIN.
%
%	SYS=COLAS_LIN(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes COLAS_LIN to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling COLAS_LIN with a FLAG of zero:
%	[SIZES]=COLAS_LIN([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs
%		SIZES(5) number of roots (currently unsupported)
%		SIZES(6) direct feedthrough flag
%		SIZES(7) number of sample times
%
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.3)
if (0 == (nargin + nargout))
     set_param(sys,'Location',[256,57,964,421])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '100')
set_param(sys,'Min step size', '0.01')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')
set_param(sys,'AssignWideVectorLines','on');

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[85,10,105,30])

add_block('built-in/To Workspace',[sys,'/','time'])
set_param([sys,'/','time'],...
		'mat-name','t',...
		'position',[485,12,535,28])

add_block('built-in/Constant',[sys,'/','zF'])
set_param([sys,'/','zF'],...
		'orientation',1,...
		'Value','0',...
		'position',[125,65,145,85])

add_block('built-in/Constant',[sys,'/','V'])
set_param([sys,'/','V'],...
		'Value','0',...
		'position',[75,150,130,170])

add_block('built-in/Constant',[sys,'/','D'])
set_param([sys,'/','D'],...
		'Value','0',...
		'position',[75,185,130,205])

add_block('built-in/Constant',[sys,'/','B'])
set_param([sys,'/','B'],...
		'Value','0',...
		'position',[75,220,130,240])

add_block('built-in/Demux',[sys,'/','Demux'])
set_param([sys,'/','Demux'],...
		'outputs','[1,1,1,1,41]',...
		'position',[380,116,435,184])

add_block('built-in/To Workspace',[sys,'/','Comp.'])
set_param([sys,'/','Comp.'],...
		'mat-name','Comp',...
		'position',[495,237,545,253])

add_block('built-in/To Workspace',[sys,'/','y_D'])
set_param([sys,'/','y_D'],...
		'mat-name','y1',...
		'position',[495,112,545,128])

add_block('built-in/To Workspace',[sys,'/','x_B'])
set_param([sys,'/','x_B'],...
		'mat-name','y2',...
		'position',[495,142,545,158])

add_block('built-in/To Workspace',[sys,'/','M_D'])
set_param([sys,'/','M_D'],...
		'mat-name','y3',...
		'position',[495,172,545,188])

add_block('built-in/To Workspace',[sys,'/','M_B'])
set_param([sys,'/','M_B'],...
		'mat-name','y4',...
		'position',[495,202,545,218])


%     Subsystem  'Graph'.

new_system([sys,'/','Graph'])
set_param([sys,'/','Graph'],'Location',[0,59,274,252])

add_block('built-in/Inport',[sys,'/','Graph/x'])
set_param([sys,'/','Graph/x'],...
		'position',[65,55,85,75])

add_block('built-in/S-Function',[sys,'/',['Graph/S-function',13,'M-file which plots',13,'lines',13,'']])
set_param([sys,'/',['Graph/S-function',13,'M-file which plots',13,'lines',13,'']],...
		'function name','sfuny',...
		'parameters','ax, color,dt',...
		'position',[130,55,180,75])
add_line([sys,'/','Graph'],[90,65;125,65])
set_param([sys,'/','Graph'],...
		'Mask Display','plot(0,0,100,100,[90,10,10,10,90,90,10],[65,65,90,40,40,90,90],[90,78,69,54,40,31,25,10],[77,60,48,46,56,75,81,84])',...
		'Mask Type','Graph scope.')
set_param([sys,'/','Graph'],...
		'Mask Dialogue','Graph scope using MATLAB graph window.\nEnter plotting ranges and line type.|Time range:|y-min:|y-max:|Line type (rgbw-:*). Seperate each plot by ''/'':')
set_param([sys,'/','Graph'],...
		'Mask Translate','color = @4; ax = [0, @1, @2, @3]; dt = -1;')
set_param([sys,'/','Graph'],...
		'Mask Help','This block plots to the MATLAB graph window and can be used as an improved version of the Scope block. Look at the m-file sfuny.m to see how it works. This block can take scalar or vector input signal.')
set_param([sys,'/','Graph'],...
		'Mask Entries','100\/-0.01\/0.2\/''y-/g--/c-./w:/m*/ro/b+''\/')


%     Finished composite block 'Graph'.

set_param([sys,'/','Graph'],...
		'position',[550,61,580,99])

add_block('built-in/Constant',[sys,'/','qF'])
set_param([sys,'/','qF'],...
		'orientation',1,...
		'Value','0',...
		'position',[225,65,245,85])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','7',...
		'position',[220,116,260,184])

add_block('built-in/State-Space',[sys,'/',['Distillation',13,'column',13,'(linearized)']])
set_param([sys,'/',['Distillation',13,'column',13,'(linearized)']],...
		'A','A',...
		'B','B',...
		'C','C',...
		'D','D',...
		'position',[280,129,355,171])

add_block('built-in/Constant',[sys,'/','L'])
set_param([sys,'/','L'],...
		'Value','0',...
		'position',[75,110,130,130])

add_block('built-in/Constant',[sys,'/','F'])
set_param([sys,'/','F'],...
		'orientation',1,...
		'Value','0.01',...
		'position',[170,65,200,85])
add_line(sys,[135,120;215,120])
add_line(sys,[135,195;175,195;175,140;215,140])
add_line(sys,[135,230;185,230;185,150;215,150])
add_line(sys,[440,120;490,120])
add_line(sys,[440,150;460,150;460,180;490,180])
add_line(sys,[440,165;450,165;450,210;490,210])
add_line(sys,[440,180;439,180;439,245;490,245])
add_line(sys,[185,90;185,100;165,100;165,160;215,160])
add_line(sys,[135,160;145,160;145,130;215,130])
add_line(sys,[135,90;135,100;155,100;155,170;215,170])
add_line(sys,[110,20;480,20])
add_line(sys,[360,150;375,150])
add_line(sys,[440,135;475,135;475,150;490,150])
add_line(sys,[265,150;275,150])
add_line(sys,[440,120;440,80;545,80])
add_line(sys,[235,90;235,105;200,105;200,180;215,180])

drawnow

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str,ts,xts] = feval(sys);
	end
else
	drawnow % Flash up the model and execute load callback
end
