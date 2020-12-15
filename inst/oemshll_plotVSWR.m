function h = oemshll_plotVSWR(s, port_n, freq, markers, color, varargin)
%
% input:
%   s:              - S parameter, should be a reflection coefficient (Sxx, no Sxy).
%                   - See example.
%   port_n:         - Port number string.
%   freq:           - Frequency array.
%   markers:        - Frequency array. Put a marker on each frequency inside.
%   color:          - Color letter. See the 'fmt' argument of the Octave 'plot' function.
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
%   s11 = port{1}.uf.ref ./ port{1}.uf.inc;
%   figure;
%   oemshll_plotVSWR(s11, '1', freq, 'g');
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
			warning('openEMS:oemshll_plotVSWR', ['unknown argument key: ''' varargin{i} '''']);
		endif
		i = i + 1;
	endwhile

	hold on;
	grid on;
	vswr = (1+(abs(s)))./(1-(abs(s)));
	plot(freq/funit, vswr, [color, '-'], 'Linewidth', 2);
	for i = 1:numel(markers)
		vswr_i = vswr(find(freq == markers(i)));
		plot(freq(find(freq == markers(i)))/funit, vswr_i, ...
			[color, 'o;VSWR', port_n, ' @ ', num2str(freq(find(freq == markers(i)))/funit, '%.2f'), ' ', funit_name, ...
			"\n", num2str(vswr_i, '%.2f'), ...
			';'], 'linewidth', 2);
	endfor
	if legend_out
		legend('Location', 'northeastoutside');
	endif
	title(['VSWR', port_n]);
	xlabel(['Frequency (', funit_name, ')']);
	ylabel('VSWR');
end

