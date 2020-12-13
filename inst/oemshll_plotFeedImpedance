function h = oemshll_plotFeedImpedance(Z, port_n, freq, markers, abs_color, im_color, re_color, varargin)
%
% input:
%   Z:              - Feed port impedance.
%                   - See example.
%   port_n:         - Port number string.
%   freq:           - Frequency array.
%   markers:        - Frequency array. Put a marker on each frequency inside.
%   abs_color:      - Color letter. See the 'fmt' argument of the Octave 'plot' function.
%                   - Absolute impedance.
%   im_color:       - Color letter. See the 'fmt' argument of the Octave 'plot' function.
%                   - Imaginary part.
%   re_color:       - Color letter. See the 'fmt' argument of the Octave 'plot' function.
%                   - Real part.
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
%   z1 = port{1}.uf.tot./port{1}.if.tot;
%   figure;
%   oemshll_plotFeedImpedance(z1, '1', freq, 'k', 'm', 'g');
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
			warning('openEMS:oemshll_plotFeedImpedance', ['unknown argument key: ''' varargin{i} '''']);
		endif
		i = i + 1;
	endwhile

	hold on;
	grid on;
	plot(freq/funit, abs(Z), [abs_color, '-;|Z', port_n, '|;'], 'Linewidth', 2);
	plot(freq/funit, imag(Z), [im_color, '--;Im(Z', port_n, ');'], 'Linewidth', 2);
	plot(freq/funit, real(Z), [re_color, '--;Re(Z', port_n, ');'], 'Linewidth', 2);
	for i = 1:numel(markers)
		z = Z(find(freq == markers(i)));
		if imag(z) >= 0
			z_str = '+';
		else
			z_str = '';
		endif
		z_str = [num2str(real(z), '%.2f'), z_str, num2str(imag(z), '%.2f'), 'j'];
		plot(freq(find(freq == markers(i)))/funit, abs(z), ...
			[abs_color, 'o;Z', port_n, ' @ ', num2str(freq(find(freq == markers(i)))/funit, '%.2f'), ' ', funit_name, ...
			"\n", num2str(abs(z), '%.2f'), ' Ω ', z_str, ...
			';'], 'linewidth', 2);
		plot(freq(find(freq == markers(i)))/funit, imag(z), [im_color, 'o'], 'linewidth', 2);
		plot(freq(find(freq == markers(i)))/funit, real(z), [re_color, 'o'], 'linewidth', 2);
	endfor
	if legend_out
		legend('Location', 'northeastoutside');
	endif
	title(['Impedance Z', port_n]);
	xlabel(['Frequency (', funit_name, ')']);
	ylabel('Impedance (Ω)');
end

