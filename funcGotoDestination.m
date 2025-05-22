function gameState = funcGotoDestination(gameState, destination, flag)
    switch (destination)
        case "minesweeper"
            switch (flag)
                case "normal"
                    size = 8 + floor(gameState.pos / 3);
                    gameState = gameMinesweeper(gameState, size, size, 0.12, flag);
                case "tutorial"
                    gameState = gameMinesweeper(gameState, 6, 6, 0.1, flag);
                case "challenge"
                    size = 12 + max(0, floor(gameState.pos / 3) - 2);
                    gameState = gameMinesweeper(gameState, size, size, 0.15, flag);
                case "boss"
                    gameState = gameMinesweeper(gameState, 20, 16, 0.2, flag);
                case "final_boss"
                    gameState = gameMinesweeper(gameState, 32, 16, 0.25, flag);
                otherwise
                    fprintf("ERROR: need a flag for minesweeper destination");
            end
        case "dialog"
            switch (flag)
                case "normal"
                    gameState = gameDialog(gameState, 1);
                case "date"
                    gameState = gameDialog(gameState, 2);
                case "romantic_evening"
                    gameState = gameDialog(gameState, 3);
                case "game_over"
                    gameState = gameDialog(gameState, 4);
                case "introduction"
                    gameState = gameDialog(gameState, 5);
                case "final_pass"
                    gameState = gameDialog(gameState, 6);
                case "final_fail"
                    gameState = gameDialog(gameState, 7);
                case "final_hate"
                    gameState = gameDialog(gameState, 8);
                otherwise
                    fprintf("ERROR: need a flag for dialog destination");
            end
        case "path"
            gameState = gamePath(gameState);
        case "roulette"
            gameState = gameRoulette(gameState);
        otherwise
            fprintf("ERROR: destination does not exist");
    end
end