x = -2:.01:1.99;
y = -2:.01:1.99;

[X, Y] = meshgrid(x, y);

%a
f = cos(20 * pi * X);
fdft = fftshift(fft2(f));

figure;
subplot(1, 2, 1);
imagesc(x, y, f);
title('original f');
xlabel('x');
ylabel('y');

subplot(1, 2, 2);
imagesc(x, y, log(abs(fdft) + 1));
title('f dft');
xlabel('u');
ylabel('v');

%b
std = .2;
noise = randn(size(f)) * std;
fn = f + n;

figure;
subplot(1, 2, 1);
imagesc(x, y, fn);
title('Noisy fn');
xlabel('x');
ylabel('y');

subplot(1, 2, 2);
imagesc(x, y, log(abs(fftshift(fft2(fn))) + 1));
title('DFT fn');
xlabel('u');
ylabel('v');

%c
total_energy = sum(f(:) .^ 2);
noise_energy = sum(n(:) .^ 2);
SNR = total_energy / noise_energy


