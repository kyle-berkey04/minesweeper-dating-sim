function gameOver(gameState, playerWon)
   
    % Initialize scene
    scene = gameState.scene;
    width = 10;
    height = 8;
    
    % Prepare and draw canvas
    sprPanel = 31;
    canvas = ones([height, width]);
    canvas(1:3, :) = sprPanel;
    
    scene.drawScene(canvas);
    
    % Create text
    font = 'Helvetica';
    winLossText = text(0.5 * width * gameState.cellSize * scene.zoom, ...
        1.5 * gameState.cellSize * scene.zoom, "", 'FontName', font, ...
        'HorizontalAlignment', 'center', 'FontSize', 60, 'Color', [1 1 1]);

    % Set text to result 
    if (playerWon)
        winLossText.String = "YOU WIN : )";
        scene.background_color = [90 248 113];
    else
        winLossText.String = "YOU LOSE : (";
        scene.background_color = [237 28 36];
    end

    % Initialize buttons
    canvas(5, 3:(width-2)) = sprPanel;
    canvas(7, 3:(width-2)) = sprPanel;
    playAgainText = text(0.5 * width * gameState.cellSize * scene.zoom, ...
        4.5 * gameState.cellSize * scene.zoom, "Start new game", 'FontName', font, ...
        'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', [1 1 1]);
    exitGameText = text(0.5 * width * gameState.cellSize * scene.zoom, ...
        6.5 * gameState.cellSize * scene.zoom, "Quit", 'FontName', font, ...
        'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', [1 1 1]);

    % Fade in
    scene.drawScene(canvas);

    gameState.fadeIn(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);
    
    % Button functionality
    chose = false;
    quittingGame = false;

    while (~chose)
        [my, mx, mb] = scene.getMouseInput();

        if (my == 5 && mx <= (width-2) && mx >= 3)
            % Start new game button
            chose = true;
        elseif (my == 7 && mx <= (width-2) && mx >= 3)
            % Quit game button
            quittingGame = true;
            chose = true;
        end
    end
    
    % Prepare scene for exit
    gameState.fadeOut(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);
    delete(winLossText);
    delete(playAgainText);
    delete(exitGameText);
    scene.background_color = gameState.defaultBGColor;

    % Carry out task
    if (quittingGame)
        % Close the window
        close();
    else
        % Open MSDS
        MSDS();
    end
end