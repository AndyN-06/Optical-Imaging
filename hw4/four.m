n_std = 1;
I_noisy = normrnd(I1, n_std, 700, 700);
noise1_img1 = conv2(I_noisy, psf1, 'same');
noise1_img2 = conv2(I_noisy, psf2, 'same');

figure;
subplot(1,2,1);
imshow(noise1_img1, []);
subplot(1,2,2);
imshow(noise1_img2, []);

n_std = 10;
I_noisy = normrnd(I1, n_std, 700, 700);
noise10_img1 = conv2(I_noisy, psf1, 'same');
noise10_img2 = conv2(I_noisy, psf2, 'same');

figure;
subplot(1,2,1);
imshow(noise10_img1, []);
subplot(1,2,2);
imshow(noise10_img2, []);
