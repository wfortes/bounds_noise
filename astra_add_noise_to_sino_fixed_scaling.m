function sinogram_out = astra_add_noise_to_sino_fixed_scaling(sinogram_in,I0)

%--------------------------------------------------------------------------
% sinogram_out = astra_add_noise_to_sino(sinogram_in,I0)
%
% Add poisson noise to a sinogram.
%
% sinogram_in: input sinogram, can be either MATLAB-data or an
% astra-identifier.  In the latter case, this operation is inplace and the
% result will also be stored in this data object.
% I0: background intensity, used to set noise level, lower equals more
% noise
% sinogram_out: output sinogram in MATLAB-data.
%--------------------------------------------------------------------------
%------------------------------------------------------------------------
% This file is part of the
% All Scale Tomographic Reconstruction Antwerp Toolbox ("ASTRA-Toolbox")
%
% Copyright: IBBT-Vision Lab, University of Antwerp
% Contact: mailto:wim.vanaarle@ua.ac.be
% Website: http://astra.ua.ac.be
%------------------------------------------------------------------------
% $Id: astra_add_noise_to_sino.m 1184 2010-09-13 10:20:44Z gmerckx $

if numel(sinogram_in) == 1
	sinogramRaw = astra_mex_data2d('get', sinogram_in);
else
	sinogramRaw = sinogram_in;
end

% scale to [0,1]
mu = 1E-3;
if max(sinogramRaw(:)) > 1E3
    error( 'Scaling in astra_add_noise_to_sino_fixed_scaling.m is too large');
end

sinogramRawScaled = sinogramRaw .* mu;
% to detector count
sinogramCT = I0 * exp(-sinogramRawScaled);
% add poison noise
sinogramCT_A = sinogramCT * 1e-12;
sinogramCT_B = double(imnoise(sinogramCT_A, 'poisson'));
sinogramCT_C = sinogramCT_B * 1e12;
% to density
sinogramCT_D = sinogramCT_C / I0;
sinogram_out = -log(sinogramCT_D)/mu;

if numel(sinogram_in) == 1
	astra_mex_data2d('store', sinogram_in, sinogram_out);
end
