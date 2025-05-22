function funcUpdateGameTime(obj, ~)
    
    data = obj.UserData;

    % stops & deletes the timer if the game is closed
    figures = findobj('Type', 'figure');
    if (isempty(figures))
        obj.stop();
        obj.delete();
    end

    % update game time
    obj.UserData.timeElapsed = data.timeElapsed + 1;
    
    % timed click mode
    if (data.timedClickMode)

        % increment time elapsed since last click
        obj.UserData.timeSinceClick = data.timeSinceClick + 1;
        
        % timer has exceeded interval -- force click
        if (obj.UserData.timeSinceClick >= data.forceClickInterval)
            % if just exceeded, make timer red
            if (mod(obj.UserData.timeSinceClick, data.forceClickInterval) == 0)
                obj.UserData.text.Color = [1 0 0];
            else
                % otherwise, make timer yellow
                obj.UserData.text.Color = [1 1 0];
            end
        else
            % if safe, make timer white
            obj.UserData.text.Color = [1 1 1];
        end
    end

    % update display
    time = data.timeElapsed;
    
    minutes = floor(time / 60);
    seconds = mod(time, 60);
    leadingZero = "";

    if seconds < 10
        leadingZero = "0";
    end

    data.text.String = minutes + ":" + leadingZero + seconds;
end