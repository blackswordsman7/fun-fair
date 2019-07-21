pragma solidity ^0.5.0;

///@title fun.fair _Consensys-bootcamp-final-project
 ///@author Sachin Mittal
 ///@notice Contract is built following the smart contract design pattern
 ///@dev 

contract GamesOnStakes {

///@title Contract properties - Monolithic, 
///@dev For any queries, generate an issue, or email at " "


// * Ethereum smart contract, deployed at "given address". */

/// *** STATE VARIABLES 


struct Game 
  {

    
    uint32 openListIndex;            // position in openGames[]
    uint8[9] cells;  

    // [123 | 456 | 789] containing [0 => nobody, 1 => X, 2 => O]    

    // 0 => not started, 1 => player 1, 2 => player 2
    // 10 => draw, 11 => player 1 wins, 12 => player 2 wins

    uint status;
          
    uint amount;                        // amount of money each user has sent

    address[2] players;
    string[2] nicks;
    uint lastTransaction;               // timestamp => block number
    bool[2] withdrawn;

    bytes32 creatorHash;
    uint guestRandomNumber;
  }

    uint32[] openGames;                    // list of active games' id's
    mapping(uint32 => Game) gamesData; // data containers

    uint32 nextGameIdx;                
    uint16 public timeout;

constructor() public {
    }

    event GameCreated(uint32 indexed gameIdx);
    event GameAccepted(uint32 indexed gameIdx);
    event GameStarted(uint32 indexed gameIdx);
    event GameEnded(uint32 indexed gameIdx);

}
