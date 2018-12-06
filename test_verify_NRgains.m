figure;
plot(10*log(xi'))
title('xi')

figure
NRgains = xi>=1;
plot(NRgains')
title('BM')

figure
NRgains = 1./(1 + 1./xi);
plot(NRgains')
title('WF')

figure
a = 2;
NRgains = sqrt((a + 1./xi)./(a + 4./xi + 2./(xi.^2)));
plot(NRgains')
title('Env')