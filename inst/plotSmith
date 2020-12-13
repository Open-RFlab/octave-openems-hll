function h = plotSmith(s, name, freq, f_ind, varargin)
% h = plotSmith(s, name, freq, f_ind, varargin)
%
% Reworked version of plotRefl to plot other S parameters than s11 and to plot
% multiple S parameters on the same graphic.
%
% input:
%   s:         S parameter.
%   name:      S parameter name to display.
%   freq:      Frequency array.
%   f_ind:     Index array in 'freq' of the frequencies to put a marker on.
%
% variable input:
%   'precision':   - Number of decimal places (floating point precision)
%                    for the frequency (always in MHz), default is 2
%   'nogrid':      - Do not replot grid.
%                  - Not to put older plots under the grid, you should use it
%                    unless it is the first time you use plotSmith in a figure.
%
% example:
%   freq = [linspace(fstart, fstop, points), f_res];
%   sort(freq);
%   port{1} = calcPort(port{1}, Sim_Path, freq);
%   port{2} = calcPort(port{2}, Sim_Path, freq);
%   s11 = port{1}.uf.ref ./ port{1}.uf.inc;
%   s21 = port{2}.uf.ref ./ port{1}.uf.inc;
%   f_res_ind = find(freq == f_res);
%   figure;
%   plotSmith(s11, 's11', freq, f_res_ind);
%   plotSmith(s21, 's21', freq, f_res_ind, 'nogrid');
%   drawnow;
%
% See also PlotRefl
%
% openEMS matlab interface
% -----------------------
% author: Thomas Lepoix

precision = 2;
grid_arg = true;

for n=1:2:numel(varargin)
	if (strcmp(varargin{n},'precision')==1);
		precision = varargin{n+1};
	elseif (strcmp(varargin{n},'nogrid')==1);
		grid_arg = false;
	else
		warning('openEMS:plotSmith', ['unknown argument key: ''' varargin{n} '''']);
	endif
endfor

ffmt = ['%.', num2str(precision), 'f'];

if grid_arg
	axis ([-1.15, 1.15, -1.15, 1.15], 'square');
	axis off;
	hold on;

	% Horizontal axis
	plot([-1, 1], [0, 0], 'color', [0.9, 0.9, 0.9]);

	% Inner curved lines
	ReZ = [0.2; 0.5; 1; 2];
	ImZ = 1i * [1, 2, 5, 2];
	Z = ReZ .+ linspace(-ImZ, ImZ, 256);
	Gamma = (Z-1)./(Z+1);
	plot(Gamma.', 'color', [0.9, 0.9, 0.9]);

	ReZ = [0.5, 0.5, 1, 1, 2, 2, 5, 5, 10, 10];
	ImZ = 1i * [-0.2; 0.2; -0.5; 0.5; -1; 1; -2; 2; -5; 5];
	Z = linspace(0, ReZ, 256) .+ ImZ;
	Gamma = (Z-1)./(Z+1);
	plot(Gamma.', 'color', [0.9, 0.9, 0.9]);

	% Inner circles
	angle = linspace (0, 2 * pi, 256);
	ReZ = [5, 10];
	center = ReZ ./ (ReZ + 1);
	radius = 1 ./ (ReZ + 1);
	plot(radius .* cos(angle.') .+ center, radius .* sin(angle.'), 'color', [0.9, 0.9, 0.9]);

	% Outer black circle
	ReZ = [0];
	center = ReZ ./ (ReZ + 1);
	radius = 1 ./ (ReZ + 1);
	plot(radius .* cos(angle.') .+ center, radius .* sin(angle.'), 'k');

	% A trick to restore color order
	plot(0, 'visible', 'off');

	% Resistance
	ReZ = [0.2, 0.5, 1, 2, 5, 10];
	ImZ = zeros(1, length (ReZ));
	rho = (ReZ.^2 + ImZ.^2 - 1 + 2i * ImZ) ./ ((ReZ + 1).^2 + ImZ.^2);

	xoffset = [0.1, 0.1, 0.05, 0.05, 0.05, 0.075]; 
	yoffset = -0.03;

	for idx = 1:length(ReZ)
		text(real(rho(idx)) - xoffset(idx), ...
			imag(rho(idx)) - yoffset, ...
			num2str(ReZ(idx)));
	endfor

	% Reactance
	ReZ = [-0.06, -0.06, -0.06, -0.12, -0.5];
	ImZ = [0.2, 0.5, 1, 2, 5];
	rho = (ReZ.^2 + ImZ.^2 - 1 + 2i * ImZ) ./ ((ReZ + 1).^2 + ImZ.^2);

	for idx = 1:length(ImZ)
		text(real(rho(idx)), imag(rho(idx)), [num2str(ImZ(idx)), 'j']);
		text(real(rho(idx)), -imag(rho(idx)), [num2str(-ImZ(idx)), 'j']);
	endfor

	% Zero
	rho = (-0.05.^2 + 0.^2 - 1) ./ ((-0.05 + 1).^2 + 0.^2);
	text(real(rho), imag(rho), '0');
endif

% Markers
for i = 1:numel(f_ind)
	z = s(f_ind(i));
	if imag(z) >= 0
		z_str = '+';
	else
		z_str = '';
	endif
	z_str = [num2str(real(z), '%.2f'), z_str, num2str(imag(z), '%.2f'), 'j'];
	h = plot(s(f_ind(i)), ['o;', ...
		name, ' @ ', num2str(freq(f_ind(i))/1e6, ffmt), ' MHz', ...
		"\n", num2str(20*log10(abs(s(f_ind(i)))), '%.1f'), 'dB ', ...
%		num2str(s(f_ind(i)), '%.2f'), ' Ω', ...
		z_str, ...
		';'], 'linewidth', 2);
	set(gca, 'ColorOrder', circshift(get(gca, 'ColorOrder'), numel(h)));
endfor

h = plot(s);

if (nargout == 0)
	clear h;
end

end

