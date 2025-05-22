function [tilesCleared, canvas, canvasForeground] = funcClearThisTile(tileX, tileY, ...
    tilesCleared, canvas, canvasForeground, countMatrix, sprEmpty, sprNumbersStart)
    
    % set tile to empty
    canvas(tileY, tileX) = sprEmpty;
    
    % reveal surrounding mine count
    countAtTile = countMatrix(tileY, tileX);
    
    if (countAtTile > 0)
        canvasForeground(tileY, tileX) = countAtTile + sprNumbersStart;
    else
        canvasForeground(tileY, tileX) = 1; % clears any hints
    end
    
    % increment tilesCleared
    tilesCleared = tilesCleared + 1;
end