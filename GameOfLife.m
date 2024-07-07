prompt = 'choose a mode (0 for user | 1 for automatic): ';
x = input(prompt);

board = init_board(x); % call the board initialization function
printboard(board); % print the initial board

game = input('Do you want to continue? (1 for yes | 0 for no): ');

while (game > 1 || game < 0)
    fprintf('wrong input. try again.\n');
    game = input('Do you want to continue? (1 for yes | 0 for no): ');
end

while game == 1
    board = update_generation(board);
    printboard(board);
    game = input('Do you want to continue? (1 for yes | 0 for no): ');
end

if game == 0
    fprintf('game ended\n');
end

function board = init_board(x)
    row = 30;
    col = 30;
    if (x == 0)
        fprintf('program runs in user mode.\n');
        prompt = 'enter x coordinate for each life file: ';
        xline = input(prompt);
        xlength = length(xline);
        prompt = 'enter the y coordinate for each life file: ';
        yline = input(prompt);
        ylength = length(yline);
        while (xlength ~= ylength) % if invalid
            fprintf('invalid coordinate. try again.\n');
            prompt = 'enter x coordinate for each life file: ';
            xline = input(prompt);
            xlength = length(xline);
            prompt = 'enter the y coordinate for each life file: ';
            yline = input(prompt);
            ylength = length(yline);
        end
        a = [xline; yline];
        fileID = fopen('firstlife.txt', 'w'); % open file to write
        fprintf(fileID, '%s   %s\n\n', 'x', 'y'); % write x and y to fileID
        fprintf(fileID, '%d   %d\n', a); % write the a matrix to fileID
        fclose(fileID); % close the file
        fileID = fopen('firstlife.txt', 'r'); % open file to read
        textscan(fileID, '%d %d');
        fclose(fileID); % close the file
        board = zeros(row, col);
        z = sub2ind(size(board), xline, yline);
        board(z) = 1;
    elseif (x == 1)
        fprintf('programs run in automatic mode.\n');
        xline = randi(row, 1, 90); % random x coordinate for cell. 90 integers
        yline = randi(col, 1, 90); % random y coordinate for cell
        a = [xline; yline];
        fileID = fopen('firstlife.txt', 'w'); % open file to write
        fprintf(fileID, '%s   %s\n\n', 'x', 'y'); % write x and y to fileID
        fprintf(fileID, '%d   %d\n', a); % write the a matrix to fileID
        fclose(fileID); % close the file
        fileID = fopen('firstlife.txt', 'r'); % open file to read
        textscan(fileID, '%d %d');
        fclose(fileID); % close the file
        board = zeros(row, col);
        z = sub2ind(size(board), xline, yline);
        board(z) = 1;
    else % if x is invalid
        fprintf('invalid input. try again.\n');
        prompt = 'choose a mode (0|1): ';
        x = input(prompt);
        board = init_board(x); % call function again
    end
end

function printboard(board)
    figure('Name', 'game of life');
    xlabel('x');
    ylabel('y');
    grid on;
    spy(board, '*');
end

function new_board = update_generation(board)
    [row, col] = size(board); % find out the dementions of this matrix
    new_board = zeros(row, col); % we want our new board to have the same dimensions as the original board but we want this matrix to be full of zeros
    for xline = 1:row
        for yline = 1:col
            % create a neighborhood matrix around the current cell
            neighborhood = reshape(board(max(1, xline-1):min(row, xline+1), max(1, yline-1):min(col, yline+1)), 1, []);
            % count of a given creatures neighbors
            live_neighbors = sum(neighborhood) - board(xline, yline);
            %{
                this line of code is used to find the sum of the matrix of
                the value neighborhood minus the value of the current cell
            %}
            if board(xline, yline) == 1 % if the cell is "alive"
                if live_neighbors < 2 || live_neighbors > 3
                    new_board(xline, yline) = 0; % a creature dies off becaues it is out of range
                else
                    new_board(xline, yline) = 1; % the creature survives because it is in the range of values
                end
            else % If there is no creature
                if live_neighbors == 3
                    new_board(xline, yline) = 1; % a new creature is born
                else
                    new_board(xline, yline) = 0; % no creature is born
                end
            end
        end
    end
end
