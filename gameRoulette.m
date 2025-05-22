function gameState = gameRoulette(gameState)
    % Initialize variables
    hints = gameState.hints;
    scene = gameState.scene;
    
    % Sprites
    sprRed = 6;
    sprBlack = 42;
    sprGreen = 33;
    sprUpArrow = 43;
    sprDownArrow = 44;
    sprPanel = 31;
    sprButton = [48, 49];

    % Initialize canvas
    width = 10;
    height = 8;
    canvas = ones(height, width);
    canvasForeground = ones(height, width);

    % Initialize wheel
    wheel = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 0];
    wheelSprites = [sprRed, sprBlack, sprRed, sprBlack, sprRed, sprBlack, ...
        sprRed, sprBlack, sprRed, sprBlack, sprRed, sprBlack, sprRed, sprBlack, ...
        sprRed, sprBlack, sprRed, sprBlack, sprGreen];
    wheelVisibleSprites = wheelSprites((19-width+1):19);

    % Initialize UI sprites
    canvasForeground(5, 2:9) = 45:52; % bet display
    canvasForeground(7, 2:4) = [sprGreen, sprRed, sprBlack]; % color selection
    canvasForeground(8, 3) = sprUpArrow; % color indicator
    canvasForeground(height, (width - 3):width) = [sprButton, sprButton]; % buttons
    canvasForeground(3, 3) = sprUpArrow;   % roulette indicator
    canvasForeground(1, 3) = sprDownArrow; %
    canvas(1, 1:width) = sprPanel; % top panel
    canvas(6:height, 1:width) = sprPanel; % bottom panel
    canvas(2, 1:width) = wheelVisibleSprites; % roulette wheel
    scene.drawScene(canvas, canvasForeground);

    % Initialize UI text
    font = 'Helvetica';
    fontMono = 'Consolas';
    betFontSize = 30;
    fontSize = 24;

    betText = text(0.5 * width * gameState.cellSize * scene.zoom, ...
        4.55 * gameState.cellSize * scene.zoom, "1", 'FontName', fontMono, ...
        'Color', [1 1 0], 'HorizontalAlignment', 'center', 'FontSize', ...
        betFontSize);

    balanceText = text(0.5 * width * gameState.cellSize * scene.zoom, ...
        5.5 * gameState.cellSize * scene.zoom, hints + " HINTS", ...
    'FontName', font, 'Color', [1 1 1], 'HorizontalAlignment', 'center', ...
    'FontSize', fontSize, 'FontWeight', 'bold');

    payoutText = text(2.5 * gameState.cellSize * scene.zoom, 5.65 * ...
        gameState.cellSize * scene.zoom, "2x", 'FontName', fontMono, 'Color', ...
        [1 1 1], 'HorizontalAlignment', 'center', 'FontSize', fontSize);

    spinText = text(7 * gameState.cellSize * scene.zoom, (height - 0.5) * ...
        gameState.cellSize * scene.zoom, "Spin", 'FontName', fontMono, 'Color', ...
        [1 1 1], 'HorizontalAlignment', 'center', 'FontSize', fontSize);

    leaveText = text(9 * gameState.cellSize * scene.zoom, (height - 0.5) * ...
        gameState.cellSize * scene.zoom, "Leave", 'FontName', fontMono, 'Color', ...
        [1 1 1], 'HorizontalAlignment', 'center', 'FontSize', fontSize);

    victoryLossText = text(0.5 * width * gameState.cellSize * scene.zoom, ...
        3.5 * gameState.cellSize * scene.zoom, "", 'FontName', fontMono, ...
        'Color', [1 1 1], 'HorizontalAlignment', 'center', 'FontSize', ...
        fontSize);
    
    % Fade in
    gameState.fadeIn(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);

    % Loop
    done = false;
    betColor = 1;
    betAmount = 1;

    while (~done)
        % Wait for left mouse
        [my, mx, mb] = scene.getMouseInput();

        while (mb ~= 1)
            [my, mx, mb] = scene.getMouseInput();
        end
        
        % Clear victory/loss notification if exists
        if (victoryLossText.String ~= "")
            victoryLossText.String = "";
            canvas(4, 3:(width - 2)) = 1;
            scene.drawScene(canvas, canvasForeground);
        end

        % See where clicked
        hereSpr = canvasForeground(my, mx);

        if (my == height && mx >= 7 && mx <= 8 && betAmount > 0 && hints >= betAmount)
            % Spin button

            % Remove hints
            hints = hints - betAmount;
            balanceText.String = hints + " HINTS";

            % Spin the wheel
            spinning = true;
            workingWheelSprites = [wheelSprites, wheelSprites, wheelSprites];
            numSlots = length(wheel);
            curPos = randi(numSlots);
            velocity = randi([30, 60]);
            acceleration = -0.4;
            
            while (spinning)
                % Pause for time inversely proportionate to velocity
                pause(1/(2 * velocity));

                % Reduce velocity, move, add randomness to edge cases
                velocity = max(0, velocity + acceleration);
                if (velocity >= 1 || (velocity < 1 && randi(2) == 1))
                    curPos = curPos + 1;
                end
                
                % Reset position if > numSlots to stay within the array
                if (curPos > numSlots)
                    curPos = curPos - numSlots;
                end
                
                % Update canvas to match wheel position
                canvas(2, :) = workingWheelSprites((numSlots + curPos - 2): ...
                    (numSlots + curPos + width - 3));
                scene.drawScene(canvas, canvasForeground);
                
                % Velocities below 0.5 set to zero
                if (velocity <= 0.5)
                    velocity = 0;
                    spinning = false;
                    result = wheel(curPos);
                end
            end
        
            % Prepare victory/loss notification
            canvas(4, 3:(width-2)) = sprPanel;
            scene.drawScene(canvas, canvasForeground);
            
            % Pay out
            paidOut = 0;

            if (result == betColor)
                % Calculate payout
                if (result == 0)
                    paidOut = betAmount * 14;
                else
                    paidOut = betAmount * 2;
                end
                
                % Victory text
                victoryLossText.String = "YOU WIN! +" + paidOut + " HINTS";
                victoryLossText.Color = [0 1 0];
            else
                % Loss text
                victoryLossText.String = "YOU LOSE!";
                victoryLossText.Color = [1 0 0];
            end
            
            % Add winnings to player balance
            hints = hints + paidOut;
            balanceText.String = hints + " HINTS";

            % Reduce bet amount if now exceeds balance
            if (hints < betAmount)
                betAmount = max(1, hints);
                betText.String = betAmount;
            end
        
        elseif (my == height && mx >= 9 && mx <= width)
            % Leave button
            done = true;

        elseif (my == 7 && mx >= 2 && mx <= 4)
            % Get sprite at mouse position
            hereSpr = canvasForeground(my, mx);
            
            % Move color indicator
            canvasForeground(8, 2:4) = 1;
            canvasForeground(8, mx) = sprUpArrow;

            % Change bet color
            if (hereSpr == sprRed)
                betColor = 1;
                payoutText.String = "2x";
            elseif (hereSpr == sprBlack)
                betColor = 2;
                payoutText.String = "2x";
            else
                betColor = 0;
                payoutText.String = "14x";
            end

            % Draw canvas
            scene.drawScene(canvas, canvasForeground);
        elseif (hereSpr == 45)
            % 0 bet
            betAmount = 1;
            betText.String = betAmount;
        elseif (hereSpr == 46)
            % Half bet
            betAmount = ceil(betAmount / 2);
            betText.String = betAmount;
        elseif (hereSpr == 47)
            % Decrement bet
            if (betAmount > 1)
                betAmount = betAmount - 1;
                betText.String = betAmount;
            end
        elseif (hereSpr == 50)
            % Increment bet
            if (betAmount < hints)
                betAmount = betAmount + 1;
                betText.String = betAmount;
            end
        elseif (hereSpr == 51)
            % Double bet
            betAmount = min(betAmount * 2, max(1, hints));
            betText.String = betAmount;
        elseif (hereSpr == 52)
            % Max bet
            betAmount = max(1, hints);
            betText.String = betAmount;
        end
    end

    % Goto path
    gameState.hints = hints;
    gameState.fadeOut(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);
    delete(betText);
    delete(balanceText);
    delete(payoutText);
    delete(spinText);
    delete(leaveText);
    delete(victoryLossText);
    gameState = funcGotoDestination(gameState, "path");
end