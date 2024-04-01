g1 = conv2(I1, psf1, 'same');
g2 = conv2(I1, psf2, 'same');

figure;
subplot(1,2,1);
imshow(g1, []);
title('g1');

subplot(1,2,2);
imshow(g2, []);
title('g2');