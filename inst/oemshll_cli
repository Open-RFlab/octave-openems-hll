function cli = oemshll_cli(args, name, ports_index, varargin)
%
% input:
%   args:         - Script arguments, should probably be 'argv()'.
%   name:         - Script name.
%   port_index:   - Ports numbers.
%                 - Example: [4, 5]
%
% variable input:
%   'header':            - String to print at the top of the help menu.
%   'path_simulation':   - Directory to save simulation files and dumps.
%                        - Default: './<name>_simulation'
%   'path_result':       - Directory to save result files.
%                        - Default: './<name>_results'
%
% author: Thomas Lepoix

if isnull(ports_index)
	disp('ERROR : No specified ports');
	exit;
endif

%%%% COMMAND LINE OBJECT
cli.name = name;
cli.path_result = [name, '_result'];
cli.path_simulation = [name, '_simulation'];
cli.clean = false;
cli.clean_result = false;
cli.clean_simulation = false;
cli.batch = false;
cli.gui = true;
cli.process = true;
cli.preprocess = true;
cli.postprocess = true;
cli.legend_out = false;
cli.conductingsheet = true;
cli.f = [];
cli.f_max = num2str([]);
cli.f_min = num2str([]);
cli.f_equal_s = num2str([]);
cli.f_equal_v = [];
cli.nf2ff = false;
cli.nf2ff_mode = 0;
cli.nf2ff_3d = false;
cli.nf2ff_frames = 0;
cli.nf2ff_delay = '30';
cli.nf2ff_phistep = 5;
cli.nf2ff_thetastep = 5;
cli.dump_et = false;
cli.dump_ht = false;
cli.dump_jt = false;
cli.dump_cdt = false;
cli.dump_ff3d = false;
cli.mur = false;
cli.mesh = true;
cli.highresmesh = true;
cli.metalresmesh = true;
cli.thirdsrule = true;
cli.smoothmesh = true;
cli.active_ports = ports_index(1);
cli.ports_index = ports_index;

%%%% ARGUMENTS
arg_only_preprocess = false;
arg_only_postprocess = false;
arg_no_preprocess = false;
arg_no_postprocess = false;
header = [];

i = 1;
while i <= numel(varargin)
	if strcmp(varargin{i}, 'header') == 1;
		header = varargin{i + 1};
		i = i + 1;
	elseif strcmp(varargin{i}, 'path_result') == 1;
		cli.path_result = varargin{i + 1};
		i = i + 1;
	elseif strcmp(varargin{i}, 'path_simulation') == 1;
		cli.path_simulation = varargin{i + 1};
		i = i + 1;
	else
		warning('openEMS:oemshll_cli', ['unknown argument key: ''' varargin{i} '''']);
	endif
	i = i + 1;
endwhile

i = 1;
while i <= numel(args)
	if strcmp(args{i}, '--help') || strcmp(args{i}, '-h')
		if header
			disp(header);
		endif
		disp(['Usage:  ./', program_name(), ' <options>']);
		disp(['        octave ', program_name(), ' <option>']);
		disp('');
		disp('General options:');
		disp("\t-h, --help             Display this help and exit.");
		disp("\t-c, --clean            Remove all result and simulation files.");
		disp("\t-cr, --clean-result    Remove all result files.");
		disp("\t-cs, --clean-sim       Remove all simulation files.");
		disp("\t-b, --batch            Batch mode. Do not wait a key is pressed to terminate.");
		disp(["\t--port <N>             Enable a port. 'N' is a port number. By default the port ", num2str(cli.active_ports), ' is enabled.']);
		disp("\t--no-port <N>          Disable a port. 'N' is a port number. By default all other ports are disabled.");
		disp(["\t                       Possible port numbers are : ", num2str(ports_index)]);
		disp('');
		disp('Control options:');
		disp("\t--only-preprocess      Only structure and mesh construction.");
		disp("\t--only-postprocess     Only process simulation datas to produce graphics and far field calculation.");
		disp("\t--no-preprocess        Do not execute anything before siulation.");
		disp("\t--no-postprocess       Do not execute anything after simulation.");
		disp("\t--no-gui               Do not open AppCSXCAD.");
		disp('');
		disp('Preprocessing options:');
		disp("\t--dump-et              Dump E field in time domain.");
		disp("\t--dump-ht              Dump H field in time domain.");
		disp("\t--dump-jt              Dump current in time domain.");
		disp("\t--dump-cdt             Dump current density in time domain.");
		disp("\t--no-conductingsheet   Use 3D perfect metal boxes instead of 2D conducting sheets.");
		disp("\t--no-highresmesh       No high resolution mesh for non orthogonal shapes.");
		disp("\t--no-metalresmesh      No metal resolution mesh for orthogonal shapes.");
		disp("\t--no-thirdsrule        Do not apply the thirds rule while creating the metal resolution mesh.");
		disp("\t--no-smoothmesh        Only particular mesh lines.");
		disp("\t--no-mesh              Do not mesh any shape.");
		disp("\t--mur                  Use MUR boundary condition instead of PML_8. Results and simulation time may significantly vary.");
		disp('');
		disp('Postprocessing options:');
		disp("\t--legend-out           Put legend boxes outside graphics");
		disp("\t--f <F>                Set frequency to place markers and compute far field radiations.");
		disp("\t                       Can be called multiple times. Example : '--f 3.1e09'");
		disp("\t--f-max s<A><B>        Place markers and compute far field radiations at the frequency for which the specified");
		disp("\t                       S parameter is maximal. A and B are port numbers, B must be active. Can be called multiple times.");
		disp("\t--f-min s<A><B>        Place markers and compute far field radiations at the frequency for which the specified");
		disp("\t                       S parameter is minimal. A and B are port numbers, B must be active. Can be called multiple times.");
		disp("\t--f-equal s<A><B> <F>  Place markers and compute far field radiations at the frequency for which the specified");
		disp("\t                       S parameter is equal to the specified value (in dB). Can be called multiple times.");
		disp("\t                       Example : '--f-equal s21 -3.5'.");
		disp("\t--dump-ff3d            Dump 3D far field radiation pattern.");
		disp("\t--nf2ff                Calcul far field radiation.");
		disp("\t--nf2ff-force          Force NF2FF calculation.");
		disp("\t--nf2ff-3d             Enable 3D far field representation (may be long).");
		disp("\t--nf2ff-frames <I>     Number of 3D frames to merge in a .gif. ImageMagick is required. Default (0, 1 or nothing) : use");
		disp("\t                       default or --f* args specified frequencies and no .gif generated.");
		disp("\t--nf2ff-delay          Delay between each frames (in ms). Cf. convert's '-delay' argument. Default : 30");
		disp("\t--nf2ff-phistep <I>    Set phi angle (elevation) step for 3D far field. I is in degree, default is 5.");
		disp("\t--nf2ff-thetastep <I>  Set theta angle (azimuth) step for 3D far field. I is in degree, default is 5.");
		disp("\t--nf2ff-anglestep <I>  Set phi & theta angle steps for 3D far field. I is in degree.");
		exit;
	elseif strcmp(args{i}, '--clean') || strcmp(args{i}, '-c')
		cli.clean = true;
	elseif strcmp(args{i}, '--clean-result') || strcmp(args{i}, '-cr')
		cli.clean_result = true;
	elseif strcmp(args{i}, '--clean-sim') || strcmp(args{i}, '-cs')
		cli.clean_simulation = true;
	elseif strcmp(args{i}, '--batch') || strcmp(args{i}, '-b')
		cli.batch = true;
	elseif strcmp(args{i}, '--only-preprocess')
		arg_only_preprocess = true;
		cli.process = false;
		cli.postprocess = false;
	elseif strcmp(args{i}, '--only-postprocess')
		arg_only_postprocess = true;
		cli.preprocess = false;
		cli.process = false;
	elseif strcmp(args{i}, '--no-preprocess')
		arg_no_preprocess = true;
		cli.preprocess = false;
	elseif strcmp(args{i}, '--no-gui')
		cli.gui = false;
	elseif strcmp(args{i}, '--no-postprocess')
		arg_no_postprocess = true;
		cli.postprocess = false;
	elseif strcmp(args{i}, '--f')
		cli.f = [cli.f, str2num(args{i + 1})];
		i = i + 1;
	elseif strcmp(args{i}, '--f-max')
		cli.f_max = [cli.f_max; args{i + 1}];
		i = i + 1;
	elseif strcmp(args{i}, '--f-min')
		cli.f_min = [cli.f_min; args{i + 1}];
		i = i + 1;
	elseif strcmp(args{i}, '--f-equal')
		cli.f_equal_s = [cli.f_equal_s; args{i + 1}];
		cli.f_equal_v = [cli.f_equal_v, str2num(args{i + 2})];
		i = i + 2;
	elseif strcmp(args{i}, '--legend-out')
		cli.legend_out = true;
	elseif strcmp(args{i}, '--nf2ff')
		cli.nf2ff = true;
	elseif strcmp(args{i}, '--nf2ff-force')
		cli.nf2ff_mode = 1;
	elseif strcmp(args{i}, '--nf2ff-3d')
		cli.nf2ff_3d = true;
	elseif strcmp(args{i}, '--nf2ff-frames')
		cli.nf2ff_frames = str2num(args{i + 1});
		i = i + 1;
	elseif strcmp(args{i}, '--nf2ff-delay')
		cli.nf2ff_delay = args{i + 1};
		i = i + 1;
	elseif strcmp(args{i}, '--nf2ff-phistep')
		cli.nf2ff_phistep = str2num(args{i + 1});
		i = i + 1;
	elseif strcmp(args{i}, '--nf2ff-thetastep')
		cli.nf2ff_thetastep = str2num(args{i + 1});
		i = i + 1;
	elseif strcmp(args{i}, '--nf2ff-anglestep')
		cli.nf2ff_phistep = str2num(args{i + 1});
		cli.nf2ff_thetastep = str2num(args{i + 1});
		i = i + 1;
	elseif strcmp(args{i}, '--dump-et')
		cli.dump_et = true;
	elseif strcmp(args{i}, '--dump-ht')
		cli.dump_ht = true;
	elseif strcmp(args{i}, '--dump-jt')
		cli.dump_jt = true;
	elseif strcmp(args{i}, '--dump-cdt')
		cli.dump_cdt = true;
	elseif strcmp(args{i}, '--dump-ff3d')
		cli.dump_ff3d = true;
	elseif strcmp(args{i}, '--mur')
		cli.mur = true;
	elseif strcmp(args{i}, '--no-conductingsheet')
		cli.conductingsheet = false;
	elseif strcmp(args{i}, '--no-mesh')
		cli.mesh = false;
	elseif strcmp(args{i}, '--no-highresmesh')
		cli.highresmesh = false;
	elseif strcmp(args{i}, '--no-metalresmesh')
		cli.metalresmesh = false;
	elseif strcmp(args{i}, '--no-thirdsrule')
		cli.thirdsrule = false;
	elseif strcmp(args{i}, '--no-smoothmesh')
		cli.smoothmesh = false;
	elseif strcmp(args{i}, '--port')
		if find(ports_index == str2num(args{i + 1}))
			cli.active_ports = [active_ports, str2num(args{i + 1})];
		else
			disp(['ERROR : --port : invalid port : ', args{i + 1}]);
			exit;
		endif
		i = i + 1;
	elseif strcmp(args{i}, '--no-port')
		if find(ports_index == str2num(args{i + 1}))
			cli.active_ports(:, find(active_ports == str2num(args{i + 1}))) = [];
		else
			disp(['ERROR : --no-port : invalid port : ', args{i + 1}]);
			exit;
		endif
		i = i + 1;
	else
		disp(['ERROR : Unknown argument : ', args{i}]);
		exit;
	endif
	i = i + 1;
endwhile

if arg_only_preprocess && arg_only_postprocess
	disp('ERROR : --only-preprocess and --only-postprocess are not compatible.');
	exit;
endif
if arg_only_preprocess && arg_no_preprocess
	disp('ERROR : --only-preprocess and --no-preprocess are not compatible.');
	exit;
endif
if arg_only_postprocess && arg_no_postprocess
	disp('ERROR : --only-postprocess and --no-postprocess are not compatible.');
	exit;
endif
if cli.mesh == false && arg_only_preprocess == false
	disp('ERROR : --no-mesh only works with --only-preprocess.');
	exit;
endif
if cli.smoothmesh == false && arg_only_preprocess == false
	disp('ERROR : --no-smoothmesh only works with --only-preprocess.');
	exit;
endif
if exist('cli.f_max', 'var')
	for i = 1:rows(cli.f_max)
		if exist('cli.f_max', 'var') && numel(cli.f_max(i, :)) == 3 && cli.f_max(i, 1) == 's' ...
		&& exist(['cli.active_port', cli.f_max(i, 2)]) ...
		&& exist(['cli.active_port', cli.f_max(i, 3)])
			if eval(['cli.active_port', cli.f_max(i, 3)]) == false
				disp(['ERROR : --f-max ', cli.f_max(i, :), ' : port ', cli.f_max(i, 3), ' is not an active port.']);
				exit;
			endif
		else
			disp(['ERROR : --f-max ', cli.f_max(i, :), ' : incorrect argument.']);
			exit;
		endif
	endfor
endif
if exist('cli.f_min', 'var')
	for i = 1:rows(cli.f_min)
		if numel(cli.f_min(i, :)) == 3 && cli.f_min(i, 1) == 's' ...
		&& exist(['cli.active_port', cli.f_min(i, 2)]) ...
		&& exist(['cli.active_port', cli.f_min(i, 3)])
			if eval(['cli.active_port', cli.f_min(i, 3)]) == false
				disp(['ERROR : --f-min ', cli.f_min(i, :), ' : port ', cli.f_min(i, 3), ' is not an active port.']);
				exit;
			endif
		else
			disp(['ERROR : --f-min ', cli.f_min(i, :), ' : incorrect argument.']);
			exit;
		endif
	endfor
endif
if exist('cli.f_equal_s', 'var')
	for i = 1:rows(cli.f_equal_s)
		if numel(cli.f_equal_s(i, :)) == 3 && cli.f_equal_s(i, 1) == 's' ...
		&& exist(['cli.active_port', cli.f_equal_s(i, 2)]) ...
		&& exist(['cli.active_port', cli.f_equal_s(i, 3)])
			if eval(['cli.active_port', cli.f_equal_s(i, 3)]) == false
				disp(['ERROR : --f-min ', cli.f_equal_s(i, :), ' : port ', cli.f_equal_s(i, 3), ' is not an active port.']);
				exit;
			endif
		else
			disp(['ERROR : --f-min ', cli.f_equal_s(i, :), ' : incorrect argument.']);
			exit;
		endif
	endfor
endif

if cli.clean
	[status, message, messageid] = rmdir(cli.path_result, 's');
	[status, message, messageid] = rmdir(cli.path_simulation, 's');
	exit;
endif
if cli.clean_result
	[status, message, messageid] = rmdir(cli.path_result, 's');
	exit;
endif
if cli.clean_simulation
	[status, message, messageid] = rmdir(cli.path_simulation, 's');
	exit;
endif
if cli.preprocess && cli.process && cli.postprocess
	[status, message, messageid] = rmdir(cli.path_result, 's');
	[status, message, messageid] = rmdir(cli.path_simulation, 's');
elseif cli.process
	[status, message, messageid] = rmdir(cli.path_simulation, 's');
endif
[status, message, messageid] = mkdir(cli.path_result);
[status, message, messageid] = mkdir(cli.path_simulation);

end

