img1 = conv2(I1, psf1, 'same');
img2 = conv2(I1, psf2, 'same');

figure;
imagesc(img1);
axis image;

figure;
imagesc(img2);
axis image;