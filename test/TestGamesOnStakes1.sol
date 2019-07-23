// test/TestGamesOnStakes1.sol
pragma solidity ^0.5.0;

import "truffle/Assert.sol";

import "../contracts/GamesOnStakes.sol";
import "../contracts/StringSupport.sol";

contract TestGamesOnStakes1 {
    GamesOnStakes gamesInstance;

    constructor() public {
           
        uint32[] memory openGames = gamesInstance.getOpenGames();
        Assert.equal(openGames.length, 1, "One game should be available");

        gamesInstance.acceptGame(openGames[0], 234, "Sanchay");

        openGames = gamesInstance.getOpenGames();
        Assert.equal(openGames.length, 1, "One game should still exist");
       
        Assert.isAbove(created, 0, "Creation date should be set");
        Assert.isAbove(lastTransaction1, 0, "The first player's transaction timestamp should be set");
        Assert.isAbove(lastTransaction2, 0, "The second player's transaction timestamp should be set");

    }
}


