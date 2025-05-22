function [tileY, tileX] = funcGetHintPos(canvas, canvasForeground, minesMatrix, width, height, ...
    sprTile, sprHintTile, sprEmpty, sprFlag)
    
    % if can't find a valid hint position, this will be outputted
    tileY = -1;
    tileX = -1;
    
    % find available positions
    availablePositions = canvas(1:height, 1:width) == sprTile | ...
        canvas(1:height, 1:width) == sprFlag;
    availablePositions(canvasForeground(1:height, 1:width) == sprHintTile) = 0;
    availablePositions(minesMatrix == 1) = 0;
    
    % get cleared matrix
    clearedMatrix = canvas(1:height, 1:width) == sprEmpty;
    clearedMatrix = [repelem(0, width + 2); repelem(0, height)', ...
        clearedMatrix, repelem(0, height)'; repelem(0, width + 2)];
    
    % get border matrix
    borderMatrix = zeros(height, width);

    for i = 2:(width+1)
        for j = 2:(height+1)
            workingGrid = clearedMatrix((j-1):(j+1), (i-1):(i+1));
            borderMatrix(j - 1, i - 1) = sum(sum(workingGrid)) > 0;
        end
    end
    
    borderMatrix = borderMatrix & availablePositions;

    % get available indices from available positions
    availableIndices = find(availablePositions == 1);
    borderIndices = find(borderMatrix == 1);

    % choose random index
    if (~isempty(borderIndices))
        pos = borderIndices(randi(length(borderIndices)));
    elseif (~isempty(availableIndices))
        pos = availableIndices(randi(length(availableIndices)));
    end

    % convert (linear) position to matrix index
    if (~isempty(borderIndices) || ~isempty(availableIndices))
        tileY = mod(pos - 1, height) + 1;
        tileX = ceil(pos / height);
    end

end