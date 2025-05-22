classdef GameState
    %gameState Keeps track of the game's variables

    properties
        % Essentials
        scene
        defaultZoom
        defaultBGColor
        spritesheet
        cellSize
        
        % Girl
        girlSpritesBackground
        girlSpritesForeground
        girlName
        
        % Path
        path
        pos = 1
        topTrack = true
        
        % Currency
        hints = 3

        % Dating sim
        affinity = 0
        previousAffinity = 0
        affinityRequired = 300
        availableDialog = 1:14 % number of dialog options
        availableDateDialog = 1:5
        availableRomanticEveningDialog = 1:10
    end
    
    methods
        function obj = refreshScene(obj)
            close;
            obj.scene = simpleGameEngine(obj.spritesheet, ...
                obj.cellSize, obj.cellSize, obj.defaultZoom, ...
                obj.defaultBGColor);
        end
    end

    methods (Static)
        function fadeOut(width, height)
            % Create fade out rectangle
            rect = rectangle('Position', [1, 1, 0, height], ...
                'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
            
            % Put rectangle on top layer
            uistack(rect, 'top');
            
            % Animate using cubic ease out function
            for curWidth = linspace(0, width, 60)
                pause(0.01);
                rect.Position = [1, 1, width * (1 - (1 - curWidth/width)^3), height];
            end
            
            % Delete the rectangle
            delete(rect)
        end
        
        function fadeIn(width, height)            
            % Create fade in rectangle
            rect = rectangle('Position', [1, 1, width, height], ...
                'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
            
            % Put rectangle on top layer
            uistack(rect, 'top');

            % Animate using cubic ease out function
            for curWidth = linspace(width, 0, 60)
                pause(0.01);
                rect.Position = [1, 1, width * (1 - (1 - curWidth/width)^3), height];
            end
    
            % Delete the rectangle
            delete(rect);
        end
    end
end