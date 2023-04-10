%% This is meant to help calculate Impedances for the submission sheet
Vpp = 1;
Vin = Vpp;  % 1 Vpp


% to help with unit conversion
k = 1000;
M = 10^6;
p = 10^(-12);

%% Cases
%% The cases of Impedances
% of form [z1 z2]
caseNull = [0 1e100];
caseA = [10 20];
caseB = [1*k 2*k];
caseC = [100*k 200*k];  % Potentially some loading here
caseD = [10*M 20*M];  % The Elenco will have some loading here because of the MOhms
caseE = [9*M 1*M];  % 10X scope has a resistance of 9 MOhms. May cause loading


%% PLUG IN CURRENT CASE
current_Case = caseD+[50 0];
z1lambda = 0.01*M;
z2lambda = 0.09*M;


%% Error - to find error
    % find error in the function generator (lambda)
    % find error in [resistors]/[capacitors]
        % [5%]/[10%] OR multimeter error
    % 


% input scope error
scope_error = 0.02;
gen_error = 0.02;


%% Declaring Impedances
% The maximum current possible through the oscilloscope is 2.5 A
Z_multi = 10*M;
%Z_teensy = 1/(p*1j*w*7);  % uses capacitance, help

Z_scope_10x = 10*M;  % Z_oscilloscope + Z_probe
Z_scope_1x = 1*M;

reader = 10*M;



% Because it's a sine function, the multimeter will read Vrms, not Vzp
% All of these values are thus Vrms values

%% Calculate what the multimeter will find

% Find voltage over Z2 (Vout). This is in Vpp
V_out = findTotalV(Vin, current_Case(1), current_Case(2), reader);
%lambda_v = totalError(Vin, current_Case(1), current_Case(2), reader, Vin*gen_error, z1lambda, z2lambda);


function error = totalError(voltage, Z1, Z2, Z_reader, ...
                            v_err, Z1_err, Z2_err)
    % hack error, inputs are 
    nominal = findTotalV(voltage, Z1, Z2, Z_reader);
    dVv = nominal-findTotalV(voltage-v_err, Z1, Z2, Z_reader);
    dVz1 = nominal-findTotalV(voltage, Z1-Z1_err, Z2, Z_reader);
    dVz2 = nominal-findTotalV(voltage, Z1, Z2-Z2_err, Z_reader);
    dVz3 = nominal-findTotalV(voltage, Z1, Z2-Z2_err, Z_reader*0.95);
    
    error = sqrt(dVv^2 + dVz1^2 + dVz2^2 + dVz3^2);
end


function resultingV = findTotalV(voltage, Z1, Z2, Z_reader)
    % returns vpp

    smallZ = Z2;
    totalZ = smallZ + Z1;

    I = voltage/totalZ;

    V_remaining = I*smallZ;
    %resultingV = V_remaining

    % apply loading
    resultingV = V_remaining*(Z_reader/(Z_reader+Z2))
    %eqR = (1/Z_reader + 1/Z2)^-1
    %resultingV = voltage*(eqR/(Z1+eqR))
end

