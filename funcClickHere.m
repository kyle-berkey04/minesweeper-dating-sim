function [canvas, canvasForeground, gameOver, msg, minesLeftText, ...
    tilesCleared] = funcClickHere(tileX, tileY, width, height, minesMatrix, ...
    canvas, canvasForeground, sprFlag, sprMine, lines, msg, gameOver, ...
    sprEmpty, sprNumbersStart, tilesCleared, minesLeftText, countMatrix, ...
    tilesNeeded, sprTile)
    
    if (minesMatrix(tileY, tileX) == 1) % clicked on mine
        % reveal all mines
        for i = 1:width
            for j = 1:height
                if (minesMatrix(j, i) == 1 && canvas(j, i) ~= sprFlag)
                    canvas(j, i) = sprMine;
                end
            end
        end
        
        % basically the loss condition
        tilesCleared = 0;
    
        % end the game
        gameOver = true;
    
    else % clicked on safe tile
        
        % clear tile(s)
        [tilesCleared, canvas, canvasForeground] = funcOpenTile( ...
            tileY, tileX, canvas, canvasForeground, tilesCleared, ...
            width, height, countMatrix, sprEmpty, ...
            sprTile, sprNumbersStart);
    
        % update message
        adjustedProgressRatio = (exp(2 * tilesCleared/tilesNeeded) - 1)/(exp(2) - 1);
        lineIndex = round(adjustedProgressRatio * (length(lines) - 4)) + 2;
        msg.String = lines(lineIndex);
        
        % win condition
        if (tilesCleared == tilesNeeded)
            gameOver = true;
            msg.String = lines(end - 1);
            minesLeftText.String = "";
        end
    end
end