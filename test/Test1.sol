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
}
