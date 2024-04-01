noise1_g1 = g1 + normrnd(0, 1, size(g1));
noise10_g1 = g1 + normrnd(0, 10, size(g1));

figure;
subplot(1,2,1);
imshow(noise1_g1, []);
title('g1 w/ nstd 1');

subplot(1,2,2);
imshow(noise10_g1, []);
title ('g1 w/ nstd 10');

noise1_g2 = g2 + normrnd(0, 1, size(g2));
noise10_g2 = g2 + normrnd(0, 10, size(g2));

figure;
subplot(1,2,1);
imshow(noise1_g2, []);
title('g2 w/ nstd 1');

subplot(1,2,2);
imshow(noise10_g2, []);
title ('g2 w/ nstd 10');