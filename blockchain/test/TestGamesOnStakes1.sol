// test/TestGamesOnStakes1.sol
pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GamesOnStakes.sol";
import "../contracts/StringSupport.sol";

contract TestGamesOnStakes1 {
    GamesOnStakes gamesInstance;

    constructor() public {
        gamesInstance = GamesOnStakes(DeployedAddresses.GamesOnStakes());
    }

    function testInitiallyEmpty() public {
        Assert.equal(gamesInstance.getOpenGames().length, 0, "The games array should be empty at the begining");
    }

    function testHashingFunction() public {
        bytes32 hash1 = gamesInstance.saltedHash(123, "my salt goes here");
        bytes32 hashA = StringSupport.saltedHash(123, "my salt goes here");

        bytes32 hash2 = gamesInstance.saltedHash(123, "my salt goes 2 here");
        bytes32 hashB = StringSupport.saltedHash(123, "my salt goes 2 here");

        bytes32 hash3 = gamesInstance.saltedHash(234, "my salt goes here");
        bytes32 hashC = StringSupport.saltedHash(234, "my salt goes here");

        Assert.isNotZero(hash1, "Salted hash should be a valid string");

        Assert.equal(hash1, hashA, "Hashes should match");
        Assert.equal(hash2, hashB, "Hashes should match");
        Assert.equal(hash3, hashC, "Hashes should match");

        Assert.notEqual(hash1, hash2, "Different salt should produce different hashes");
        Assert.notEqual(hash1, hash3, "Different numbers should produce different hashes");
        Assert.notEqual(hash2, hash3, "Different numbers and salt should produce different hashes");
    }

        
    function testGameCreation() public {
        uint8[9] memory cells;
        uint8 status;
        uint amount;
        string memory nick1;
        string memory nick2;
        uint lastTransaction1;
        uint lastTransaction2;

        bytes32 hash = gamesInstance.saltedHash(123, "my salt goes here");
        uint32 gameIdx = gamesInstance.createGame(hash, "Sachin");
        
        Assert.equal(uint(gameIdx), 0, "The first game should have index 0");
        
        uint32[] memory openGames = gamesInstance.getOpenGames();
  
        Assert.equal(openGames.length, 1, "One game should have been created");
        

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
        Assert.equal(uint(status), 0, "The game should not be started");
        Assert.equal(amount, 0, "The initial amount should be zero");
    
        Assert.equal(nick1, "Sachin", "The nick should be Sachin");
        Assert.isEmpty(nick2, "Sanchay should be empty");

        (lastTransaction1, lastTransaction2) = gamesInstance.getGameTimestamps(gameIdx);
        Assert.isAbove(lastTransaction1, 0, "The first player's transaction timestamp should be set");
        Assert.equal(lastTransaction2, 0, "The second player's transaction timestamp should be empty");
       
    }

    function testGameAccepted() public{

        uint8[9] memory cells;
        uint8 status;
        uint amount;
        string memory nick1;
        string memory nick2;
        uint lastTransaction1;
        uint lastTransaction2;

        uint32[] memory openGames = gamesInstance.getOpenGames();
        Assert.equal(openGames.length, 1, "One game should be available");

        uint32 gameIdx = openGames[0];

        gamesInstance.acceptGame(gameIdx, 234, "Sanchay");

        openGames = gamesInstance.getOpenGames();
        // Assert.equal(openGames.length, 1, "One game should still exist");
        // Assert.equal(uint(openGames[0]), 0, "The game should still have index 0");

        Assert.equal(openGames.length, 0, "The game should not be available anymore");

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
        Assert.equal(uint(status), 0, "The game should not be started");
        Assert.equal(amount, 0, "The initial amount should be zero");
        Assert.equal(nick1, "Sachin", "The nick should be Sachin");
        Assert.equal(nick2, "Sanchay", "The nick should be Sanchay");

        (lastTransaction1, lastTransaction2) = gamesInstance.getGameTimestamps(gameIdx);
        Assert.isAbove(lastTransaction1, 0, "The first player's transaction timestamp should be set");
        Assert.isAbove(lastTransaction2, 0, "The second player's transaction timestamp should be set");
    }
   
}


