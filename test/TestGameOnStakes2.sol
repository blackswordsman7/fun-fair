// test/TestGamesOnStakes1.sol
pragma solidity ^0.5.0;

import "truffle/Assert.sol";

import "../contracts/GamesOnStakes.sol";
import "../contracts/StringSupport.sol";

contract TestGamesOnStakes2 {
    GamesOnStakes gamesInstance;

    constructor() public {
        gamesInstance = GamesOnStakes(DeployedAddresses.GamesOnStakes());
    }

    // function testInitiallyEmpty() public {
    //     Assert.equal(gamesInstance.getOpenGames().length, 0, "The games array should be empty at the begining");
    // }

    // function testHashingFunction() public {
    //     string memory hash1 = gamesInstance.saltedHash(123, "my salt goes here");
    //     string memory hashA = StringSupport.saltedHash(123, "my salt goes here");

    //     string memory hash2 = gamesInstance.saltedHash(123, "my salt goes 2 here");
    //     string memory hashB = StringSupport.saltedHash(123, "my salt goes 2 here");

    //     string memory hash3 = gamesInstance.saltedHash(234, "my salt goes here");
    //     string memory hashC = StringSupport.saltedHash(234, "my salt goes here");

    //     Assert.isNotEmpty(hash1, "Salted hash should be a valid string");

    //     Assert.equal(hash1, hashA, "Hashes should match");
    //     Assert.equal(hash2, hashB, "Hashes should match");
    //     Assert.equal(hash3, hashC, "Hashes should match");

    //     Assert.notEqual(hash1, hash2, "Different salt should produce different hashes");
    //     Assert.notEqual(hash1, hash3, "Different numbers should produce different hashes");
    //     Assert.notEqual(hash2, hash3, "Different numbers and salt should produce different hashes");
    // }

    // function testGameCreation() public {
    //     uint8[9] memory cells;
    //     uint8 status;
    //     uint amount;
    //     string memory nick1;
    //     string memory nick2;
    //     uint created;
    //     uint lastTransaction1;
    //     uint lastTransaction2;

    //     string memory hash = gamesInstance.saltedHash(123, "my salt goes here");
    //     uint32 gameIdx = gamesInstance.createGame(hash, "Sachin");
        
    //     Assert.equal(uint(gameIdx), 0, "The first game should have index 0");
        
    //     uint32[] memory openGames = gamesInstance.getOpenGames();
  
    //     Assert.equal(openGames.length, 1, "One game should have been created");
        

    //     (cells, status, amount, created, nick1, nick2) = gamesInstance.getGameInfo(gameIdx);
    //     Assert.equal(uint(cells[0]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[1]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[2]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[3]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[4]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[5]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[6]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[7]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[8]), 0, "The board should be empty");
    //     Assert.equal(uint(status), 0, "The game should not be started");
    //     Assert.equal(amount, 0, "The initial amount should be zero");
    //     //Assert.equal(created, 0, "Not created yet");
    //     Assert.equal(nick1, "Sachin", "The nick should be Sachin");
    //     Assert.isEmpty(nick2, "Sanchay should be empty");

    //     (created, lastTransaction1, lastTransaction2) = gamesInstance.getGameTimestamps(gameIdx);
    //     Assert.isAbove(created, 0, "Creation date should be set");
    //     Assert.isAbove(lastTransaction1, 0, "The first player's transaction timestamp should be set");
    //     Assert.equal(lastTransaction2, 0, "The second player's transaction timestamp should be empty");
    // }

    // function testGameAccepted() public{

    //      uint8[9] memory cells;
    //     uint8 status;
    //     uint amount;
    //     string memory nick1;
    //     string memory nick2;
    //     uint created;
    //     uint lastTransaction1;
    //     uint lastTransaction2;

    //     uint32[] memory openGames = gamesInstance.getOpenGames();
    //     Assert.equal(openGames.length, 1, "One game should be available");

    //     gamesInstance.acceptGame(openGames[0], 0, "Sanchay");

    //     openGames = gamesInstance.getOpenGames();
    //     Assert.equal(openGames.length, 1, "One game should still exist");
    //     Assert.equal(uint(openGames[0]), 0, "The game should still have index 0");

    //     (cells, status, amount, nick1, nick2) = gamesInstance.getGameInfo(openGames[0]);
    //     Assert.equal(uint(cells[0]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[1]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[2]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[3]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[4]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[5]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[6]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[7]), 0, "The board should be empty");
    //     Assert.equal(uint(cells[8]), 0, "The board should be empty");
    //     Assert.equal(uint(status), 0, "The game should not be started");
    //     Assert.equal(amount, 0, "The initial amount should be zero");
    //     Assert.equal(nick1, "Sachin", "The nick should be Sachin");
    //     Assert.equal(nick2, "Sanchay", "The nick should be Sanchay");

    //     (created, lastTransaction1, lastTransaction2) = gamesInstance.getGameTimestamps(openGames[0]);
    //     Assert.isAbove(created, 0, "Creation date should be set");
    //     Assert.isAbove(lastTransaction1, 0, "The first player's transaction timestamp should be set");
    //     Assert.isAbove(lastTransaction2, 0, "The second player's transaction timestamp should be set");

    // }

    function testGameConfirmed() public {
        uint8[9] memory cells;
        uint8 status;
        uint amount;
        string memory nick1;
        string memory nick2;
        // uint created;
        // uint lastTransaction1pre;
        // uint lastTransaction1post;
        // uint lastTransaction2;

        string memory hash = gamesInstance.saltedHash(123, "my salt goes here");
        uint32 gameIdx = gamesInstance.createGame(hash, "Sachin");
        gamesInstance.acceptGame(gameIdx, 234, "Sanchay");

        // (created, lastTransaction1pre, lastTransaction2) = gamesInstance.getGameTimestamps(gameIdx);

        gamesInstance.confirmGame(gameIdx, 123, "my salt goes here");

        // 123 ^ 234 is odd: player 2 should start
        (cells, status, amount, nick1, nick2) = gamesInstance.getGameInfo(gameIdx);
        Assert.equal(uint(cells[0]), 0, "The board should be empty");
        Assert.equal(uint(cells[1]), 0, "The board should be empty");
        Assert.equal(uint(cells[2]), 0, "The board should be empty");
        Assert.equal(uint(cells[3]), 0, "The board should be empty");
        Assert.equal(uint(cells[4]), 0, "The board should be empty");
        Assert.equal(uint(cells[5]), 0, "The board should be empty");
        Assert.equal(uint(cells[6]), 0, "The board should be empty");
        Assert.equal(uint(cells[7]), 0, "The board should be empty");
        Assert.equal(uint(cells[8]), 0, "The board should be empty");
        // Assert.equal(uint(status), 2, "The game should be started at player 2");
        // Assert.equal(amount, 0, "The initial amount should be zero");
        // Assert.equal(nick1, "Sachin", "The nick should be Sachin");
        // Assert.equal(nick2, "Sanchay", "The nick should be Sanchay");

        // (created, lastTransaction1post, lastTransaction2) = gamesInstance.getGameTimestamps(gameIdx);
        // Assert.isAbove(created, 0, "Creation date should be set");
        // Assert.isAbove(lastTransaction1post, lastTransaction1pre, "The first player's transaction timestamp should be newer");
        // Assert.isAbove(lastTransaction2, 0, "The second player's transaction timestamp should be set");

        Assert.equal(uint(status), 2, "The game should be started at player 2");
        Assert.equal(amount, 0, "The initial amount should be zero");
        Assert.equal(nick1, "Sachin", "The nick should be Sachin");
        Assert.equal(nick2, "Sanchay", "The nick should be Sanchay");

        // Try to cheat
        hash = gamesInstance.saltedHash(123, "my salt goes here");
        gameIdx = gamesInstance.createGame(hash, "Sachin");
        gamesInstance.acceptGame(gameIdx, 234, "Sanchay");

        gamesInstance.confirmGame(gameIdx, 100, "my salt goes here");
        

        //The hash does not correspond 100! = 123

        (cells, status, amount, nick1, nick2) = gamesInstance.getGameInfo(gameIdx);
        Assert.equal(uint(cells[0]), 0, "The board should be empty");
        Assert.equal(uint(cells[1]), 0, "The board should be empty");
        Assert.equal(uint(cells[2]), 0, "The board should be empty");
        Assert.equal(uint(cells[3]), 0, "The board should be empty");
        Assert.equal(uint(cells[4]), 0, "The board should be empty");
        Assert.equal(uint(cells[5]), 0, "The board should be empty");
        Assert.equal(uint(cells[6]), 0, "The board should be empty");
        Assert.equal(uint(cells[7]), 0, "The board should be empty");
        Assert.equal(uint(cells[8]), 0, "The board should be empty");

        Assert.equal(uint(status), 12, "The game should be won by player 2");
    }
}



