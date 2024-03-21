
H1 = fft2(psf1, size(I_noisy, 1), size(I_noisy, 2));
H2 = fft2(psf2, size(I_noisy, 1), size(I_noisy, 2));

% min norm solution w/ nstd = 1
G1 = fft2(noise1_img1);
G2 = fft2(noise1_img2);

H1(H1 < eps) = eps;
hmin_norm1 = G1 ./ H1;
H2(H2 < eps) = eps;
hmin_norm2 = G2 ./ H2;

hmin_img1 = ifft2(hmin_norm1, 'symmetric');
hmin_img2 = ifft2(hmin_norm2, 'symmetric');

figure;
imshow(hmin_img1, []);
title('psf1 & nstd=1');

figure;
imshow(hmin_img2, []);
title('psf2 & nstd=1');

% min norm solution w/ nstd = 10
G1 = fft2(noise10_img1);
G2 = fft2(noise10_img2);

H1(H1 < eps) = eps;
hmin_norm1 = G1 ./ H1;
H2(H2 < eps) = eps;
hmin_norm2 = G2 ./ H2;

hmin_img1 = ifft2(hmin_norm1, 'symmetric');
hmin_img2 = ifft2(hmin_norm2, 'symmetric');

figure;
imshow(hmin_img1, []);
title('min-norm: psf1 & nstd=10');

figure;
imshow(hmin_img2, []);
title('min-norm: psf2 & nstd=10');

% Tikhonov deconvolution
G1 = fft2(noise1_img1);
G2 = fft2(noise1_img2);

H1 = fft2(psf1, size(I_noisy, 1), size(I_noisy, 2));
H2 = fft2(psf2, size(I_noisy, 1), size(I_noisy, 2));

filter1 = H1 ./ (abs(H1) .^ 2 + (.1)^2);
tikh1 = G1 .* filter1;
filter2 = H2 ./ (abs(H2) .^ 2 + (.1)^2);
tikh2 = G2 .* filter2;

tikh_img1 = ifft2(tikh1);
tikh_img2 = ifft2(tikh2);

figure;
imshow(tikh_img1, []);
title('tikh: psf1 & nstd=1');

figure;
imshow(tikh_img2, []);
title('tikh: psf2 & nstd=1');

% Tikhonov deconvolution
G1 = fft2(noise10_img1);
G2 = fft2(noise10_img2);

H1 = fft2(psf1, size(I_noisy, 1), size(I_noisy, 2));
H2 = fft2(psf2, size(I_noisy, 1), size(I_noisy, 2));

filter1 = H1 ./ (abs(H1) .^ 2 + (1)^2);
tikh1 = G1 .* filter1;
filter2 = H2 ./ (abs(H2) .^ 2 + (1)^2);
tikh2 = G2 .* filter2;

tikh_img1 = ifft2(tikh1);
tikh_img2 = ifft2(tikh2);

figure;
imshow(tikh_img1, []);
title('tikh: psf1 & nstd=10');

figure;
imshow(tikh_img2, []);
title('tikh: psf2 & nstd=10');
