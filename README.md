# Smart-Squares# A Super Bowl squares Smart Contract Project


##Project Overview
Create Ethereum powered smart contract that would decentralize and automate a game of "Super Bowl Squares"
* Users would send Eth to the contract, claiming a proportion of the available squares equal to the proportion of their contribution.
## Contract Logic and Backend Components
* 1) determine squares awarded to each player proportional to amount sent to contract
* 2) randomly assign grid at kickoff
* 3) use oracle to pull off-blockchain data including game score to use in smart contract logic and determine winners
* 4) pay Eth back to address of origin at end of 1st, 2nd, 3rd and 4th quarters

## UI and Front End Components
* user would interact with the contract accessing front end webpage from  browser with metamask.
* page will display grid, list of players and proportions, payout proportions
*+* button to join the game would ask user for amount to send and name for the sare
* -Potential Issues/Concerns:
    * worry about rounding down
    * spamming the contract
* -Advanced: make open source/modular to any football game

### More Resources
• [Super Bowl Squares Rules](http://keithlam.com/2006/02/07/football-squares-pool/)
* ![SSSC Image](img/SSSCWinnerGraphic.png)

