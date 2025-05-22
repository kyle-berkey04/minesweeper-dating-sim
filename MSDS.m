%% MSDS
% Initialize game state
clear;
clc;
close;

gameState = GameState();

% Initialize variables
gameState.spritesheet = "spritesheet.png";
gameState.cellSize = 16;
gameState.defaultZoom = 5;
gameState.defaultBGColor = [255, 191, 202];

% Initialize game scene
gameState.scene = simpleGameEngine(gameState.spritesheet, ...
    gameState.cellSize, gameState.cellSize, gameState.defaultZoom, ...
    gameState.defaultBGColor);

% Generate girl
gameState.girlSpritesBackground = [15, 16, 17, 18; 19, 20, 21, 22; 23, 24, 25, 26; 27, 28, 29, 30];
gameState.girlSpritesForeground = ones(4, 4);
potentialNames = ["Jebby", "Jebecky", "Jelizabeth", "Jclair", ...
    "Jeniqua","Garfield","Jrandma","Jofia"];
gameState.girlName = potentialNames(randi(size(potentialNames)));
fprintf("Her name is %s.\n", gameState.girlName);

% Generate path
gameState.path = funcGeneratePath(16);

% Open introductory dialog
gameState = funcGotoDestination(gameState, "dialog", "introduction");