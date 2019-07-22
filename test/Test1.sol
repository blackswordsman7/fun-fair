// test/Test1.sol
pragma solidity ^0.5.0;

import "truffle/Assert.sol";
//import "truffle/DeployedAddresses.sol";
import "../contracts/GamesOnStakes.sol";
import "../contracts/StringSupport.sol";

contract TestGamesOnStakes {
    GamesOnStakes games;

    constructor() public {
        games = GamesOnStakes(DeployedAddresses.GamesOnStakes());
    }

    function testInitiallyEmpty() public {
        Assert.equal(games.getOpenGames().length, 0, "The games array should be empty at the begining");
    }

    function testHashingFunction() public {
        string memory hash1 = games.saltedHash(123, "my salt goes here");
        string memory hashA = LibString.saltedHash(123, "my salt goes here");

        string memory hash2 = games.saltedHash(123, "my salt goes 2 here");
        string memory hashB = LibString.saltedHash(123, "my salt goes 2 here");

        string memory hash3 = games.saltedHash(234, "my salt goes here");
        string memory hashC = LibString.saltedHash(234, "my salt goes here");

        Assert.isNotEmpty(hash1, "Salted hash should be a valid string");

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
        uint created;
        uint lastTransaction1;
        uint lastTransaction2;

        string memory hash = games.saltedHash(123, "my salt goes here");
        Assert.equal(uint(gameIdx), 0, "The first game should have index 0");
        
        uint32 gameIdx = games.createGame(hash, "John");
        uint32[] memory openGames = games.getOpenGames();
  
        Assert.equal(openGames.length, 1, "One game should have been created");
        

        (cells, status, amount, created, nick1, nick2) = games.getGameInfo(gameIdx);
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
        //Assert.equal(created, 0, "Not created yet");
        Assert.equal(nick1, "John", "The nick should be John");
        Assert.isEmpty(nick2, "Nick2 should be empty");

        (created, lastTransaction1, lastTransaction2) = games.getGameTimestamps(gameIdx);
        Assert.isAbove(created, 0, "Creation date should be set");
        Assert.isAbove(lastTransaction1, 0, "The first player's transaction timestamp should be set");
        Assert.equal(lastTransaction2, 0, "The second player's transaction timestamp should be empty");
    }
}
    

