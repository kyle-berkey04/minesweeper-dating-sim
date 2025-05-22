%% Minesweeper
function gameState = gamePath(gameState)

    % Initialize variables
    pathLength = length(gameState.path);
    levelChosen = 1;
    levelSelected = false;
    horizontalPadding = 3;
    nodesVisible = 4;

    sprTopPane = 31;
    sprBottomPane = 32;
    sprAffinityBarTop = 53;
    sprAffinityBarMid = 54;
    sprAffinityBarBot = 55;

    % 1 - normal level 
    % 2 - challenge level 
    % 3 - boss level 
    % 4 - final boss
    % 5 - roulette
    % 6 - date
    % 7 - romantic evening
    % -1 - nothing
    
    % Set to whatever ideal game path is, just made up one for now
    pathNodes = gameState.path;
    spriteNodes = pathNodes;
    stringNodes = strings(size(pathNodes));
    
    % Pad spriteNodes with empty space
    for i = 1:horizontalPadding
        spriteNodes = [[-1; -1], spriteNodes, [-1; -1]];
    end

    % Get player's current node
    playerNode = [1 + ~gameState.topTrack, gameState.pos];
    playerVisibleNode = [1 + ~gameState.topTrack, 1];
    
    % Get next accessible node
    nextNodeX = playerVisibleNode(2) + 1;
    nextNodeY = 1 + ~gameState.topTrack;

    if (pathNodes(2, gameState.pos) == -1 || pathNodes(2, gameState.pos + 1) == -1)
        nextNodeY = 0;
    end

    % set to sprite values
    for i = 1:((pathLength + horizontalPadding * 2) * 2)
        switch (spriteNodes(i))
            case 1
                % normal level
                spriteNodes(i) = 35;
            case 2
                % challenge level
                spriteNodes(i) = 38;
            case 3
                % boss level
                spriteNodes(i) = 39;
            case 4
                % final boss level
                spriteNodes(i) = 41;
            case 5
                % slots
                spriteNodes(i) = 37;
            case 6
                % date
                spriteNodes(i) = 36;
            case 7
                % romantic evening
                spriteNodes(i) = 40;
            otherwise
                %blank
                spriteNodes(i) = 1;
        end
    end
    
    % Set string values for string nodes
    for i = 1:(pathLength*2)
        switch (pathNodes(i))
            case 1
                stringNodes(i) = "NORMAL LEVEL";
            case 2
                stringNodes(i) = "CHALLENGE LEVEL";
            case 3
                stringNodes(i) = "MEGA CHALLENGE LEVEL";
            case 4
                stringNodes(i) = "ULTIMATE FINAL MEGA CHEGA CHALLENGE LEVEL";
            case 5
                stringNodes(i) = "ROULETTE";
            case 6
                stringNodes(i) = "A PLEASANT DATE";
            case 7
                stringNodes(i) = "A ROMANTIC EVENING";
            otherwise
                stringNodes(i) = "WHAT";
        end
    end

    % Initialize which nodes are actually visible
    numNextPathNodes = min(nodesVisible - 1, length(pathNodes) - gameState.pos);

    visibleSpriteNodes = spriteNodes(1:2,gameState.pos + horizontalPadding ...
        :gameState.pos + horizontalPadding + (nodesVisible - 1));
    visiblePathNodes = pathNodes(1:2, gameState.pos ...
        :gameState.pos + numNextPathNodes);

    % Make player's node sprite special
    visibleSpriteNodes(playerVisibleNode(1), playerVisibleNode(2)) = 4;
    
    % Initialize game canvas and scene
    width = 10;
    height = 8;
    canvas = ones(height, width);
    canvasForeground = ones(height, width);
    
    % Put nodes on the canvas
    for i = 1:length(visibleSpriteNodes)
        
        if (visibleSpriteNodes(2, i) == 1)
            % only one node, so place in center
            canvas(5, 2 * i) = visibleSpriteNodes(1, i);
        else
            % place two nodes if two available
            canvas(4, 2 * i) = visibleSpriteNodes(1, i);
            canvas(6, 2 * i) = visibleSpriteNodes(2, i);
        end

    end
    
    % Bottom and top panes
    canvasForeground(1:2, 1:width) = sprTopPane;
    canvasForeground(height, 1:width) = sprBottomPane;

    % Alias game state scene
    scene = gameState.scene;

    % Draw canvas
    scene.drawScene(canvas, canvasForeground);

    % Instantiate text objects
    font = 'Helvetica';
    choiceFont = 'Consolas';

    instructionsText = text(0.5 * width * gameState.cellSize * scene.zoom, ...
        (height - 0.5) * gameState.cellSize * scene.zoom, "Choose a node...", ...
        "HorizontalAlignment", "center", "FontName", font, "FontSize", ...
        24, "Color", [1 1 1], "FontWeight", "bold");


    % Create lines
    lines = [];
    choices = [];

    for i = 1:(length(visiblePathNodes) - 1)
        % Get number of nodes in current set and number in next set
        thisHeight = 1 + (visiblePathNodes(2, i) ~= -1);
        nextHeight = 1 + (visiblePathNodes(2, i + 1) ~= -1);
        
        % Create 2 lines if either height is 2
        for j = 1:max(thisHeight, nextHeight)
            
            % Set end heights for the lines
            if (nextHeight > 1)
                endY = 2 + 2*j;
            else
                endY = 5;
            end
            
            % Set start heights for the lines
            if (thisHeight > 1)
                startY = 2 + 2*j;
            else
                startY = 5;
            end
            
            % Set visual positions for the lines (in graph coordinates)
            from = [(i * 2) * gameState.cellSize * scene.zoom, (startY - 0.5) * gameState.cellSize * scene.zoom];
            to = [(i * 2 + 1) * gameState.cellSize * scene.zoom, (endY - 0.5) * gameState.cellSize * scene.zoom];
            
            % Create the line
            lines = [lines, line([from(1), to(1)], [from(2), to(2)], 'Color', [0.5 0.5 0.5], ...
                'LineWidth', 4)];
            
            % Highlight lines to nodes the player has access to
            if (nextNodeX == i + 1 && (thisHeight == 1 || ...
                    (j == nextNodeY && nextHeight == 2) || ...
                    (thisHeight == 2 && j == playerVisibleNode(1) && nextHeight == 1)))
                % Store potential choices for text display
                if (nextHeight > 1)
                    choices = [choices, j];
                else
                    choices = [choices, 1];
                end

                % Highlight the line
                set(lines(end), 'Color', [1 1 1]);
            end
        end
    end

    % Display choices explicitly with text objects
    choicesText = [];
    if (length(choices) == 2)

        % Text for two options
        choice1 = stringNodes(1, gameState.pos + 1);
        choice2 = stringNodes(2, gameState.pos + 1);

        choicesText(1) = text(0.5 * width * gameState.cellSize * scene.zoom, ...
            (0.5) * gameState.cellSize * scene.zoom, choice1, ...
            "HorizontalAlignment", "center", "FontName", choiceFont, "FontSize", ...
            24, "Color", [1 1 0]);
    
        choicesText(2) = text(0.5 * width * gameState.cellSize * scene.zoom, ...
            (0.95) * gameState.cellSize * scene.zoom, "or", ...
            "HorizontalAlignment", "center", "FontName", font, "FontSize", ...
            24, "Color", [1 1 1]);
    
        choicesText(3) = text(0.5 * width * gameState.cellSize * scene.zoom, ...
            (1.5) * gameState.cellSize * scene.zoom, choice2, ...
            "HorizontalAlignment", "center", "FontName", choiceFont, "FontSize", ...
            24, "Color", [1 1 0]);
    else
        
        % Text for one option
        choice1 = stringNodes(choices(1), gameState.pos + 1);
        choicesText(1) = text(0.5 * width * gameState.cellSize * scene.zoom, ...
            (1) * gameState.cellSize * scene.zoom, choice1, ...
            "HorizontalAlignment", "center", "FontName", choiceFont, "FontSize", ...
            24, "Color", [1 1 0]);
    end
    
    % Draw affinity bar sprites
    for i = 3:(height-1)
        if (i == 3)
            canvasForeground(i, width) = sprAffinityBarTop;
        elseif (i == height-1)
            canvasForeground(i, width) = sprAffinityBarBot;
        else
            canvasForeground(i, width) = sprAffinityBarMid;
        end
    end

    % Draw affinity amount as red bar
    xBar = ((width * gameState.cellSize) - 9) * scene.zoom;
    barWidth = 1 * scene.zoom;
    yBarBottom = (((height - 1) * gameState.cellSize) - 2) * scene.zoom;
    yBarTop = ((2 * gameState.cellSize) + 2) * scene.zoom;
    barHeight = yBarBottom - yBarTop;
    requiredBarHeight = yBarBottom - 3 * gameState.cellSize * scene.zoom;
    
    affinityBarHeight = requiredBarHeight * (gameState.affinity/gameState.affinityRequired);
    affinityBarHeight = floor(min(barHeight, max(0, affinityBarHeight)));
    affinityBarHeightCurrent = requiredBarHeight * (gameState.previousAffinity/gameState.affinityRequired);
    affinityBarHeightCurrent = floor(min(barHeight, max(0, affinityBarHeightCurrent)));
    affinityBarTopCurrent = yBarTop + barHeight - affinityBarHeightCurrent;
    affinityBar = rectangle('Position', [xBar, affinityBarTopCurrent, barWidth, ...
        affinityBarHeightCurrent], 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0]);
    
    % Draw line at threshold
    affinityRequiredLine = line([xBar - 4 * scene.zoom, xBar + barWidth + 4 * scene.zoom], ...
        [3 * gameState.cellSize * scene.zoom, 3 * gameState.cellSize * scene.zoom], 'LineWidth', 4, ...
        'Color', [1 1 1]);

    % Change color of bar if past threshold
    if (gameState.affinity >= gameState.affinityRequired)
        affinityBar.FaceColor = [0.5 0 1];
        affinityBar.EdgeColor = [0.5 0 1];
    else
        affinityBar.FaceColor = [1 0 0];
        affinityBar.EdgeColor = [1 0 0];
    end

    % Set previous affinity to current affinity
    gameState.previousAffinity = gameState.affinity;

    % Update scene
    scene.drawScene(canvas, canvasForeground);

    % Fade in
    gameState.fadeIn(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);

    % Animate the affinity bar
    isCurrentBelow = affinityBarHeightCurrent < affinityBarHeight;

    while (abs(affinityBarHeightCurrent - affinityBarHeight) > 1)
        % Grow if affinity grew, shrink if affinity shrunk
        pause(0.0125 + 1/(4*(affinityBarHeightCurrent - affinityBarHeight)^2));
        if (isCurrentBelow)
            % Decrement top, increment height
            affinityBarTopCurrent = affinityBarTopCurrent - 1;
            affinityBarHeightCurrent = affinityBarHeightCurrent + 1;
        else
            % Increment top, decrement height
            affinityBarTopCurrent = affinityBarTopCurrent + 1;
            affinityBarHeightCurrent = affinityBarHeightCurrent - 1;
        end
        affinityBar.Position(2) = affinityBarTopCurrent;
        affinityBar.Position(4) = affinityBarHeightCurrent;
    end

    % Get user choice for level
    while (~levelSelected)
        [my, mx, mb] = scene.getMouseInput();
        
        % player clicks a level
        if ((4 <= my && 6 >= my) && canvas(my,mx) ~= 1 && mb == 1)
            
            % convert mouse position to node position
            nodeX = floor(mx / 2);
            if (my < 6)
                nodeY = 1;
            else
                nodeY = 2;
            end
            
            % can only click accessible nodes
            if (nodeX == nextNodeX && (nodeY == nextNodeY || nextNodeY == 0))
                levelChosen = visiblePathNodes(nodeY, nodeX);
                levelSelected = true;

                % update position
                gameState.pos = gameState.pos + 1;
                gameState.topTrack = nodeY == 1;
            end
        end
    end

    % update scene
    scene.drawScene(canvas, canvasForeground);
    
    % prepare to close scene
    gameState.fadeOut(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);
    delete(instructionsText);
    delete(choicesText);
    delete(lines);
    delete(affinityBar);
    delete(affinityRequiredLine);
    
    % launch new level, not sure of intended difference for level
    % difficulty
    
    switch (levelChosen)
        case 1
            % normal level
            gameState = funcGotoDestination(gameState, "minesweeper", "normal");
        case 2
            % challenge level
            gameState = funcGotoDestination(gameState, "minesweeper", "challenge");
        case 3
            % boss level
            gameState = funcGotoDestination(gameState, "minesweeper", "boss");
        case 4
            % final boss level
            gameState = funcGotoDestination(gameState, "minesweeper", "final_boss");
        case 5
            % roulette level
            gameState = funcGotoDestination(gameState, "roulette");
        case 6
            % date
            gameState = funcGotoDestination(gameState, "dialog", "date");
        case 7
            % romantic evening
            gameState = funcGotoDestination(gameState, "dialog", "romantic_evening");
        otherwise
            %blank
    end
end