function gameState = gameDialog(gameState, dialogType)
    
    % Initialize variables
    promptToken = ">";
    choiceToken = "|";
    responseToken = "&";
    totalAffinityPossible = 0;
    affinityEarned = 0;
    
    sprBottomPane = 31;
    sprDarkened = 32;
    sprQuestionMark = 5;
    sprCorrect = 33;
    sprIncorrect = 6;

    % Initialize game canvas and scene
    width = 10;
    height = 8;
    dialogPaneHeight = 3;
    canvas = ones(height, width);
    canvas(end-(dialogPaneHeight - 1):end, :) = sprBottomPane;
    canvasForeground = ones(height, width);
    scene = gameState.scene;
    
    % Change background based on dialog type
    bgTile = 1;

    if (dialogType == 2)
        % Date tiles
        bgTile = 59;
        bgTileAlt = 60;
    elseif (dialogType == 3)
        % Romantic evening tiles
        bgTile = 57;
        bgTileAlt = 58;
        scene.background_color = [63 63 116];
    else
        % Default tiles
        bgTileAlt = 56;
    end

    for i = 1:width
        for j = 1:(height - dialogPaneHeight)
            pos = i + j;
            if (mod(pos, 2) == 0)
                canvas(j, i) = bgTile;
            else
                canvas(j, i) = bgTileAlt;
            end
        end
    end

    % Initialize girl sprite
    girlSpritesBG = gameState.girlSpritesBackground;
    girlSpritesFG = gameState.girlSpritesForeground;
    [girlHeight, girlWidth] = size(girlSpritesBG);
    girlX = ceil((width - girlWidth) / 2);
    girlY = height - dialogPaneHeight - girlHeight;

    canvas(girlY+1:girlY+girlHeight, girlX+1:girlX+girlWidth) = girlSpritesBG;
    canvasForeground(girlY+1:girlY+girlHeight, girlX+1:girlX+girlWidth) = girlSpritesFG;

    % Get dialog index
    if (dialogType == 1 || dialogType == 2 || dialogType == 3)
        % Get correct category of dialog
        if (dialogType == 1)
            totalAffinityPossible = 10;
            availableDialog = gameState.availableDialog;
        elseif (dialogType == 2)
            totalAffinityPossible = 50;
            availableDialog = gameState.availableDateDialog;
        elseif (dialogType == 3)
            totalAffinityPossible = 100;
            availableDialog = gameState.availableRomanticEveningDialog;
        end
        
        % Choose a random piece of available dialog
        if (~isempty(availableDialog))
            % if there's dialog left
            dialogIndex = randi(length(availableDialog));
            currentDialog = availableDialog(dialogIndex);
            availableDialog(dialogIndex) = [];
        else
            % if there's no dialog left
            fprintf("All out of dialog!\n")
            currentDialog = -1;
        end
        
        % Update game state's list of the available dialog
        if (dialogType == 1)
            gameState.availableDialog = availableDialog;
        elseif (dialogType == 2)
            gameState.availableDateDialog = availableDialog;
        elseif (dialogType == 3)
            gameState.availableRomanticEveningDialog = availableDialog;
        end
    end

    % Set total affinity possible for final dialog - pass
    if (dialogType == 6)
        totalAffinityPossible = 1000;
    end

    % Get lines from dialog index
    lines = [];
    
    if (dialogType == 1)
        % Normal dialog
        switch (currentDialog)
            case 1
                lines = ["Hey... I've been thinking about something a lot lately. Can I ask you a question?", "Do you love Big Chugnus?>Yes, I do.|Not really...", "... :-)&Never mind!", "It feels so good to finally say it!&I think we should stop talking.", "Bye!"];
            case 2
                lines = ["I get a lot of questions about this... I hear voices all the time. And see things, like ghosts or dead people or whatever.", "My therapist has been trying to convince me I'm schizophrenic. It's pretty hurtful.", "Do you think she might be right..?>Of course not!|Well...", "See! I knew you'd understand. You're the best : )&What is wrong with you?!", "I gotta go! I can't wait to see you next : )&I'm gonna go..."];
            case 3
                lines = ["What's the integral of arcsin(x)?>xarcsin(x) + √(1-x^2) + C|Why would I know that?", "Wow!!! You're so smart!!!! And handsome too :-)))&Are you stupid?", "You're really the best!&Like... seriously. It's easy dude.", "I'll see you later."];
            case 4
                lines = ["What's 9+10?>21|Something else.", "You stupid.&You suck eggs.", "What's 9+10?>21!|Something else!", "Yeah!&You really suck eggs.", "Bye."];
            case 5
                lines = ["I'm struggling with a puzzle right now, do you mind helping me out?", "If Johnny has 13 apples, what is the mass of the sun?>How the heck are those two related?|6, obviously.", "I know, right?&Dang, way to make me feel like an idiot", "Glad to know I'm not the odd one out!&I'm gonna go ask someone less pompous", "Bye!"];
            case 6
                lines = ["I want to start playing Metal Gear, do you know which game is chronologically first?>MGS:3 Snake Eater, I think|Isn't it MGSV?", "That sounds right!&No, thats the most recent one you dolt", "Thank you, see you around champ&I guess I'll see you later"];
            case 7
                lines = ["Oh man, I've got such a good idea-", "Do you know what I'm thinking?>No, I'm not Psychic|Uh, leafeon is the best eeveelution?", "Good, I was worried for a moment.&That's not even an idea?", "See you around, nerd."];
            case 8
                lines = ["Do you know the muffin man?>Who lives on Drury Lane?|Can't say I'm familiar", "Yeah, Him!&Aw dang it.", "I've been meaning to get an autograph!&I was hoping to get an autograph...", "Aw man, this is gonna be so cool!&Maybe I'll try someone else", "Bye!"];
            case 9
                lines = ["Whats the 6th derrivative of tan(x)?>32sec^2(x)tan^5(x)+416sec^4(x)tan^3(x)+272sec^6(x)tan(x)?|16sec^2(x)tan^4(x)+88sec^4(x)tan^2(x)+16sec^6(x)", "Thanks bro!&No, thats the 5th derivative : (", "I'll catch up with you later"];
            case 10
                lines = ["In Episode V of Starwars, what did Vader say in that climactic moment?>No, I am your father!|Luke, I am your father!", "Nice, I'm impressed you knew that-&The mandela effect strikes again!", "I have to bounce, I'll see you later."];
            case 11
                lines = ["I've got a history trivia tidbit for you","When Pocahontas was baptized, what name was she given?>Rebecca|Jessica", "Nice, I'm impressed you knew that!&Dang, is that too niche?", "I'll go find another trivia question."];
            case 12
                lines = ["Animal trivia time!","Besides elephants and rhinoceroses, what other animals are considered pachyderms?>Hippopotamuses!|Komodo Dragons!", "Nice, thats correct!&Confidently Incorrect!", "Was my hint too obvious?&I thought my hint was obvious enough...","Whatever- I've got more trivia to find!"];
            case 13
                lines = ["MORE TRIVIA!","Which author published the The Interpretation of Dreams?>Sigmund Freud|Max Stirner", "Yup! He was a bit kooky&Wrong German philosipher!", "See ya' round"];
            case 14
                lines = ["I have to ask you-", "What is your favorite game?>Minesweeper!|League of Legends", "Aw, thats my favorite too!&Never played the game before", "I feel I have a special connection to that game.&I'm sure its a good game though-", "Like without it, I would just disappear or something.&Surely you wouldn't dedicate yourself to ragebait, would you?"];
            otherwise
                lines = ["Do you want to see a cool video??", ">Yeah!|No!", "Awesome! https://www.youtube.com/watch?v=bzni5Pr1puA&Don't care!https://www.youtube.com/watch?v=bzni5Pr1puA"];
        end
    elseif (dialogType == 2)
        % Date dialog
        switch (currentDialog)
            case 1
                lines = ["Ever heard of the show Mystery Science Theater 3000? It's an epic comedey where a few people are subjected to the worst, cheesiest movies!", "Doesn't that sound awesome?>Yeah, that sounds like a pretty neat thing!|The only thing I watch are picturebooks read by my parents", "Aww Man, we should watch some together!&I am scared for your wellbeing", "How about we the show a try sometime?>Sounds like a plan!|Uh, no. I have picturebooks to be read to me instead.", "Oh man, this is getting me hyped!&°-°", "&what is wrong with you.", "Ooh- but I don't have a TV this weekend, I uh... 'lost' it...>Hmm, maybe we can watch at a friends place?|I prefer the picturebooks. I prefer when the voices read themselves from inside.", "That sounds awesome!&I'm sorry, do you need help with something? I'm not a licensed therapist.", "I'll see you around then>Sounds like a plan!(x2)|Uh, maybe not.", "Man, I really can't wait!&Do you exist to damper. °-°"];
            case 2
                lines = ["I'm quite interested in philosophy, but I'm very closeted about it", "Would you mind if I ever spent time to share some wisdom with you?>I'll walk that path with you.|Uh, maybe not? Isn't that the thing where people do roids?", "Great, thats reassuring.&Ohh... and WHAT? Thats physiology, like maybe...", "Wait, how much do you actually know about general philosophy?>I-I've heard of Freud!|E=mc^2, right?", "Oh, thats fine, just more time for us to hang out while I teach!&...wrong 'Ph' science.", "Hmm, what if we meet up every once in a while for these lessons?>That sounds lovely!|Sorry, I already have a gym partner.", "Lovely! Wait... why do you find philosophy so interesting?&Your lack of understanding is greatly distressing to me.", "Are you sure you know what philosophy is?>I don't, but I'm excited to learn what excites you!|You said it yourself, thats when you do roids.", "Oh, thats very kind of you.&No! YOU made that up!"];
            case 3
                lines = ["So, do you have any hobbies?", "I suppose you have to, what I meant was-","Do you want to go do something?>I have a foosball table, we could give it a whirl.|No. I prefer abject boredom.", "Never really played before, but that could be fun!&I'm trying to hang out, and you're leaving me hanging.", "If we use this foosball table, can I count on you for the rules?>Sure, it's quite simple though.|If you can't figure out the rules you are a loser.", "Right, thanks for being such a stand up guy.&Why are you like this.", "*you are playing foosball. Would you like to...>Win, but by a small margin|Crush her into the ground", "Dang, I lost. That was close though.&Wow, its like all I can do is get crushed.", "Do you think I did okay for a first time player?>Yeah! Most importantly, was it fun?|No, you are pretty terrible.", "Aw, thank you! Maybe one day I'll best you!&Well there goes my attempt at hanging out together."];
            case 4
                lines = ["Soo.......", "Do you like cats?>Sadly, they don't seem to reciprocate my feelings...|They make good stir-fry!", "I'm sure it can't be that bad... maybe you can try to play with him?&I have a cat you know... I guess I'll still ask-", "Do you want to come over and play with my cat?>Sure, I wouldn't mind some divine fluffs!|Call me Postal Guy, cause that cat is-", "Don't worry, he isn't too shy.&I'm gonna stop you right there.", "I'm sure she'll come right up to you!&I'm not sure our onlooker from beyond the dream knows this reference." "Oh, but do you mind coming over at noon? She doesn't wake early.>I will support his majesty's will.|I make no exceptions for cats.", "Mince is a girl, but I love the spirit!&You're making an exception for me, turd for brains. It's my house.", "Oh, and can you leave your watch at home? She gets hungry...>Sure thing, although that does sound ominous.|I go where I want with what I want.", "Yeah, it sounds weird but Mince ate my Dad's watch. And then our TV. &Your loss ¯\_(ツ)_/¯"];
            case 5
                lines = ["Star Wars is my favorite sci-fi universe. But recently, I feel they're running dry on good, faithful-to-the-original, content.", "Do you know any other good sci-fi universes to expand my horizons?>Hmmm... I enjoy the Warhammmer 40k Universe.|Star-Treck~!", "Huh, never gave it much attention.&Yielding to trekkies is the one thing I must forbid myself from.", "I think what I'm looking for is actually more of a videogame than a show right now.", "Do they have any good related games?>There are actually quite a few good 40k videogames out there.|Uh, I think there is a Star Trek mobile game?", "Huh, I'll have to check them out.&That's a double no! I don't want to be stuck to my screen, least of all as a trekkie.", "I'm looking at this 'Warhammer 40k' stuff and it seems pretty grim.>A Grim Dark universe where stories of trial & triumph are forged.|Yeah that's because Star Trek is better.", "Wow, are you like a salesman or something? That sounded so cool.&I don't know how to tell you this, Star Trek is incompatible with my blood.", "If I get one of these 40k games, will you play it with me?>Sure, I'm partial to 40k Darktide.|Nope, I'll be comfortable on the Starship Enterprise", "Ooh, that one looks fun. Lets do it together!&You are like a summer ant to me."];
            otherwise
                lines = ["Man, I'm bored. I wonder if this is why people make squirrel watching clubs.", "Want to Join a squirrel watching club?>Not particularly, I'm content here with you.|Yes, watching squirrels is my favorite activity!", "Yeah, I don't really see the point.&What, are you boring incarnate?", "Maybe we should form a more unique boredom club.>Sure, sounds like it could be something interesting.|I have dedicated myself to the observation of squirrels.", "Just you and me to start, huh? Got any Ideas?&Did one of them bite you and give you rabies or something?", "Ooh, how about a plane watching club?>That could be cool. We are close to an airport after all.|ǝɯ oʇ ʞɐǝds sʅǝɹɹᴉnbs ǝɥʇ", "Hmm, but I don't really like planes.&Holy moly do you actually have rabies?", "What if instead of aviation, we just watch other people?>Are people really that different from squirrels?|Isn't that just stalking?", "Dang, you are right. Lets stick with aircraft, I don't want to be associated with the squirrel people.&No! Are you calling me a stalker? And here I thought you enjoyed it when I bothered to follow you for 7 hours to initiate a conversation."];    
        end
    elseif (dialogType == 3)
        % Romantic evening dialog
        switch (currentDialog)
            case 1
                lines = ["You ever heard of the Cosmological Argument? It's one of the more convincing arguments for God's existence.", "The Kalam version goes like this: (1) everything that begins to exist has a cause.", "On premise 1?>This is empirically true|You're assuming a linearity of time", "Exactly. You're good at this!&Whatever man. You can look at the Modal Cosmological Argument if you want.", "(2) The universe began to exist>Yeah! The Big Bang!|We can't be certain", "Exactly! We recognize the Big Bang as the beginning of the universe.&Read the science or whatever, but this is a fact dude.", "(3) Therefore, the universe has a cause.>Wow! Incredible|That doesn't make any sense", "It is incredible! The Cosmological Argument is incredible. Our universe is a miracle.&The argument is logically valid -- that is, its conclusion follows from its premises.", "You and I just being here is the result of... everything... It's incredible!&You take issue with the truth of some premise. Clarify your argument or stop wasting my time."];
            case 2
                lines = ["Heaven and Hell – eternal destinations or myths?", "What's your take? Real or not?>Absolutely real, I believe|Just myths, nothing more", "A believer in the beyond! How deep.&Too rational for eternal realms, I see.", "Maybe we'll reach heaven together.&Enjoy your myth-free, dull existence.", "Our love could be heavenly.&No hellish adventure for you, Mr. Practical.", "We're like an angel and a rebel.&I'll keep my myths, you keep your reality.", "An eternal journey awaits us.&Guess you're not joining me on this journey.", "Heavenly conversations with you.&You and your earthly confines – so limited."];
            case 3
                lines = ["The soul's journey – reincarnation or one-time trip?", "Do you believe in reincarnation?>Yes, souls travel through time|No, just one life for us", "A time-traveling soul! We might have met before.&A single-lifer, eh? How unadventurous.", "Our souls might be on an epic journey.&I'll enjoy my multiple journeys, you enjoy your one.", "Maybe we're old souls reconnecting.&One life to live – make it count with me.", "We could have been together in past lives.&Guess you're not into long-term commitments.", "A journey of souls – thrilling!&Living in the now – not bad, but not thrilling.", "Our souls dancing through time.&Your one-shot journey – hope it's worth it."];
            case 4
                lines = ["Angels or demons – who's more misunderstood?", "Your thoughts? Angels or demons?>Angels, they're misjudged|Demons, they're just lost", "Angels! Fellow defender of the misunderstood.&Demons, huh? How dark and edgy of you.", "Maybe we're like two lost angels.&Stick to your dark side then, Mr. Broody.", "Our own angelic adventure awaits.&Enjoy your brooding demonology.", "We'll find our way like angels.&I prefer my angels, you keep your demons.", "Misunderstood beings, like us.&Demons and darkness – not my style.", "Together, we'll uncover mysteries.&You and your demons – have fun in the shadows."];
            case 5
                lines = ["Divine love – real deal or just a fairytale?", "Is divine love possible in real life?>Absolutely, it's everywhere|Just a fairytale, nothing more", "A believer in divine love! How enchanting.&Too cynical for fairytales, I see.", "Maybe we're living a divine love story.&Enjoy your loveless tales, Mr. Realist.", "Our love could be something celestial.&Fairytales not your thing? Too bad.", "We're like a story from the heavens.&No divine spark for you, just cold reality.", "A cosmic romance awaits us.&Guess you don't believe in 'happily ever after'.", "Let's write our own divine story.&You stick to your reality, I'll keep dreaming.", "In a universe of love, we found each other.&In your tale-less world, hope you find something."];
            case 6
                lines = ["Ever thought about the Four Noble Truths of Buddhism?", "Life's truths or not?>Profound truths of life|Just philosophical ideas", "A believer in deeper truths! Let's explore.&Too abstract? They're more than ideas.", "Our connection could be a Noble Truth.&Life's more than just surface-level ideas.", "Let's find our path to enlightenment.&Guess you prefer the shallower waters.", "Together, we can overcome life's suffering.&I'll walk the path, even if you won't.", "Life is a journey of discovery with you.&You stick to the shallow end, I'll dive deep."];
            case 7
                lines = ["In Confucianism, 'li' is about proper conduct, rituals.", "Value in rituals?>Rituals bring order|I'm not into formalities", "A lover of order! We'll create our rituals.&Too cool for tradition? There's beauty in it.", "Let's find our 'li' together.&I'll stick to my rituals, you do your thing.", "Our life could be a beautiful ritual.&Rituals aren't chains, they're dances.", "Together, we'll find harmony in 'li'.&You miss the dance of life in your chaos.", "Every moment with you is a ritual.&Chaos over harmony? That's a choice."];
            case 8
                lines = ["Dogen Zenji spoke of 'just sitting' - Shikantaza.", "Wanna 'just sit' with me?>Let's just sit together|I prefer more action", "A Zen partner! We'll find peace in sitting.&Always on the go? Try pausing for once.", "In stillness, we'll find each other.&Action's good, but stillness has its charm.", "Let's embrace the Zen way, together.&I'll enjoy the stillness, even if you won't.", "Our love can be like a serene meditation.&Always running? You'll miss the beauty of stillness.", "Together, in peaceful silence.&Prefer to run? I'll wait in tranquility."];
            case 9
                lines = ["'Wu wei' in relationships - effortless harmony.", "Sounds ideal?>Effortless love is beautiful|Love needs effort", "Going with the flow! We're in sync.&Effort is good, but don't force it.", "Let's love like water flows.&Always pushing? Let love come naturally.", "Our connection, natural and effortless.&I'll flow, even if you choose to row.", "In our love, let's practice 'wu wei'.&I prefer the natural rhythm, even if you don't.", "Harmony without force. That's us.&You might strain in the current of love."];
            case 10
                lines = ["Zen kōans – mind puzzles that enlighten.", "Enjoy a good kōan?>Love a mental challenge|They're too confusing", "A fellow mind-bender! Let's solve them.&Confused? They're more than riddles.", "We'll puzzle over kōans together.&I'll enjoy the enlightenment, even if you won't.", "Kōans are like love – mysterious.&Prefer clarity? Some things are meant to puzzle.", "Our conversations will be our own kōans.&You stick to the clear path, I'll wander the maze.", "Together, we'll unravel life's mysteries.&Mysteries not your thing? I'll keep pondering."];
        end
    elseif (dialogType == 4)
        % Game over dialog
        lines = ["I uh... I should really go.","And you should stop talking to other people.","They don't like it when you speak."];
    elseif (dialogType == 5)
        % Introduction dialog
        lines = ["Hello I'm " + gameState.girlName + "! :-3", "It's very nice to meet you!"];
    elseif (dialogType == 6)
        % Final dialog - pass
        lines = ["Hey! What's up?>Will you marry me?|Uhh... nothing", "OMG!!!! YES!!!!!&Whatever. I'm leaving you."];
    elseif (dialogType == 7)
        % Final dialog - fail
        lines = ["Hey! What's up?>Will you marry me?|Uhh... nothing", "I wouldn't really be interested in that.&Oh ok... uhm- see you round I guess"];  
    elseif (dialogType == 8)
        % Final dialog - she hates you
        lines = ["Get that stupid look off your face.", "What are you even thinking about?>Will you marry me?|Uhh... nothing.", "God you're an idiot.&Whatever man."];
    end

    % Get destination from dialog type
    destination = "";
    if (dialogType == 4 || dialogType == 6 || dialogType == 7 || dialogType == 8)
        destination = "game_over";
    elseif (dialogType == 5)
        destination = "tutorial";
    end

    % Calculate amount of affinity for each response
    numChoices = 0;

    for i = 1:length(lines)
        numChoices = numChoices + length(strfind(lines(i), choiceToken));
    end

    if (numChoices > 0)
        affinityChange = totalAffinityPossible / numChoices;
    else
        affinityChange = 0;
    end

    % Draw canvas, center window
    scene.drawScene(canvas, canvasForeground);
    movegui('center');

    % Fade in
    gameState.fadeIn(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);

    % Initialize text properties
    fontSize = 24;
    font = 'Consolas'; % USE A MONOSPACE FONT PLEASE for wrapping reasons
    color = [1 1 1];
    choiceColor = [1 1 0];
    vertSep = 0.5 * gameState.cellSize * scene.zoom;
    textX = 0.5 * gameState.cellSize * scene.zoom;
    textY = (height - dialogPaneHeight + 0.5) * gameState.cellSize * scene.zoom;
    choiceTextX = 0.5 * width * gameState.cellSize * scene.zoom;
    choiceTextY = height - 1.5;
    
    % Create text objects
    dialogText = [];
    numDialogTextLines = 5;
    
    for i = 1:numDialogTextLines
        dialogText(i) = text(textX, textY + (i-1)*vertSep, "", 'FontSize', ...
            fontSize, 'Color', color, 'FontName', font, 'Interpreter', 'none');
    end

    choice1Text = text(choiceTextX, choiceTextY * gameState.cellSize * scene.zoom, "", 'FontSize', ...
            fontSize, 'Color', choiceColor, 'FontName', font, ...
            'HorizontalAlignment', 'center', 'Interpreter', 'none');

    choice2Text = text(choiceTextX, (choiceTextY + 1) * gameState.cellSize * scene.zoom, "", 'FontSize', ...
            fontSize, 'Color', choiceColor, 'FontName', font, ...
            'HorizontalAlignment', 'center', 'Interpreter', 'none');
    
    % TODO: remove this
    fprintf("Current affinity: %i\n", gameState.affinity);

    % Output lines
    numLines = length(lines);
    branch = 0;
    i = 1;

    while i <= numLines

        % get current line
        line = lines(i);

        % print line
        isChoice = contains(line, choiceToken);
        isResponse = contains(line, responseToken);

        if (~isChoice)
            if (~isResponse)
                % normal dialog
                dialogText = funcOutputDialog(dialogText, line);
                
                % if there was a sprite indicating success, remove it
                canvasForeground(height, width) = 1;
                scene.drawScene(canvas, canvasForeground);

            else
                % responding to player choice

                % get response break index
                breakAt = strfind(line, responseToken);
                breakAt = breakAt(1);
                
                % get both responses
                response1 = extractBetween(line, 1, breakAt-1);
                response2 = extractBetween(line, breakAt+1, strlength(line));
                
                % output one response
                if (branch)
                    dialogText = funcOutputDialog(dialogText, response1);
                else
                    dialogText = funcOutputDialog(dialogText, response2);
                end
            end

            % wait for mouse input to increment i
            [my, mx, mb] = scene.getMouseInput();
            
            while (mb ~= 1)
                [my, mx, mb] = scene.getMouseInput();
            end

            i = i + 1;
        else
            % if there was a sprite indicating success, remove it
            canvasForeground(height, width) = 1;
            scene.drawScene(canvas, canvasForeground);
            
            % get choices start index
            choicesStartAt = strfind(line, promptToken);
            choicesStartAt = choicesStartAt(1) + 1;

            % get choice break index
            breakAt = strfind(line, choiceToken);
            breakAt = breakAt(1);

            % get both choices
            prompt = extractBefore(line, choicesStartAt - 1);
            choice1 = extractBetween(line, choicesStartAt, breakAt-1);
            choice2 = extractBetween(line, breakAt+1, strlength(line));
            
            % output prompt
            dialogText = funcOutputDialog(dialogText, prompt);

            % output choices
            flipped = randi([0, 1]);
            
            displayChoice1 = choice1;
            displayChoice2 = choice2;

            if (flipped)
                displayChoice1 = choice2;
                displayChoice2 = choice1;
            end
            
            % display choices as text objects
            choice1Text.String = displayChoice1;
            choice2Text.String = displayChoice2;
            
            % update canvas to reflect choice mode
            canvasForeground(height - 1, :) = sprDarkened;
            canvasForeground(height, width) = sprQuestionMark;
            scene.drawScene(canvas, canvasForeground);
            
            % get choice from button press
            [my, mx, mb] = scene.getMouseInput();

            while (mb ~= 1 || my < height - 1)
                [my, mx, mb] = scene.getMouseInput();
            end

            branch = my == height - 1;
            
            if (flipped)
                branch = ~branch;
            end

            % add to affinity (left/A is always positive)
            if (branch)
                affinityEarned = affinityEarned + affinityChange;
                sprIsCorrect = sprCorrect;
            else
                affinityEarned = affinityEarned - affinityChange;
                sprIsCorrect = sprIncorrect;
            end

            % clear choice texts
            choice1Text.String = "";
            choice2Text.String = "";

            % revert canvas, display if they chose the right answer
            canvasForeground(height - 1, :) = 1;
            canvasForeground(height, width) = sprIsCorrect;
            scene.drawScene(canvas, canvasForeground);

            % increment i
            i = i + 1;
        end
    end

    % Handle rewards
    gameState.affinity = gameState.affinity + affinityEarned;
    
    if (totalAffinityPossible ~= 0 && affinityEarned == totalAffinityPossible)
        % Player wins the game if they get all affinity on final dialog
        % with passing total affinity; otherwise, give them a hint if it's
        % a date or romantic evening
        if (dialogType == 6)
            destination = "game_win";
        elseif (dialogType == 2 || dialogType == 3)
            gameState.hints = gameState.hints + 1;
            dialogText = funcOutputDialog(dialogText, "PERFECT!~ +1 hint");
        end
    end
    
    fprintf("Current affinity: %i\n", gameState.affinity);

    % Delete text objects
    pause(1);
    gameState.fadeOut(width * gameState.cellSize * scene.zoom, ...
        height * gameState.cellSize * scene.zoom);
    delete(dialogText);
    delete(choice1Text);
    delete(choice2Text);
    scene.background_color = gameState.defaultBGColor;

    % TODO: go to actual destination

    if (destination == "")
        gameState = funcGotoDestination(gameState, "path");
    elseif (destination == "game_over")
        gameOver(gameState, false);
    elseif (destination == "game_win")
        gameOver(gameState, true);
    elseif (destination == "tutorial")
        gameState = funcGotoDestination(gameState, "minesweeper", "tutorial");
    end
end