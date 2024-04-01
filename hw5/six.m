figure;
subplot(1,3,1);
imshow(I1, []);
title('original');

% deblur with nstd of 1 using tikhanov
H1 = psf2otf(psf1);
H2 = psf2otf(psf2);

G1 = fft2(noise1_g1);
G2 = fft2(noise1_g2);

mu = 1;

tikh1 = (conj(H1) .* G1 + conj(H2) .* G2) ./ (abs(H1).^2 + abs(H2).^2 + mu);

deblur1 = ifft2(tikh1);

subplot(1,3,2);
imshow(deblur1, []);
title('tikh sol w/ nstd 1');

G1 = fft2(noise10_g1);
G2 = fft2(noise10_g2);

mu = 10;

tikh2 = (conj(H1) .* G1 + conj(H2) .* G2) ./ (abs(H1).^2 + abs(H2).^2 + mu);

deblur2 = ifft2(tikh2);

subplot(1,3,3);
imshow(deblur2, []);
title('tikh sol w/ nstd 10');