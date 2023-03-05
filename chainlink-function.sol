pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract Oracle is ChainlinkClient {
    address public owner;
    address public gameBoard;
    uint public currentQuarter;
    uint public teamAScore;
    uint public teamBScore;
    bool public scoreSet;

    event ScoreUpdated(uint quarter, uint teamAScore, uint teamBScore);

    constructor(address _gameBoard) {
        owner = msg.sender;
        gameBoard = _gameBoard;
        currentQuarter = 1;
        teamAScore = 0;
        teamBScore = 0;
        scoreSet = false;

        setChainlinkToken(0x514910771AF9Ca656af840dff83E8264EcF986CA);
        setChainlinkOracle(0xc99B3D447826532722E41bc36e644ba3479E4365);
    }

    function updateScore(bytes32 _jobId, string memory _url, string memory _path) public {
        // Check that the sender is authorized to update the score
        require(msg.sender == owner, "Not authorized to update score");

        // Check that the score has not already been set for the current quarter
        require(!scoreSet, "Score already set for current quarter");

        // Send a Chainlink request to retrieve the score data
        Chainlink.Request memory request = buildChainlinkRequest(_jobId, address(this), this.handleScoreResponse.selector);
        request.add("get", _url);
        request.add("path", _path);
        sendChainlinkRequestTo(getChainlinkOracle(), request, ORACLE_PAYMENT);

        // Mark the score as set to prevent further updates until the next quarter
        scoreSet = true;
    }

    function handleScoreResponse(bytes32 _requestId, uint _score) public recordChainlinkFulfillment(_requestId) {
        // Update the current quarter's score
        if (currentQuarter == 1) {
            teamAScore = _score;
        } else if (currentQuarter == 2) {
            teamBScore = _score;
        } else if (currentQuarter == 3) {
            teamAScore = _score;
        } else if (currentQuarter == 4) {
            teamBScore = _score;
        }

        // Emit a ScoreUpdated event
        emit ScoreUpdated(currentQuarter, teamAScore, teamBScore);

        // Check if the quarter has ended and trigger the determination of the winning square(s) if necessary
        if (currentQuarter == 1 && teamAScore >= 10) {
            gameBoard.determineWinners(currentQuarter, teamAScore, teamBScore);
            currentQuarter += 1;
            scoreSet = false;
        } else if (currentQuarter == 2 && teamBScore >= 10) {
            gameBoard.determineWinners(currentQuarter, teamAScore, teamBScore);
            currentQuarter += 1;
            scoreSet = false;
        } else if (currentQuarter == 3 && teamAScore >= 20) {
            gameBoard.determineWinners(currentQuarter, teamAScore, teamBScore);
            currentQuarter += 1;
            scoreSet = false;
        } else if (currentQuarter == 4 && teamBScore >= 20) {
            gameBoard.determineWinners(currentQuarter, teamAScore, teamBScore);
            currentQuarter += 1;
            scoreSet = false;
        }
    }

    function setGameBoard(address _gameBoard) public {
        // Check that the sender is the owner of the contract
        require(msg.sender == owner, "Not authorized to set game board");

        // Set the game board contract address
        gameBoard = _gameBoard;
    }

    function resetScore() public {
        // Check that the sender is the owner of the contract
        require(msg.sender == owner, "Not authorized to reset score");

        // Reset the current quarter's score and scoreSet flag
        teamAScore = 0;
        teamBScore = 0;
        scoreSet = false;
    }

    function getScore() public view returns (uint, uint) {
        return (teamAScore, teamBScore);
    }
}
