con1 = conv2(o1, psf1, 'same');
con2 = conv2(o2, psf2, 'same');

g = con1 + con2;

figure;
subplot(1,3,1)
imshow(o1, []);
title('o1');
subplot(1,3,2);
imshow(o2, []);
title('o2');
subplot(1,3,3);
imshow(g, []);
title('g');