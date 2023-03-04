import random

# Define the players and their bets
players = {
    'Lou': 100,
    'David': 200,
    'Dan': 500
}

# Calculate the total amount of money collected
total_money = sum(players.values())

# Calculate the value of each square
square_value = total_money / 100

# Create an empty 10x10 grid to store the assigned squares
grid = [[0 for j in range(10)] for i in range(10)]

# Assign squares to each player based on their bet amount
for player, bet_amount in players.items():
    num_squares = int(bet_amount / square_value)
    for i in range(num_squares):
        # Randomly choose an unassigned square and assign it to the player
        while True:
            row = random.randint(0, 9)
            col = random.randint(0, 9)
            if grid[row][col] == 0:
                grid[row][col] = player
                break

# Print the grid to show the assigned squares
for row in grid:
    print(row)
f
