function oemshll_postProcess(name, path_simulation, path_result, port, port_index, active_ports, fstart, fstop, points, varargin)
%
% input:
%   name:            - Simulation name.
%   path_simulation: - Simulation directory path.
%   path_result:     - Result directory path.
%   port:            - Ports data structure.
%                    - See 'calcPort' function.
%   port_index:      - Ports numbers.
%                    - Example: [1, 2]
%   active_ports:    - Active ports numbers.
%                    - Example: [1]
%   fstart:          - Start frequency.
%   fstop:           - Stop frequency.
%   points:          - Number of points on graphs.
%
% variable input:
%   'legend_out':         - Put the legend boxe outside the graph.
%                         - Default: false.
%   'graphics_format':    - Format to save graphics.
%                         - See 'print' function.
%                         - Default: '.svg'
%   'nf2ff':              - Enable NF2FF calculation.
%                         - Default: false
%   'nf2ff_data':         - NF2FF data structure.
%                         - See 'CreateNF2FFBox' and 'CalcNF2FF' functions.
%   'nf2ff_mode':         - Set 'CalcNF2FF' 'Mode' argument.
%                         - 0: Read existing datas, calcul NF2FF if no existing datas.
%                         - 1: Calcul NF2FF, overwrite existing datas.
%                         - 2: Do not calcul NF2FF, read existing datas.
%                         - Default: 0
%   'nf2ff_3d':           - Enable 3D far field representation.
%                         - Default: false.
%   'nf2ff_3d_phistep':   - NF2FF 3D Phi angle (elevation) step.
%                         - Default: 5
%   'nf2ff_3d_theta':     - NF2FF 3D Theta angle (azimuth) step.
%                         - Default: 5
%   'nf2ff_3d_frames':    - Create an animated '.gif' of the 3D radiation pattern.
%                         - 1: No '.gif', print a 3D pattern for each marked frequency.
%                         - >1: Number of frames between 'fstart' and 'fstop'.
%                         - Requires ImageMagick.
%                         - See 'plotFF3D_frames' function.
%                         - Default: 1
%   'nf2ff_3d_delay':     - Delay between each '.gif' frame, in ms.
%                         - See 'convert' '-delay' argument.
%                         - Default: 30
%   'nf2ff_3d_dump':      - Dump 3D radiation pattern to visualize with Paraview.
%                         - Default: false
%   'nf2ff_3d_dump_unit': - Dump size unit factor.
%                         - See 'DumpFF2VTK' function.
%                         - Default: 1
%   'f_select':           - Place markers on selected frequencies.
%                         - Without any selected frequency, a marker is placed
%                           at the middle of the frequency range.
%   'f_min':              - Place markers at some curve minimums.
%                         - Example: ['s11', 's21']
%   'f_max':              - Place markers at some curve maximums.
%                         - Example: ['s11', 's21']
%   'f_equal':            - Place markers at some curve nearest points to some value.
%                         - Example: ['s11', 's21'] [-3.5, -20]
%
% author: Thomas Lepoix

	legend_out = false;
	graphics_format = '.svg';
	flag_nf2ff = false;
	nf2ff_mode = 1;
	nf2ff_3d = false;
	nf2ff_3d_phistep = 5;
	nf2ff_3d_thetastep = 5;
	nf2ff_3d_frames = 1;
	nf2ff_3d_delay = 30;
	nf2ff_3d_dump = false;
	nf2ff_3d_dump_unit = 1;
	flag_f = [];
	f_max = num2str([]);
	f_min = num2str([]);
	f_equal_s = num2str([]);
	f_equal_v = [];

	i = 1;
	while i <= numel(varargin)
		if (strcmp(varargin{i}, 'legend_out')==1);
			legend_out = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'graphics_format')==1);
			graphics_format = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff')==1);
			flag_nf2ff = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_data')==1);
			nf2ff = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_mode')==1);
			nf2ff_mode = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_3d')==1);
			nf2ff_3d = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_3d_phistep')==1);
			nf2ff_3d_phistep = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_3d_thetastep')==1);
			nf2ff_3d_thetastep = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_3d_frames')==1);
			nf2ff_3d_frames = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_3d_delay')==1);
			nf2ff_3d_delay = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_3d_dump')==1);
			nf2ff_3d_dump = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'nf2ff_3d_dump_unit')==1);
			nf2ff_3d_dump_unit = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'f_select')==1);
			flag_f = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'f_min')==1);
			f_min = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'f_max')==1);
			f_max = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'f_equal')==1);
			f_equal_s = varargin{i+1};
			f_equal_v = varargin{i+2};
			i = i + 2;
		else
			warning('openEMS:oemshll_postProcess', ['unknown argument key: ''' varargin{i} '''']);
		endif
		i = i + 1;
	endwhile

%%%% VARIABLES
color_order = [ ...
	[1, 0, 1]; ... % m
	[0, 1, 0]; ... % g
	[0, 1, 1]; ... % c
	[1, 1, 0]; ... % y
	[1, 0, 0]; ... % r
	[0, 0, 1]; ... % b
	[0, 0, 0]];    % k
color_order_letter = [ ...
	'm', ...
	'g', ...
	'c', ...
	'y', ...
	'r', ...
	'b', ...
	'k'];
port_suffix = '-p';
frequency_format = ['%0', num2str(numel(num2str(fstop))), '.0f'];
funit = 1e+3;
funit_name = 'kHz';
if fstop >= 1e+9 && fstart >= 1e+9
	funit = 1e+9;
	funit_name = 'GHz';
elseif fstop >= 1e+6 && fstart >= 1e+6
	funit = 1e+6;
	funit_name = 'MHz';
endif
freq = linspace(fstart, fstop, points);
if !isempty(flag_f)
	f_select = flag_f;
	freq = [freq, f_select];
	freq = sort(unique(freq));
	points = numel(freq);
elseif !isempty(f_max) || !isempty(f_min) || (!isempty(f_equal_s) && !isempty(f_equal_v))
	f_select = [];
else
	f_select = [freq(round(points / 2))];
endif

% calcPort
for i = 1:numel(port_index)
	port{port_index(i)} = calcPort(port{port_index(i)}, path_simulation, freq);
endfor

% S parameters
for i = 1:numel(active_ports)
	port_suffix = [port_suffix, num2str(active_ports(i))];
	for j = 1:numel(port_index)
		s{port_index(j), active_ports(i)} = port{port_index(j)}.uf.ref ./ port{active_ports(i)}.uf.inc;
	endfor
endfor

if !isempty(f_max)
	for i = 1:rows(f_max)
		f_max_str = [f_max(i, 1), '{', f_max(i, 2), ', ', f_max(i, 3), '}'];
		f_select = [f_select, freq(find(eval(f_max_str) == max(eval(f_max_str))))];
	endfor
endif
if !isempty(f_min)
	for i = 1:rows(f_min)
		f_min_str = [f_min(i, 1), '{', f_min(i, 2), ', ', f_min(i, 3), '}'];
		f_select = [f_select, freq(find(eval(f_min_str) == min(eval(f_min_str))))];
	endfor
endif
if !isempty(f_equal_s) && !isempty(f_equal_v)
	for i = 1:rows(f_equal_s)
		f_equal_s_str = [f_equal_s(i, 1), '{', f_equal_s(i, 2), ', ', f_equal_s(i, 3), '}'];
		f_select = [f_select, freq(find( ...
			abs(20*log10(abs(eval(f_equal_s_str))) .- f_equal_v(i)) ...
			== min(abs(20*log10(abs(eval(f_equal_s_str))) .- f_equal_v(i))) ))];
	endfor
endif

%%%% SAVE TOUCHSTONE
spara = [];
for i = 1:numel(port_index)
	is_active = false;
	for j = 1:numel(active_ports)
		if port_index(i) == active_ports(j)
			is_active = true;
		endif
	endfor
	if is_active
		for j = 1:numel(port_index)
			spara(port_index(j), port_index(i), :) = s{port_index(j), port_index(i)};
		endfor
	else
		for j = 1:numel(port_index)
			spara(port_index(j), port_index(i), :) = repmat([0], 1, points);
		endfor
	endif
endfor
write_touchstone('s', freq, spara, [path_result, '/', name, port_suffix, '.s2p']);
% Append header to touchstone file
fd = fopen([path_result, '/', name, port_suffix, '.s2p'], 'r');
tmp = fread(fd);
fclose(fd);
fd = fopen([path_result, '/', name, port_suffix, '.s2p'], 'wt');
header = ["! Generated by a Qucs-RFlayout generated OpenEMS script\n"];
fprintf(fd, '%s%s', header, tmp);
fclose(fd);

%%%% PLOT S PARAMETERS
spara = {};
names = {};
colors = {};
color_i = 1;
for i = 1:numel(active_ports)
	for j = 1:numel(port_index)
		spara = {spara{:}, s{port_index(j), active_ports(i)}};
		names = {names{:}, ['s', num2str(port_index(j)), num2str(active_ports(i))]};
		colors = {colors{:}, color_order_letter(color_i)};
		color_i = color_i + 1;
	endfor
endfor
figure;
oemshll_plotSParameters(spara, names, freq, f_select, colors, ...
	'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
drawnow;
print([path_result, '/', name, '-s', graphics_format]);

%%%% PLOT SMITH CHART
spara = {};
names = {};
color_order_smith = [];
color_i = 1;
for i = 1:numel(active_ports)
	for j = 1:numel(port_index)
		spara = {spara{:}, s{port_index(j), active_ports(i)}};
		names = {names{:}, ['s', num2str(port_index(j)), num2str(active_ports(i))]};
		color_order_smith = [color_order_smith(:,:); [color_order(color_i, :)]];
		color_i = color_i + 1;
	endfor
endfor
figure;
oemshll_plotSmithChart(spara, names, freq, f_select, color_order_smith, ...
	'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
drawnow;
print([path_result, '/', name, '-smith', graphics_format]);

%%%% PLOT UNWRAPPED PHASE RESPONSE
spara = {};
names = {};
colors = {};
color_i = 1;
if numel(port_index) > 1
	for i = 1:numel(active_ports)
		for j = 1:numel(port_index)
			if i == j
				continue;
			endif
			spara = {spara{:}, s{port_index(j), active_ports(i)}};
			names = {names{:}, ['φ', num2str(port_index(j)), num2str(active_ports(i))]};
			colors = {colors{:}, color_order_letter(color_i)};
			color_i = color_i + 1;
		endfor
	endfor
	figure;
	oemshll_plotPhaseResponse(spara, names, freq, f_select, colors, ...
		'wrap', false, ...
		'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
	drawnow;
	print([path_result, '/', name, '-phase-response-unwrapped', graphics_format]);
endif

%%%% PLOT WRAPPED PHASE RESPONSE
spara = {};
names = {};
colors = {};
color_i = 1;
if numel(port_index) > 1
	for i = 1:numel(active_ports)
		for j = 1:numel(port_index)
			if i == j
				continue;
			endif
			spara = {spara{:}, s{port_index(j), active_ports(i)}};
			names = {names{:}, ['φ', num2str(port_index(j)), num2str(active_ports(i))]};
			colors = {colors{:}, color_order_letter(color_i)};
			color_i = color_i + 1;
		endfor
	endfor
	figure;
	oemshll_plotPhaseResponse(spara, names, freq, f_select, colors, ...
		'wrap', true, ...
		'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
	drawnow;
	print([path_result, '/', name, '-phase-response-wrapped', graphics_format]);
endif

%%%% PLOT PHASE DELAY
spara = {};
names = {};
colors = {};
color_i = 1;
if numel(port_index) > 1
	for i = 1:numel(active_ports)
		for j = 1:numel(port_index)
			if i == j
				continue;
			endif
			spara = {spara{:}, s{port_index(j), active_ports(i)}};
			names = {names{:}, ['PD', num2str(port_index(j)), num2str(active_ports(i))]};
			colors = {colors{:}, color_order_letter(color_i)};
			color_i = color_i + 1;
		endfor
	endfor
	figure;
	oemshll_plotPhaseDelay(spara, names, freq, f_select, colors, ...
		'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
	drawnow;
	print([path_result, '/', name, '-phase-delay', graphics_format]);
endif

%%%% PLOT GROUP DELAY
spara = {};
names = {};
colors = {};
color_i = 1;
if numel(port_index) > 1
	for i = 1:numel(active_ports)
		for j = 1:numel(port_index)
			if i == j
				continue;
			endif
			spara = {spara{:}, s{port_index(j), active_ports(i)}};
			names = {names{:}, ['GD', num2str(port_index(j)), num2str(active_ports(i))]};
			colors = {colors{:}, color_order_letter(color_i)};
			color_i = color_i + 1;
		endfor
	endfor
	figure;
	oemshll_plotGroupDelay(spara, names, freq, f_select, colors, ...
		'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
	drawnow;
	print([path_result, '/', name, '-group-delay', graphics_format]);
endif

%%%% PLOT PORT IMPEDANCES
for i = 1:numel(active_ports)
	z = port{active_ports(i)}.uf.tot./port{active_ports(i)}.if.tot;
	figure;
	oemshll_plotFeedImpedance(z, num2str(active_ports(i)), freq, f_select, 'k', 'm', 'g', ...
		'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
	drawnow;
	print([path_result, '/', name, '-z', num2str(active_ports(i)), graphics_format]);
endfor

%%%% PLOT PORT VSWR
for i = 1:numel(active_ports)
	figure;
	oemshll_plotVSWR(s{active_ports(i), active_ports(i)}, num2str(active_ports(i)), freq, f_select, color_order_letter(i), ...
		'legend_out', legend_out, 'funit', funit, 'funit_name', funit_name);
	drawnow;
	print([path_result, '/', name, '-vswr', num2str(active_ports(i)), graphics_format]);
endfor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NF2FF

if flag_nf2ff

%%%% ELEVATION
% A trick to use only needed colors as 'polarFF()' interfer with color order
color_order_polar = [ ...
	color_order(1, :); ...
	color_order(2, :)];
nf2ff_elev = CalcNF2FF(nf2ff, path_simulation, f_select, ...
	[-180:2:180]*pi/180, [0, 90]*pi/180, ...
	'Center', nf2ff.center, ...
	'Verbose', 1, 'Mode', nf2ff_mode, 'Outfile', 'nf2ff_theta.h5');

% Polar dB normalized
for i = 1:numel(f_select)
	figure;
	set(gca, 'ColorOrder', color_order_polar, 'NextPlot', 'replacechildren');
	h = polarFF(nf2ff_elev, 'freq_index', i, 'xaxis', 'theta', 'param', [1, 2], 'normalize', 1, 'xtics', 10);
	set(h, 'Linewidth', 2);
	drawnow;
	print([path_result, '/', name, '-ff-elev-polar-dbn@', ...
		num2str(f_select(i), frequency_format), ...
		graphics_format]);
endfor

% Polar dBi
for i = 1:numel(f_select)
	figure;
	set(gca, 'ColorOrder', color_order_polar, 'NextPlot', 'replacechildren');
	h = polarFF(nf2ff_elev, 'freq_index', i, 'xaxis', 'theta', 'param', [1, 2], 'logscale', [-20, 10], 'xtics', 10);
	set(h, 'Linewidth', 2);
	drawnow;
	print([path_result, '/', name, '-ff-elev-polar-dbi@', ...
		num2str(f_select(i), frequency_format), ...
		graphics_format]);
endfor

% Rect dBi
for i = 1:numel(f_select)
	figure;
	set(gca, 'ColorOrder', color_order, 'NextPlot', 'replacechildren');
	h = plotFFdB(nf2ff_elev, 'freq_index', i, 'xaxis', 'theta', 'param', [1, 2]);
	set(h, 'Linewidth', 2);
	if legend_out
		legend('Location', 'northeastoutside');
	endif
	drawnow;
	print([path_result, '/', name, '-ff-elev-rect-dbi@', ...
		num2str(f_select(i), frequency_format), ...
		graphics_format]);
endfor

%%%% AZIMUTH
% A trick to use only needed colors as 'polarFF()' interfer with color order
color_order_polar = [ ...
	color_order(3, :); ...
	color_order(1, :); ...
	color_order(2, :)];
nf2ff_azim = CalcNF2FF(nf2ff, path_simulation, f_select, ...
	[30, 60, 90]*pi/180, [-180:2:180]*pi/180, ...
	'Center', nf2ff.center, ...
	'Verbose', 1, 'Mode', nf2ff_mode, 'Outfile', 'nf2ff_phi.h5');

% Polar dB normalized
for i = 1:numel(f_select)
	figure;
	set(gca, 'ColorOrder', color_order_polar, 'NextPlot', 'replacechildren');
	h = polarFF(nf2ff_azim, 'freq_index', i, 'xaxis', 'phi', 'param', [1, 2, 3], 'normalize', 1, 'xtics', 10);
	set(h, 'Linewidth', 2);
	drawnow;
	print([path_result, '/', name, '-ff-azim-polar-dbn@', ...
		num2str(f_select(i), frequency_format), ...
		graphics_format]);
endfor

% Polar dBi
for i = 1:numel(f_select)
	figure;
	set(gca, 'ColorOrder', color_order_polar, 'NextPlot', 'replacechildren');
	h = polarFF(nf2ff_azim, 'freq_index', i, 'xaxis', 'phi', 'param', [1, 2, 3], 'logscale', [-20, 10], 'xtics', 10);
	set(h, 'Linewidth', 2);
	drawnow;
	print([path_result, '/', name, '-ff-azim-polar-dbi@', ...
		num2str(f_select(i), frequency_format), ...
		graphics_format]);
endfor

% Rect dBi
for i = 1:numel(f_select)
	figure;
	set(gca, 'ColorOrder', color_order, 'NextPlot', 'replacechildren');
	h = plotFFdB(nf2ff_azim, 'freq_index', i, 'xaxis', 'phi', 'param', [1, 2, 3]);
	set(h, 'Linewidth', 2);
	if legend_out
		legend('Location', 'northeastoutside');
	endif
	drawnow;
	print([path_result, '/', name, '-ff-azim-rect-dbi@', ...
		num2str(f_select(i), frequency_format), ...
		graphics_format]);
endfor

%%%% 3D
if nf2ff_3d
phi_range = [-180:nf2ff_3d_phistep:180];
theta_range = [0:nf2ff_3d_thetastep:180];
if nf2ff_3d_frames > 1
	freqs = [fstart:(fstop-fstart) / (nf2ff_3d_frames-1):fstop];
	gif = true;
	show_each = false;
else
	freqs = f_select;
	gif = false;
	show_each = true;
endif
nf2ff_3d = CalcNF2FF(nf2ff, path_simulation, freqs, theta_range*pi/180, phi_range*pi/180, ...
	'Center', nf2ff.center, ...
	'Verbose', 1, 'Mode', nf2ff_mode, 'Outfile', 'nf2ff_3d.h5');

% V/m
plotFF3D_frames(nf2ff_3d, [path_result, '/', name, '-ff-3d-vm'], ...
	'gif', gif, 'show_each', show_each, 'delay', nf2ff_3d_delay, ...
	'unique_color_scale', 'unique_axis_scale');

% Dump
if nf2ff_3d_dump
	E_far_normalized = nf2ff_3d.E_norm{1} / max(nf2ff_3d.E_norm{1}(:)) * nf2ff_3d.Dmax(1);
	DumpFF2VTK([path_simulation '/ff.vtk'], E_far_normalized, theta_range, phi_range, 'scale', nf2ff_3d_dump_unit * 10);
endif

endif % nf2ff_3d
endif % flag_nf2ff

end

