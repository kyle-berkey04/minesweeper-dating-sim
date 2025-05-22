function [minesMatrix, countMatrix] = funcGenerateMinesweeperMatrices( ...
    mx, my, width, height, numMines)
    
    % Initialize matrices
    minesMatrix = zeros(height, width);
    countMatrix = zeros(height, width);

    % Get available indices for mine placement
    availableIndices = 1:(width*height);
    firstTilePos = (mx - 1) * height + my; % convert mouse pos to vector pos
    
    % Initialize where 3x3 safe zone is
    availableIndices(firstTilePos) = -1;
    
    for i = mx-1:mx+1
        for j = my-1:my+1
            curPos = (i - 1) * height + j;
            if (i > 0 && i <= width && j > 0 && j <= height)
                availableIndices(curPos) = -1;
            end
        end
    end

    % Clear safe zone
    i = 1;
    len = length(availableIndices);
    
    while (i <= len)
        if (availableIndices(i) == -1)
            availableIndices(i) = [];
            len = len - 1;
        else
            i = i + 1;
        end
    end


    % Place mines
    for i = 1:numMines
        index = randi(length(availableIndices));
        pos = availableIndices(index);

        minesMatrix(pos) = 1;
        availableIndices(index) = [];
    end

    % Generate countMatrix
    workingMatrix = [repelem(0, width + 2);
        repelem(0, height)', minesMatrix, repelem(0, height)';
        repelem(0, width + 2)];

    for i = 2:(width+1)
        for j = 2:(height+1)
            workingGrid = workingMatrix((j-1):(j+1), (i-1):(i+1));
            countMatrix(j - 1, i - 1) = sum(sum(workingGrid));
        end
    end
end