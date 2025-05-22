function [tilesCleared, canvas, canvasForeground] = funcOpenTile(my, mx, canvas, ...
    canvasForeground, tilesCleared, width, height, countMatrix, ...
    sprEmpty, sprTile, sprNumbersStart)

    if (countMatrix(my, mx) ~= 0) % number clicked wasn't a zero -- simple case
        [tilesCleared, canvas, canvasForeground] = funcClearThisTile( ...
                    mx, my, tilesCleared, canvas, canvasForeground, ...
                    countMatrix, sprEmpty, sprNumbersStart);
    else
        % if it was a zero, auto-clear
        tileQueue = [my; mx];
        
        % while there are tiles left to clear
        while (~isempty(tileQueue))
            
            % get current tile's x and y
            currentTile = tileQueue(:, 1)';
            tileQueue = tileQueue(:, 2:end);
            tileX = currentTile(2);
            tileY = currentTile(1);
            
            % if this tile hasn't already been cleared
            if (canvas(tileY, tileX) == sprTile)
                
                % clear the tile
                [tilesCleared, canvas, canvasForeground] = funcClearThisTile( ...
                    tileX, tileY, tilesCleared, canvas, canvasForeground, ...
                    countMatrix, sprEmpty, sprNumbersStart);
                
                % if surrounding mine count is zero, enqueue adjacent tiles
                if (countMatrix(tileY, tileX) == 0)
                    for i = -1:1
                        for j = -1:1

                            % if:
                            %   (1) the tile isn't just the current tile
                            %   (2) the coords fit within the vertical
                            %   bounds
                            %   (3) the coords fit within the horizontal
                            %   bounds
                            if ((i ~= 0 || j ~= 0) && tileY + i > 0 ...
                                    && tileY + i <= height ...
                                    && tileX + j > 0 && tileX + j <= width)
                                
                                % enqueue only if this is a tile
                                if (canvas(tileY + i, tileX + j) == sprTile)
                                    tileQueue = horzcat(tileQueue, [tileY + i; tileX + j]);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end