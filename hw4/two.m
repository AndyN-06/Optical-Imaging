F = fft2(I1);
H1 = fft2(psf1, size(I1, 1), size(I1, 2));
H2 = fft2(psf2, size(I1, 1), size(I1, 2));

sing1 = abs(H1(:));
sing2 = abs(H2(:));

sing1(sing1 < eps) = [];
sing2(sing2 < eps) = [];

num1 = max(sing1) / min(sing1);
num2 = max(sing2) / min(sing2);

