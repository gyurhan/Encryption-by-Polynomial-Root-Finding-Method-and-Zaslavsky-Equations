A = zeros(1, 10);
x1 = 0.1203804300432;
y1 = 0.5432056302;
x1_prev = 0.1203804300432;
y1_prev = 0.5432056302;
x2 = 0.3456765743261109;
y2 = 0.50475234403240043;
x2_prev = x2;
y2_prev = y2;
e=0.3;
v=0.2;
r=5;
m=(1-exp(-r))/r;
omega=100;
k=9;
a=1.885;
%%% Initial iterations
i = 0;
NUMBER_OF_INITIAL_ITERATIONS = 5000;
while(i < NUMBER_OF_INITIAL_ITERATIONS)
    x1 = mod(x1_prev + omega / (2 * pi) + (a * omega) / (2 * pi * r) * (1 - exp(-r)) * y1_prev+...
        (k / r) * (1 - exp(-r)) * cos(2 * pi * x1_prev), 1);
    % Since x(i) is computed mod1 we always have  0<=x(i)<1
    y1 = exp(-r) * (y1_prev + e * cos(2 * pi * x1_prev));
    x1_prev = x1;
    y1_prev = y1;
    x1_integer = abs(fix(x1 * 1000000000));
    y1_integer = abs(fix(y1 * 1000000000));
    val1 = bitxor(x1_integer, y1_integer);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x2 = mod(x2_prev + omega / (2 * pi) + (a * omega) / (2 * pi * r) * (1 - exp(-r)) * y2_prev+...
        (k / r) * (1 - exp(-r)) * cos(2 * pi * x2_prev), 1);
    % Since x(i) is computed mod1 we always have  0<=x(i)<1
    y2 = exp(-r) * (y2_prev + e * cos(2 * pi * x2_prev));
    x2_prev = x2;
    y2_prev = y2;
    x2_integer = abs(fix(x2 * 1000000000));
    y2_integer = abs(fix(y2 * 1000000000));
    val2 = bitxor(x2_integer, y2_integer);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if mod(val1, 2) == 1
        i = i + 1;
    end
    
end

%% Computing the values for x(i),y(i)
i = 0;
cnt = 0;
NUMBER_OF_BYTES = 17;
while(i < NUMBER_OF_BYTES)
    cnt = cnt + 1;
    x1 = mod(x1_prev + omega / (2 * pi) + (a * omega) / (2 * pi * r) * (1 - exp(-r)) * y1_prev+...
        (k / r) * (1 - exp(-r)) * cos(2 * pi * x1_prev), 1);
    % Since x(i) is computed mod1 we always have  0<=x(i)<1
    y1 = exp(-r) * (y1_prev + e * cos(2 * pi * x1_prev));
    x1_prev = x1;
    y1_prev = y1;
    x1_integer = abs(fix(x1 * 1000000000));
    y1_integer = abs(fix(y1 * 1000000000));
    val1 = bitxor(x1_integer, y1_integer);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x2 = mod(x2_prev + omega / (2 * pi) + (a * omega) / (2 * pi * r) * (1 - exp(-r)) * y2_prev+...
        (k / r) * (1 - exp(-r)) * cos(2 * pi * x2_prev), 1);
    % Since x(i) is computed mod1 we always have  0<=x(i)<1
    y2 = exp(-r) * (y2_prev + e * cos(2 * pi * x2_prev));
    x2_prev = x2;
    y2_prev = y2;
    x2_integer = abs(fix(x2 * 1000000000));
    y2_integer = abs(fix(y2 * 1000000000));
    val2 = bitxor(x2_integer, y2_integer);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if mod(val1, 2) == 1
        i = i + 1;
        A(i) = mod(val2, 256);
    end
    
end



%function [ReconstructedString]=DECR(EncryptedString,BlockLen,shiftKoef)
BlockLen = 5;
shiftKoef = 0;
EncryptedString = [-62.8745792733008 + 0.00000000000000i,0.329574066807527 + 1.06522550050638i,0.329574066807527 - 1.06522550050638i,-1.39228443015711 + 0.136854047570822i,-1.39228443015711 - 0.136854047570822i,-89.8704083046446 + 0.00000000000000i,0.470954575891323 + 1.60817739759316i,0.470954575891323 - 1.60817739759316i,-0.535750423569053 + 0.517432709189165i,-0.535750423569053 - 0.517432709189165i,-253.421450055107 + 0.00000000000000i,0.263912753132607 + 0.901306344373147i,0.263912753132607 - 0.901306344373147i,-1.02330740055905 + 0.00000000000000i,-0.0830680505989180 + 0.00000000000000i,-143.346665412001 + 0.00000000000000i,-1.65333458799913 + 0.00000000000000i];
n=length(EncryptedString); % length of input string
numBlocks = ceil(n/BlockLen); % total number of blocks for encryption

ReconstructedString='';
for k=1:numBlocks
    i=(k-1)*BlockLen+1; % initial index of current block
    j=k*BlockLen; % final index of current block
    if j>n
        j=n;
    end
    clear currentBlock
    currentBlock =EncryptedString(i:j); %current block- encrypted string
    ascii_codes=poly(currentBlock)+shiftKoef; %Polynomial coefficients
    ascii_codes=ascii_codes(2:end); %which are ascii of current blk
    ascii_codes = double(ascii_codes);
    uint8_ascii_codes = uint8(ascii_codes);
    pseudo_random_seq = uint8(A);
    decrypted_ascii_codes = bitxor(uint8_ascii_codes, pseudo_random_seq(i : j));
    T=native2unicode(decrypted_ascii_codes,'');% decrypted block
    %ReconstructedString=strcat(ReconstructedString,T); %append decr blk
    ReconstructedString=[ReconstructedString T];
end