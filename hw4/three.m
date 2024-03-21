% min norm solution
G1 = fft2(img1);
G2 = fft2(img2);

H1(H1 < eps) = eps;
min_norm1 = G1 ./ H1;
H2(H2 < eps) = eps;
min_norm2 = G2 ./ H2;

min_img1 = ifft2(min_norm1, 'symmetric');
min_img2 = ifft2(min_norm2, 'symmetric');

figure;
imshow(min_img1, []);
title('min-norm psf1');

figure;
imshow(min_img2, []);
title('min-norm psf2');

% Tikhonov deconvolution
H1 = fft2(psf1, size(I1, 1), size(I1, 2));
H2 = fft2(psf2, size(I1, 1), size(I1, 2));

filter1 = H1 ./ (abs(H1) .^ 2 + (1e-2)^2);
tikh1 = G1 .* filter1;
filter2 = H2 ./ (abs(H2) .^ 2 + (1e-2)^2);
tikh2 = G2 .* filter2;

tikh_img1 = ifft2(tikh1);
tikh_img2 = ifft2(tikh2);

figure;
imshow(tikh_img1, []);
title('tikh psf1');

figure;
imshow(tikh_img2, []);
title('tikh psf2');
