function h = oemshll_plotSmithChart(s, names, freq, markers, color_order, varargin)
%
% input:
%   s:              - S parameters cell array.
%                   - See example.
%   names:          - S parameters name strings cell array.
%   freq:           - Frequency array.
%   markers:        - Frequency array. Put a marker on each frequency inside.
%   color_order:    - Color order array.
%                   - See the 'ColorOrder' argument of the Octave 'gca' object.
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
%   color_order = [ ...
%   	[1, 0, 1]; ... % m
%   	[0, 1, 0]];    % g
%   figure;
%   oemshll_plotSmithChart({s11, s21}, {'s11', 's21'}, freq, markers, color_order);
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
			warning('openEMS:oemshll_plotSmithChart', ['unknown argument key: ''' varargin{i} '''']);
		endif
		i = i + 1;
	endwhile

	if numel(s) != numel(names)
		warning('openEMS:oemshll_plotSmithChart', 'mismatch beteen s and names parameters cell number');
	endif

	f_index = [];
	for i = 1:numel(markers)
		f_index = [f_index, find(freq == markers(i))];
	endfor

	set(gca, 'ColorOrder', color_order, 'NextPlot', 'replacechildren');

	first = true;
	for i = 1:numel(s)
		if first == true
			first = false;
			h = plotSmith(s{i}, names{i}, freq, f_index);
		else
			h = plotSmith(s{i}, names{i}, freq, f_index, 'nogrid');
		endif
		set(h, 'Linewidth', 2);
	endfor
	if legend_out
		legend('Location', 'northeastoutside');
	endif
end

