function [path] = funcGeneratePath(pathLength)
    % Initialize variables
    nodeNormal = 1;
    nodeChallenge = 2;
    nodeBoss = 3;
    nodeFinalBoss = 4;
    nodeRoulette = 5;
    nodeDate = 6;
    nodeRomanticEvening = 7;

    % Path configuration
    posBoss = floor(pathLength / 2);
    posFinalBoss = pathLength;
    posLoveGambleSplits = [posBoss - 1, posFinalBoss - 1];
    printExpectedValues = false;
    probTwoNodes = 85;
    probDeltaNormalChallenge = 1; % decreases probNormal, increases probChallenge
    probNormal = 66; % node probabilities MUST add up to 100
    probChallenge = 19;
    probDate = 10;
    probRoulette = 5;

    % Get expected counts of probabilized node type
    if (printExpectedValues)
        numExpectedFree = (pathLength - 5) * (1 + probTwoNodes/100);
        numExpectedNormal = numExpectedFree * ...
            (probNormal/100 - probDeltaNormalChallenge/100*(pathLength/2));
        numExpectedChallenge = numExpectedFree * ...
            (probChallenge/100 + probDeltaNormalChallenge/100*(pathLength/2));
        numExpectedDate = 2 + numExpectedFree * probDate/100;
        numExpectedRoulette = 2 + numExpectedFree * probRoulette/100;
    
        fprintf("Expected random nodes: %.1f\n", numExpectedFree);
        fprintf("Expected normal nodes: %.1f\n", numExpectedNormal);
        fprintf("Expected challenge nodes: %.1f\n", numExpectedChallenge);
        fprintf("Expected date/romantic evening nodes: %.1f\n", numExpectedDate);
        fprintf("Expected roulette nodes: %.1f\n", numExpectedRoulette);
    end

    % Checks for valid configuration
    if (probDeltaNormalChallenge * (pathLength - 1) > probNormal)
        error("probDeltaNormalChallenge too high, will result in probNormal" + ...
            " falling below 0")
    end
    if (probNormal + probChallenge + probDate + probRoulette ~= 100)
        error("Node probabilities must add up to 100")
    end

    % Create the path
    path = zeros([2, pathLength]);
    path(:, 1) = [nodeNormal; -1];

    for i = 2:pathLength
        if (i ~= posBoss && i ~= posFinalBoss && ~ismember(i, posLoveGambleSplits))
            for j = 1:2
                % Get a random number for choosing nodes
                randNum = randi(100);
                
                % Set a random node at position
                node = -1;
                
                if (j == 1 || (j == 2 && randi(100) <= probTwoNodes))
                    if (randNum <= probNormal)
                        node = nodeNormal;
                    elseif (randNum <= probNormal + probChallenge)
                        node = nodeChallenge;
                    elseif (randNum <= probNormal + probChallenge + probDate)
                        if (i < posBoss)
                            node = nodeDate;
                        else
                            node = nodeRomanticEvening;
                        end
                    elseif (randNum <= probNormal + probChallenge + ...
                            probDate + probRoulette)
                        node = nodeRoulette;
                    end
                end

                path(j, i) = node;
            end
        else
            % Guaranteed nodes
            if (i == posBoss)
                path(:, i) = [nodeBoss; -1];
            elseif (i == posFinalBoss)
                path(:, i) = [nodeFinalBoss; -1];
            elseif (ismember(i, posLoveGambleSplits))

                % First split has a date, second has a romantic evening
                if (i == posLoveGambleSplits(1))
                    % Randomize order
                    if (randi(2) == 1)
                        path(:, i) = [nodeDate; nodeRoulette];
                    else
                        path(:, i) = [nodeRoulette; nodeDate];
                    end
                else
                    % Randomize order
                    if (randi(2) == 1)
                        path(:, i) = [nodeRomanticEvening; nodeRoulette];
                    else
                        path(:, i) = [nodeRoulette; nodeRomanticEvening];
                    end
                end
            end
        end

        % Decrease probNormal, increase probChallenge
        probNormal = probNormal - probDeltaNormalChallenge;
        probChallenge = probChallenge + probDeltaNormalChallenge;
    end
end