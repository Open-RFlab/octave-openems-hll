function h = oemshll_plotPhaseDelay(s, names, freq, markers, colors, varargin)
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
%   oemshll_plotPhaseDelay({s21, s31}, {'s21', 's31'}, freq, markers, {'m', 'g'});
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
			warning('openEMS:oemshll_plotPhaseDelay', ['unknown argument key: ''' varargin{i} '''']);
		endif
		i = i + 1;
	endwhile

	if numel(s) != numel(names) || numel(s) != numel(colors)
		warning('openEMS:oemshll_plotPhaseDelay', 'mismatch beteen s, names and colors parameters cell number');
	endif

	hold on;
	grid on;
	for i = 1:numel(s)
		phase_delay = -unwrap(angle(s{i}))./(freq/funit*2*pi);
		plot(freq/funit, phase_delay, [colors{i}, '-'], 'Linewidth', 2);
		for j = 1:numel(markers)
			plot(freq(find(freq == markers(j)))/funit, ...
				phase_delay(find(freq == markers(j))), ...
				[colors{i}, 'o;', names{i}, ' @ ', num2str(freq(find(freq == markers(j)))/funit, '%.2f'), ' ', funit_name, ...
				"\n", num2str(phase_delay(find(freq == markers(j)))), 's', ...
				';'], 'linewidth', 2);
		endfor
	endfor
	if legend_out
		legend('Location', 'northeastoutside');
	endif
	title('Phase delay');
	xlabel(['Frequency (', funit_name, ')']);
	ylabel('Phase delay (s)');
end

