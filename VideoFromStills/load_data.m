function img = load_data(path, f)

% load img and convert to double
img = imread(path);
img = double(img);

% resize it
hei = floor(size(img, 1) / f);
wid = floor(size(img, 2) / f);

img = imresize(img, [hei, wid], 'Antialiasing', true);

% normalize it
img = img / max(img(:));
end

% def load_data(path, f):
%     img = np.array(Image.open(path))
%     img = skimage.transform.resize(img, (img.shape[0]//f,img.shape[1]//f), anti_aliasing = True)
%     img /= np.max(img)
%     return img