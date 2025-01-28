%------------------------------------------------------------------------------------------% 
% Main Program                                          
% This Program will consider 5 optimal positions for EVCS in IEEE-33 BUS
% 
% To reduce the power loss and voltage deviation, 3 DGs can be optimally
% placed in the system as well using PSO method in which the best location
% and size of the DGs are determined in this program.
% Load flow analysis method : Backward Forward Sweep
% 
% EVCS Sizes:
% Real power and Reactive power is calcualted based on charging points of
% each type in EVCS file. By default, the charging points are as:
%               T1      T2       %T3
%     EVCS_1 = [10,     2,       1]; 
%     EVCS_2 = [8 ,     4,       2];
%     EVCS_3 = [6 ,     5,       2];
%     EVCS_4 = [5 ,     7,       3];
%     EVCS_5 = [2 ,     9,       3];
% where
%             %Charger Level  Charger Type	     Maximum Power (kW)	 Input Voltage (V)
% chargerData = [ 1           "Level 1"           1.44
%                 2           "Level 2"           11.5
%                 3           "Level 3"           96  ];
%-------------------------------------------------------------------------------------------%

%% Test are as: 

% Test 1: Power flow analysis of IEEE 33 network (No EVCS  NO DG)
% Test 2: Allocation of EVCS locations without DG
% Test 3: Allocation of EVCS and DG locations without size allocation
% Test 4: Allocation of EVCS and DG locations and DG size allocation


%% Test 1: Power flow analysis of IEEE 33 network (No EVCS  NO DG)
clc;
clear;
close all;
[PL, QL, Vb, VD, V_max, Vb_min]=Load_Flow3(33);

disp('                                        ');
disp('-----------------------------------------------------------------------');
disp(' Table 1:  Power Analysis and Voltage Profile of system');
disp('-----------------------------------------------------------------------');
disp(['Power-Loss (KW):                                               ' num2str(PL)]);
disp(['Power-Loss (KVar):                                             ' num2str(QL)]);
disp(['VD (%):                                                        ' num2str(VD)]);
disp(['Minimum Voltage (p.u):                                         ' num2str(Vb_min)]);
disp(['Maximum Voltage (p.u):                                         ' num2str(V_max)]);
disp('-----------------------------------------------------------------------');


%% Test 2: Allocation of EVCS locations without DG
% Best location of EVCS Without DG: 2 3 6 7 13
clc;
clear;
close all;
MaxIt =  50;                              % Maximum Number of Iterations
nPop  =  100;                             % Population Size (Swarm Size)
Num_EV_EVCS = 5;                          % Number of EVCS to be placed on IEEE 33 bus
Num_EV_DG   = 0;                          % Number of DG   to be placed on IEEE 33 bus
Optimal_Size = false;                     % Considering Optimal size allocation using PSO
TestLimit = 3;                            % Must be even number
if mod(TestLimit, 2) ~= 0 && TestLimit ~= 1
    TestLimit = TestLimit + 1;
end
for i = 1:TestLimit
    [PL, QL, VD, BestSol, BestCost, PV] = IPSO(MaxIt, nPop,  Num_EV_EVCS, Num_EV_DG, Optimal_Size);
    EVCS_No_DG(i,1:5) = BestSol.Position(1:5);
    EVCS_No_DG(i,6)   = PL;
    EVCS_No_DG(i,7)   = QL;
    EVCS_No_DG(i,8)   = VD;
    Allcosts(:, i) = BestCost;
    EVCS_no_DG_result = EVCS_No_DG';
end
k = 0;
figure,
if TestLimit > 1
    for i = 1:TestLimit/2
        for j = 1:2
        k = k+ 1;
        subplot(TestLimit/2, 2, k);
        plot(Allcosts(:, k), 'LineWidth', 2);
        xlabel('Iteration');
        ylabel('Fitness ');
        title(['Sample:  ', num2str(k)]);
        grid on;
        end
    end
else 
   plot(Allcosts(:, 1), 'LineWidth', 2); 
end

%% Test 3: Allocation of EVCS and DG locations without size allocation
clc;
clear;
close all;
MaxIt =  100;                             % Maximum Number of Iterations
nPop  =  50;                              % Population Size (Swarm Size)
Num_EV_EVCS = 5;                          % Number of EVCS to be placed on IEEE 33 bus


Optimal_Size = false;                     % Considering Optimal size allocation using PSO
Num_EV_DG = 3;
switch Num_EV_DG
    case 1
        disp('Placing 1 DG')
        [PL, QL, VD, BestSol, BestCost, PV] = IPSO2(MaxIt, nPop,  Num_EV_EVCS, Num_EV_DG, Optimal_Size);
        EVCS_with_DG(Num_EV_DG,1:5)     = BestSol.Position(1:5);
        EVCS_with_DG(Num_EV_DG,6)       = BestSol.Position(6);
        EVCS_with_DG(Num_EV_DG,7)       = 0;
        EVCS_with_DG(Num_EV_DG,8)       = 0;
        EVCS_with_DG(Num_EV_DG,9)       = PL;
        EVCS_with_DG(Num_EV_DG,10)      = QL;
        EVCS_with_DG(Num_EV_DG,11:12)   = PV(1:2);
        EVCS_with_DG(Num_EV_DG,13)      = VD;
        EVCS_with_DG(Num_EV_DG,14:15)   = PV(3:4);
        Allcosts(:, Num_EV_DG)          = BestCost;
    case 2
        disp('Placing 2 DGs')
        [PL, QL, VD, BestSol, BestCost, PV] = IPSO2(MaxIt, nPop,  Num_EV_EVCS, Num_EV_DG, Optimal_Size);
        EVCS_with_DG(Num_EV_DG,1:5)     = BestSol.Position(1:5);
        EVCS_with_DG(Num_EV_DG,6)       = BestSol.Position(6);
        EVCS_with_DG(Num_EV_DG,7)       = BestSol.Position(7);
        EVCS_with_DG(Num_EV_DG,8)       = 0;
        EVCS_with_DG(Num_EV_DG,9)       = PL;
        EVCS_with_DG(Num_EV_DG,10)      = QL;
        EVCS_with_DG(Num_EV_DG,11:12)   = PV(1:2);
        EVCS_with_DG(Num_EV_DG,13)      = VD;
        EVCS_with_DG(Num_EV_DG,14:15)   = PV(3:4);
        Allcosts(:, Num_EV_DG)          = BestCost;
    case 3
        disp('Placing 3 DGs')
        [PL, QL, VD, BestSol, BestCost, PV] = IPSO2(MaxIt, nPop,  Num_EV_EVCS, Num_EV_DG, Optimal_Size);
        EVCS_with_DG(Num_EV_DG,1:5)     = BestSol.Position(1:5);
        EVCS_with_DG(Num_EV_DG,6)       = BestSol.Position(6);
        EVCS_with_DG(Num_EV_DG,7)       = BestSol.Position(7);
        EVCS_with_DG(Num_EV_DG,8)       = BestSol.Position(8);
        EVCS_with_DG(Num_EV_DG,9)       = PL;
        EVCS_with_DG(Num_EV_DG,10)      = QL;
        EVCS_with_DG(Num_EV_DG,11:12)   = PV(1:2);
        EVCS_with_DG(Num_EV_DG,13)      = VD;
        EVCS_with_DG(Num_EV_DG,14:15)   = PV(3:4);
        Allcosts(:, Num_EV_DG)          = BestCost;
end
disp('Done')

%% Test 4: Allocation of EVCS and DG locations and DG size allocation

clc;
clear;
close all;
MaxIt =  100;                             % Maximum Number of Iterations
nPop  =  50;                              % Population Size (Swarm Size)
Num_EV_EVCS = 5;                          % Number of EVCS to be placed on IEEE 33 bus
Optimal_Size = true;                     % Considering Optimal size allocation using PSO

Num_EV_DG   = 3;
switch Num_EV_DG
    case 1
        disp('Placing 1 DG')
        [PL, QL, VD, BestSol, BestCost, PV] = IPSO2(MaxIt, nPop,  Num_EV_EVCS, Num_EV_DG, Optimal_Size);
        EVCS_with_DG(Num_EV_DG,1:5)     = BestSol.Position(1:5);
        EVCS_with_DG(Num_EV_DG,6)       = BestSol.Position(6);
        EVCS_with_DG(Num_EV_DG,7)       = 0;
        EVCS_with_DG(Num_EV_DG,8)       = 0;
        EVCS_with_DG(Num_EV_DG,9)       = BestSol.Position(7);
        EVCS_with_DG(Num_EV_DG,10)      = 0;
        EVCS_with_DG(Num_EV_DG,11)      = 0;
        EVCS_with_DG(Num_EV_DG,12)      = PL;
        EVCS_with_DG(Num_EV_DG,13)      = QL;
        EVCS_with_DG(Num_EV_DG,14:15)   = PV(1:2);
        EVCS_with_DG(Num_EV_DG,16)      = VD;
        EVCS_with_DG(Num_EV_DG,17:18)   = PV(3:4);
        Allcosts(:, Num_EV_DG)          = BestCost;
    case 2
        disp('Placing 2 DGs')
        [PL, QL, VD, BestSol, BestCost, PV] = IPSO2(MaxIt, nPop,  Num_EV_EVCS, Num_EV_DG, Optimal_Size);
        EVCS_with_DG(Num_EV_DG,1:5)     = BestSol.Position(1:5);
        EVCS_with_DG(Num_EV_DG,6)       = BestSol.Position(6);
        EVCS_with_DG(Num_EV_DG,7)       = BestSol.Position(7);
        EVCS_with_DG(Num_EV_DG,8)       = 0;
        EVCS_with_DG(Num_EV_DG,9)       = BestSol.Position(8);
        EVCS_with_DG(Num_EV_DG,10)      = BestSol.Position(9);
        EVCS_with_DG(Num_EV_DG,11)      = 0;
        EVCS_with_DG(Num_EV_DG,12)      = PL;
        EVCS_with_DG(Num_EV_DG,13)      = QL;
        EVCS_with_DG(Num_EV_DG,14:15)   = PV(1:2);
        EVCS_with_DG(Num_EV_DG,16)      = VD;
        EVCS_with_DG(Num_EV_DG,17:18)   = PV(3:4);
        Allcosts(:, Num_EV_DG)          = BestCost;
    case 3
        disp('Placing 3 DGs')
        [PL, QL, VD, BestSol, BestCost, PV] = IPSO2(MaxIt, nPop,  Num_EV_EVCS, Num_EV_DG, Optimal_Size);
        EVCS_with_DG(Num_EV_DG,1:5)     = BestSol.Position(1:5);
        EVCS_with_DG(Num_EV_DG,6)       = BestSol.Position(6);
        EVCS_with_DG(Num_EV_DG,7)       = BestSol.Position(7);
        EVCS_with_DG(Num_EV_DG,8)       = BestSol.Position(8);
        EVCS_with_DG(Num_EV_DG,9)       = BestSol.Position(9);
        EVCS_with_DG(Num_EV_DG,10)      = BestSol.Position(10);
        EVCS_with_DG(Num_EV_DG,11)      = BestSol.Position(11);
        EVCS_with_DG(Num_EV_DG,12)      = PL;
        EVCS_with_DG(Num_EV_DG,13)      = QL;
        EVCS_with_DG(Num_EV_DG,14:15)   = PV(1:2);
        EVCS_with_DG(Num_EV_DG,16)      = VD;
        EVCS_with_DG(Num_EV_DG,17:18)   = PV(3:4);
        Allcosts(:, Num_EV_DG)          = BestCost;
end
disp('Done')

