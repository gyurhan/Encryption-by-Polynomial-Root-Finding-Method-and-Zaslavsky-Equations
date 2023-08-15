%my_string=&#39;StringEncrypt page allows you to encrypt strings and %files using randomly generated
%algorithm, generating a unique %decryption code in the selected programming language. Simple &amp;
%fast - try it yourself!&#39;;
%BlockLen=20; %Length of blocksfor encryption
%shiftKoef = 100; %constant number fo shifting ascii codes


%Random generator properties (Zaslavski Map)
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

my_string = 'Shumen University';
BlockLen = 5;
shiftKoef = 0;
n=length(my_string); % length of input string
numBlocks = ceil(n/BlockLen); % total number of blocks for encryption
% ==== ENCRYPTION =========
EncryptedString=zeros(1,n);
for current_block_number=1:numBlocks
    i=(current_block_number-1)*BlockLen+1; % initial index of current block
    j=current_block_number*BlockLen; % final index of current block
    if j>n
        j=n;
        BlockLen = j - i + 1;
    end
    currentBlock = my_string(i:j); % current block - string
    
    % ========== Generating array with random values ==============
    %A = int8(zeros(1, BlockLen));
    A = zeros(1, BlockLen);
    cnt = 0;
    total_iterations = 0;
    while(cnt < BlockLen)
        total_iterations = total_iterations + 1;
        % calculating value1
        x1 = mod(x1_prev + omega / (2 * pi) + (a * omega) / (2 * pi * r) * (1 - exp(-r)) * y1_prev+...
        (k / r) * (1 - exp(-r)) * cos(2 * pi * x1_prev), 1);
        y1 = exp(-r) * (y1_prev + e * cos(2 * pi * x1_prev));
        x1_prev = x1;
        y1_prev = y1;
        x1_integer = abs(fix(x1 * 1000000000));
        y1_integer = abs(fix(y1 * 1000000000));
        val1 = bitxor(x1_integer, y1_integer);
        
        % calculating value2
        x2 = mod(x2_prev + omega / (2 * pi) + (a * omega) / (2 * pi * r) * (1 - exp(-r)) * y2_prev+...
        (k / r) * (1 - exp(-r)) * cos(2 * pi * x2_prev), 1);
        % Since x is computed mod1 we always have  0<=x(i)<1
        y2 = exp(-r) * (y2_prev + e * cos(2 * pi * x2_prev));
        x2_prev = x2;
        y2_prev = y2;
        x2_integer = abs(fix(x2 * 1000000000));
        y2_integer = abs(fix(y2 * 1000000000));
        val2 = bitxor(x2_integer, y2_integer);
        
        if mod(val1, 2) == 1
            cnt = cnt + 1;
            A(cnt) = mod(val2, 256);
        end
    end
    
    % =============================================================
    
    ascii_codes=uint8(unicode2native(currentBlock)-shiftKoef); %ascii c. of curren block-shifted
    integerRandomNumbers = uint8(A);
    ascii_codes_encrypted = bitxor(ascii_codes, integerRandomNumbers);
        P=roots(double([1 ascii_codes_encrypted])); % encrypted block (Polynomial coefficient)
         EncryptedString(i:j)=P; %append encrypted block (without leading coefficient)
end