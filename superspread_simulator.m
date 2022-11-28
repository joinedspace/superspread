function [nalive, V, nimmu, iter] = monte_carlo_spread_simulation

percentvect = linspace(0,0.98,100); % the percents for iteration
pvaci_set = [1, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90];
survival_vector = zeros(1,11); % will fill this in over the loop
array_ct = 1; % positioning for survival vector

for pvaci = pvaci_set
    tic
    %% -----------------
    %% Definitions
    %% -----------------

    N = 128;        % grid size: N*N
    T = 15;         % scaled time to become immunized/recovered
    Nitermax = 5000;    % max iterations (for timeout purposes)

    density = 0.5;  % density of population
    prob = 0.75;     % probability of infection: USER ENTRY!
    pvac = percentvect(pvaci); % fraction of population vaccinated (the loop)

    M = floor(density*N^2);     % population size
    V = floor(pvac*M);

    plot_flag = 1;

    %% -----------------
    %% Initialization
    %% -----------------

    infect = zeros(M,1);
    % infect takes the values: 0 (healthy); 1 (actively infected);
    %                          2 (immunized); 3 (dead)
    hours = T*ones(M,1);  % hours gets initialized to T upon infection and
    % decreases by 1 every iteration until hours==0,
    % which implies immunization

    % initialize the population starting positions randomly
    x = randi(N,M,1);
    y = randi(N,M,1);

    % immunize relative to the population vaccinated initially
    infect(randperm(M,V)) = 2;

    % infect a random individual to begin
    z = randi(M); infect(z) = 1;

    ninfected = 1;   % first infected individual
    iter = 1;       % about to start first iteration


    %% -----------------
    %% Random walk
    %% -----------------

    while ninfected > 0 && iter < Nitermax

        % count infection countdowns and deaths before taking a random step
        hours(infect==1) = hours(infect==1) - 1;

        % does the infected individual survive?
        infect(hours==0) = 3;
        nimmu = sum(infect==3);

        % random walk
        rand_walk = rand(M,1);
        walk_x = rand_walk < 0.5;
        walk_y = rand_walk >= 0.5;

        % walk in the x direction
        deltax = 2*floor(2*rand(size(x))) - 1;  % random directions
        deltax(infect==3) = 0;  % the dead don't move
        deltax(walk_y) = 0;
        xold = x;
        xnew = x + deltax;

        % periodic boundary conditions
        xnew(xnew==0) = N;
        xnew(xnew==N+1) = 1;
        x = xnew;

        % walk in the y direction
        deltay = 2*floor(2*rand(size(x))) - 1;  % random directions
        deltay(infect==3) = 0;  % the dead don't move
        deltay(walk_x) = 0;
        yold = y;
        ynew = y + deltay;

        % periodic boundary conditions
        ynew(ynew==0) = N;
        ynew(ynew==N+1) = 1;
        y = ynew;

        % contamination step
        H_coord = zeros(M,2); % because we need to keep track of positions
        pos_H = infect==0;
        H_coord(pos_H,:) = [x(pos_H), y(pos_H)]; % positions of healthy people

        pos_I = infect==1;
        I_coord = [x(pos_I), y(pos_I); xold(pos_I), yold(pos_I)];
        % positions of infected individuals, before and after random step

        indH = find( ismember(H_coord,I_coord,'rows') == 1);
        % indH are the "j-positions" of the healthy population who are
        % getting infected (infect(j) = 0 -> 1 for j in indH)

        infection_status = (rand(size(indH)) < prob); % true = gets infected
        infect(indH) = infection_status;
        ninfected = sum(infect==1);

        % exit if overflow
        iter = iter + 1;
        if iter == Nitermax
            fprintf('Maximum number of iterations reached; increase Nitermax')
        end

        % visualization in 2D
        if plot_flag == 1
            colorgrid = 4*ones(N);
            map = [ 0, 1, 0;    % healthy = green
                1, 0, 0;    % actively infected = red
                0, 0, 1;    % immunized = blue
                0, 0, 0;    % dead = black
                1, 1, 1];   % empty = white
            for i=1:M
                colorgrid(x(i),y(i)) = infect(i);
            end
            g = pcolor(colorgrid); colormap(map); axis square;
            set(g,'LineStyle','none');
            set(gca,'XDir','normal')
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);
            title(append(num2str(pvaci), ...
                '% initially vaccinated, spread probability ', ...
                num2str(prob)));
            colorbar('Ticks',[2/5 6/5 2 14/5 18/5], ...
                'TickLabels',["healthy" "infected" "immunized" ...
                "dead" "none (empty)"], 'fontsize', 14)
            set(gca,'fontsize', 14);
            drawnow
        end

    end

    nalive = M - nimmu; % alive population

    survival_rate = nalive/M;
    death_rate = 1 - survival_rate;

    survival_vector(array_ct) = round(survival_rate*100, 1);
    array_ct = array_ct + 1;

    disp(append("Trial: ", num2str(pvaci), "% immunized"))
    disp(append("Survival rate for simulation: ", num2str(survival_rate)))
    disp(append("Death rate for simulation: ", num2str(death_rate)))
end

% plotting the results
plot(pvaci_set, survival_vector, 'k', 'LineWidth', 2);
title(append("Survival rates & initial % vaccinated, w/ spread ", ...
    "probability ", num2str(prob)))
xlabel('Initial % vaccinated'); ylabel('Survival rate');
ytickformat('percentage');
ylim([0 105]);
set(gca,'fontsize', 14);
end