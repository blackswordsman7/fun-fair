// test/TestGamesOnStakes4.sol
pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GamesOnStakes.sol";
import "../contracts/StringSupport.sol";

contract TestGamesOnStakes4 {
    GamesOnStakes gamesInstance;
    uint public initialBalance = 1 ether;

    constructor() public {
        gamesInstance = GamesOnStakes(DeployedAddresses.GamesOnStakes());
    }

    // @dev - Winner  withdraws the winning amount
    function testWinnerWithdrawal() public {
        uint8[9] memory cells;
        uint8 status;
        uint amount;
        string memory nick1;
        string memory nick2;

        bytes32 hash = gamesInstance.saltedHash(100, "my salt goes here");
        uint32 gameIdx = gamesInstance.createGame.value(0.01 ether)(hash, "Sachin");
        gamesInstance.acceptGame.value(0.01 ether)(gameIdx, 234, "Sanchay");
        gamesInstance.confirmGame(gameIdx, 100, "my salt goes here");

        // Both the players play the game
        gamesInstance.markPosition(gameIdx, 0); // player 2
        gamesInstance.markPosition(gameIdx, 2); // player 1
        gamesInstance.markPosition(gameIdx, 3); // player 2
        gamesInstance.markPosition(gameIdx, 4); // player 1
        gamesInstance.markPosition(gameIdx, 6); // player 2

        (cells, status, amount, nick1, nick2) = gamesInstance.getGameInfo(gameIdx);
        Assert.equal(uint(status), 11, "The game should be won by player 1");


        uint balancePre = address(this).balance;
        gamesInstance.withdraw(gameIdx);
        uint balancePost = address(this).balance;

        Assert.equal(balancePre + 0.02 ether, balancePost, "Withdrawal should have transfered 0.02 ether to the player 1");
    }

    function testDrawWithdrawal() public {
        uint8[9] memory cells;
        uint8 status;
        uint amount;
        string memory nick1;
        string memory nick2;

        bytes32 hash = gamesInstance.saltedHash(100, "my salt goes here");
        uint32 gameIdx = gamesInstance.createGame.value(0.01 ether)(hash, "Sachin");
        gamesInstance.acceptGame.value(0.01 ether)(gameIdx, 234, "Sanchay");
        gamesInstance.confirmGame(gameIdx, 100, "my salt goes here");

        // Both the players play the game

        gamesInstance.markPosition(gameIdx, 0); // player 2
        gamesInstance.markPosition(gameIdx, 2); // player 1
        gamesInstance.markPosition(gameIdx, 4); // player 2
        gamesInstance.markPosition(gameIdx, 8); // player 1
        gamesInstance.markPosition(gameIdx, 5); // player 2
        gamesInstance.markPosition(gameIdx, 3); // player 1
        gamesInstance.markPosition(gameIdx, 7); // player 2
        gamesInstance.markPosition(gameIdx, 1); // player 1
        gamesInstance.markPosition(gameIdx, 6); // player 2

        (cells, status, amount, nick1, nick2) = gamesInstance.getGameInfo(gameIdx);
        Assert.equal(uint(status), 10, "The game should end in draw");

        uint balancePre = address(this).balance;
        gamesInstance.withdraw(gameIdx);                        
        uint balancePost = address(this).balance;

        Assert.equal(balancePre + 0.01 ether, balancePost, "Withdrawal should have transfered 0.01 ether");
        
    }
}