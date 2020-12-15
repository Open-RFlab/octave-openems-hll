function h = plotFF3D_frames(nf2ff, prefix, varargin)
% h = plotFF3D_frames(nf2ff, varargin)
%
% This is an enhanced version of plotFF3D to plot 3D far field pattern for
% multiple frequencies. It will plot a frame for each frequency present in
% nf2ff. It can also produce an animated gif.
% For now, supports only V/m output.
%
% input:
%   nf2ff:                 - Output of CalcNF2FF
%   prefix:                - Frame name: '<prefix>@<f>.<format>'.
%                          - Gif name: '<prefix>.<format>'.
%
% variable input:
%   'unique_color_scale':  - Use an unique color scale for all frames.
%   'unique_axis_scale':   - Use an unique axis scale for all frames.
%   'unique_xyz_scale':    - Use an unique scale for x, y, z axis on each frame.
%   'gif' <bool>:          - Merge all frames in an animated gif.
%                          - Use ImageMagick's 'convert' command.
%                          - Default: false.
%   'delay' <str>:         - Delay between frames in the gif.
%                          - Cf. convert '-delay' argument.
%                          - Default: '30'.
%   'colormap' <str>:      - Set a colormap for the plots.
%                          - Default: 'jet'.
%   'show_each' <bool>:    - Show each frame in its figure window.
%                          - Default: false.
%   'print' <bool>:        - Do not save frames/gif on disk.
%                          - Default: true.
%   'format' <str>:        - Frame format.
%                          - You probably must not override it.
%                          - Default: 'png'.
%
% example:
%   plotFF3D_frames(nf2ff, [name, '-ff3d-vm'], 'gif', true, ...
%       'unique_color_scale', 'unique_axis_scale');
%
% See also plotFF3D
%
% openEMS matlab interface
% -----------------------
% author: Thomas Lepoix

flag_vm = true;

unique_color_scale = false;
unique_axis_scale = false;
unique_xyz_scale = false;
gif = false;
delay = '30';
colormap_arg = 'jet';
show_each = false;
print_arg = true;
format_arg = 'png';

n = 1;
while n <= numel(varargin)
	if (strcmp(varargin{n}, 'unique_color_scale') == 1);
		unique_color_scale = true;
	elseif (strcmp(varargin{n}, 'unique_axis_scale') == 1);
		unique_axis_scale = true;
	elseif (strcmp(varargin{n}, 'unique_xyz_scale') == 1);
		unique_xyz_scale = true;
	elseif (strcmp(varargin{n}, 'gif') == 1);
		gif = varargin{n + 1};
		n = n + 1;
	elseif (strcmp(varargin{n}, 'delay') == 1);
		delay = varargin{n+1};
		n = n + 1;
	elseif (strcmp(varargin{n}, 'colormap') == 1);
		colormap_arg = varargin{n+1};
		n = n + 1;
	elseif (strcmp(varargin{n}, 'show_each') == 1);
		show_each = varargin{n + 1};
		n = n + 1;
	elseif (strcmp(varargin{n}, 'print') == 1);
		print_arg = varargin{n + 1};
		n = n + 1;
	elseif (strcmp(varargin{n}, 'format') == 1);
		format_arg = varargin{n+1};
		n = n + 1;
	else
		warning('openEMS:plotFF3D_frames', ['unknown argument key: ''' varargin{n} '''']);
	endif
	n = n + 1;
endwhile

for n = 1:numel(nf2ff.freq)
	if flag_vm
		E_far{n} = nf2ff.E_norm{n};
	endif

	[theta, phi] = ndgrid(nf2ff.theta, nf2ff.phi);
	x{n} = E_far{n} .* sin(theta) .* cos(phi);
	y{n} = E_far{n} .* sin(theta) .* sin(phi);
	z{n} = E_far{n} .* cos(theta);

	if n == 1
		E_far_min = min(E_far{n}(:));
		E_far_max = max(E_far{n}(:));
		E_far_max_x = max(abs(x{n}(:)));
		E_far_max_y = max(abs(y{n}(:)));
		E_far_max_z = max(abs(z{n}(:)));
	else
		if min(E_far{n}(:)) < E_far_min
			E_far_min = min(E_far{n}(:));
		endif
		if max(E_far{n}(:)) > E_far_max
			E_far_max = max(E_far{n}(:));
		endif
		if max(abs(x{n}(:))) > E_far_max_x
			E_far_max_x = max(abs(x{n}(:)));
		endif
		if max(abs(y{n}(:))) > E_far_max_y
			E_far_max_y = max(abs(y{n}(:)));
		endif
		if max(abs(z{n}(:))) > E_far_max_z
			E_far_max_z = max(abs(z{n}(:)));
		endif
	endif

	fstop_digit_number = numel(num2str(nf2ff.freq(n)));
endfor

if show_each == false
	figure;
endif
for n = 1:numel(nf2ff.freq)
	if show_each
		figure;
	endif
	colormap(colormap_arg);

	h = surf(x{n}, y{n}, z{n}, E_far{n});
	set(h, 'EdgeColor', 'none');
	axis equal;
	axis off;

	if flag_vm
		titletext = sprintf('Electrical far field [V/m] @ f = %e Hz', nf2ff.freq(n));
	endif
	title(titletext);

	if unique_color_scale
		cb = colorbar('YTick', linspace(E_far_min, E_far_max, 9));
		caxis([0, E_far_max]);
	else
		cb = colorbar('YTick', linspace(min(E_far{n}(:)), max(E_far{n}(:)), 9));
	endif
	set(cb, 'Position', [0.75, 0.2, 0.05, 0.6]);

	if unique_axis_scale && unique_xyz_scale
		xlim([-E_far_max, E_far_max]);
		ylim([-E_far_max, E_far_max]);
		zlim([-E_far_max, E_far_max]);
	elseif unique_axis_scale
		xlim([-E_far_max_x, E_far_max_x]);
		ylim([-E_far_max_y, E_far_max_y]);
		zlim([-E_far_max_z, E_far_max_z]);
	elseif unique_xyz_scale
		limit = max([xlim, ylim, zlim]);
		xlim([-limit, limit]);
		ylim([-limit, limit]);
		zlim([-limit, limit]);
	endif

	drawnow;
	if print_arg
		print([prefix, '@', ...
			num2str(nf2ff.freq(n), ['%0', num2str(fstop_digit_number), '.0f']), ...
			'.', format_arg]);
	endif
endfor

if print_arg && gif
	system(['convert -delay ', delay, ' -loop 0 ', ...
		prefix, '@*.', format_arg, ' ', ...
		prefix, '.gif']);
endif

end

