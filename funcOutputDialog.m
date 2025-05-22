function dialogText = funcOutputDialog(dialogText, line)
    
    % Initialize variables
    maxChars = 41; % maximum number of characters before wrapping the text
    charInterval = 0.02; % interval of time between the output of each character
    tokens = strsplit(line);
    currentLine = 1;
    currentChars = 0;
    outputLines = strings(length(dialogText));
    
    % Loop through tokens to fill out wrapped lines
    while (~isempty(tokens))
        
        % pop first token
        token = tokens(1);

        if (length(tokens) > 1)
            tokens = tokens(2:end);
        else
            tokens = [];
        end

        % split up token if it's too long for one line
        if (strlength(token) > maxChars)
            tokens = [extractAfter(token, maxChars), tokens];
            token = extractBefore(token, maxChars + 1);
        end
        
        % append token and space
        len = strlength(token);
        
        if (currentChars + len <= maxChars)
            % append if won't go past character limit
            outputLines(currentLine) = outputLines(currentLine) + token + " ";
            currentChars = currentChars + len + 1;
        else
            % goto next line and re-add token to tokens otherwise
            if (currentLine < length(dialogText))
                tokens = [token, tokens];
                currentLine = currentLine + 1;
                currentChars = 0;
            end
            % no else here, we'll just stop outputting. line is too long
        end
    end

    % clear whatever was previously displayed
    for i = 1:length(outputLines)
        set(dialogText(i), 'String', "");
    end

    % build output character-by-character
    for i = 1:length(outputLines)
        finalString = char(outputLines(i));
        currentString = [];

        for j = 1:strlength(finalString)
            pause(charInterval);
            currentString = [currentString, finalString(j)];
            set(dialogText(i), 'String', currentString);
        end
    end
end