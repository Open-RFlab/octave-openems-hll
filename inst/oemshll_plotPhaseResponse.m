function h = oemshll_plotPhaseResponse(s, names, freq, markers, colors, varargin)
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
%   'wrap':         - Wrap phase between -180° and 180°.
%                   - Default: false.
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
%   oemshll_plotPhaseResponse({s21, s31}, {'s21', 's31'}, freq, markers, {'m', 'g'});
%   drawnow;
%
% author: Thomas Lepoix

	wrap = false;
	wrap_str = 'unwrapped';
	legend_out = false;
	funit = 1e6;
	funit_name = 'MHz';

	i = 1;
	while i <= numel(varargin)
		if (strcmp(varargin{i}, 'wrap')==1);
			wrap = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'legend_out')==1);
			legend_out = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'funit')==1);
			funit = varargin{i+1};
			i = i + 1;
		elseif (strcmp(varargin{i}, 'funit_name')==1);
			funit_name = varargin{i+1};
			i = i + 1;
		else
			warning('openEMS:oemshll_plotPhaseResponse', ['unknown argument key: ''' varargin{i} '''']);
		endif
		i = i + 1;
	endwhile

	if wrap
		wrap_str = 'wrapped';
	else
		wrap_str = 'unwrapped';
	endif
	if numel(s) != numel(names) || numel(s) != numel(colors)
		warning('openEMS:oemshll_plotPhaseResponse', 'mismatch beteen s, names and colors parameters cell number');
	endif

	hold on;
	grid on;
	for i = 1:numel(s)
		if wrap
			phi = (180/pi) * angle(s{i});
		else
			phi = (180/pi) * unwrap(angle(s{i}));
		endif
		plot(freq/funit, phi, [colors{i}, '-'], 'Linewidth', 2);
		for j = 1:numel(markers)
			plot(freq(find(freq == markers(j)))/funit, ...
				phi(find(freq == markers(j))), ...
				[colors{i}, 'o;', names{i}, ' @ ', num2str(freq(find(freq == markers(j)))/funit, '%.2f'), ' ', funit_name, ...
				"\n", num2str(phi(find(freq == markers(j)))), '°', ...
				';'], 'linewidth', 2);
		endfor
	endfor
	if legend_out
		legend('Location', 'northeastoutside');
	endif
	if wrap
		ylim([-180, 180]);
		set(gca, 'ytick', -180:30:180);
	endif
	title(['Phase response (', wrap_str, ')']);
	xlabel(['Frequency (', funit_name, ')']);
	ylabel('Phase response (°)');
end

