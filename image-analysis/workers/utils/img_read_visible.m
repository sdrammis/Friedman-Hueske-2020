function img = img_read_visible(imgSrc)
img = imread(imgSrc);
freq = imhist(img);
norm_I = linspace(0,1,256);
norm_I = norm_I';
bg_idx = find(freq == max(freq), 1);
if bg_idx == 1
    bg_idx = find(freq == max(freq(2:end)), 1);
end
ub_idx = bg_idx + find(freq(bg_idx:end) == min(freq(bg_idx:end)), 1);
fixed_norm_I = norm_I(bg_idx:ub_idx);
beta_fit = fitdist(fixed_norm_I, 'beta');
beta_pdf =  pdf(beta_fit, norm_I);
nu_beta_pdf = pdf(beta_fit, 0:10^12*eps:1);
beta_peak_idx = find(beta_pdf==max(beta_pdf),1);
hgram = hist(-log(nu_beta_pdf(beta_peak_idx:end)),256);
img = histeq(img,hgram);
end

