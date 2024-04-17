G = fft2(g);

h1 = fft2(psf1, size(g, 1), size(g, 2));
h2 = fft2(psf2, size(g, 1), size(g, 2));

mu1 = 1;
mu2 = .01;

filter1 = conj(h1) ./ (abs(h1) .^ 2 + mu1);
re_f1 = ifft2(filter1 .* G);

filter2 = conj(h2) ./ (abs(h2) .^ 2 + mu2);
re_f2 = ifft2(filter2 .* G);

figure;
subplot(1,2,1);
imshow(re_f1, []);
title('reconstructed o1');

subplot(1,2,2);
imshow(re_f2, []);
title('reconstructed o2');