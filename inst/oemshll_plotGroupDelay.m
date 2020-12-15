function h = oemshll_plotGroupDelay(s, names, freq, markers, colors, varargin)
%
% input:
%   s:              - S parameters cell array, should not be a reflection coefficient (Sxy, no Sxx).
%                   - See example.
%   names:          - S parameters name strings cell array.
%   freq:           - Frequency array.
%   markers:        - Frequency array. Put a marker on each frequency inside.
%   colors:         - Color letters cell array.
%                   - See the 'fmt' argument of the Octave 'plot' function.
%
% variable input:
%   'legend_out':   - Put the legend boxe outside the graph.
%                   - Default: false.
%   'funit':        - Frequency unity factor.
%                   - To use with 'funit_name'.
%                   - Default: 1e6
%   'funit_name':   - Frequency unity name.
%                   - To use with 'funit'.
%                   - Default: 'MHz'
%
% example:
%   figure;
%   oemshll_plotGroupDelay({s21, s31}, {'s21', 's31'}, freq, markers, {'m', 'g'});
%   drawnow;
%
% author: Thomas Lepoix

	legend_out = false;
	funit = 1e6;
	funit_name = 'MHz';

	i = 1;
	while i <= numel(varargin)
		if (strcmp(varargin{i}, 'legend_out')==1);
			legend_out = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'funit')==1);
			funit = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'funit_name')==1);
			funit_name = varargin{i+1};
			i = i + 1;
		else
			warning('openEMS:oemshll_plotGroupDelay', ['unknown argument key: ''' varargin{i} '''']);
		endif
		i = i + 1;
	endwhile

	if numel(s) != numel(names) || numel(s) != numel(colors)
		warning('openEMS:oemshll_plotGroupDelay', 'mismatch beteen s, names and colors parameters cell number');
	endif

	hold on;
	grid on;
	for i = 1:numel(s)
		phi = unwrap(angle(s{i}));
		k = numel(phi);
		group_delay(1) = (-1/(2*pi)) * (((phi(2) - phi(1))/(freq(2) - freq(1))));
		group_delay(k) = (-1/(2*pi)) * (((phi(k) - phi(k - 1))/(freq(k) - freq(k - 1))));
		for n = 2:k-1
			group_delay(n) = (-1/(4*pi)) * (((phi(n) - phi(n - 1)) / (freq(n) - freq(n - 1))) ...
				+ ((phi(n + 1) - phi(n)) / (freq(n + 1) - freq(n))));
		endfor
		plot(freq/funit, group_delay, [colors{i}, '-'], 'Linewidth', 2);
		for j = 1:numel(markers)
			plot(freq(find(freq == markers(j)))/funit, ...
				group_delay(find(freq == markers(j))), ...
				[colors{i}, 'o;', names{i}, ' @ ', num2str(freq(find(freq == markers(j)))/funit, '%.2f'), ' ', funit_name, ...
				"\n", num2str(group_delay(find(freq == markers(j)))), 's', ...
				';'], 'linewidth', 2);
		endfor
	endfor
	if legend_out
		legend('Location', 'northeastoutside');
	endif
	title('Group delay');
	xlabel(['Frequency (', funit_name, ')']);
	ylabel('Group delay (s)');
end

