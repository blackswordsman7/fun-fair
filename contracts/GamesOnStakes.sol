pragma solidity ^0.5.0;

 ///@title fun.fair _Consensys-bootcamp-final-project
 ///@author Sachin Mittal
 ///@notice Contract is built following the smart contract design pattern
 ///@dev StringSupport library is used for salted hash (commitment scheme)

 import "./StringSupport.sol";

contract GamesOnStakes {

///@title Contract properties - Monolithic, experimental, efficient (Use of library)
///@dev For any queries, generate an issue, or email at " "


// * Ethereum smart contract, deployed at "given address". */

/// *** STATE VARIABLES 


struct Game 
  {

    
    uint index;            // position in openGames[]
    uint8[9] cells;  

    // [123 | 456 | 789] containing [0 => nobody, 1 => X, 2 => O]    

    // 0 => not started, 1 => player 1, 2 => player 2
    // 10 => draw, 11 => player 1 wins, 12 => player 2 wins

    uint8 status;                   
    
    uint created;                       // Timestamp
    uint amount;                        // amount of money each user has sent

    address[2] players;                 // Player;s array
    string[2] nicks;                    
    uint[2] lastTransactions;               // timestamp => block number
    bool[2] withdrawn;

    string creatorHash;                   
    uint guestRandomNumber;
  }

    uint32[] openGames;                    // list of active games' id's
    mapping(uint32 => Game) gamesData;     // data containers

    uint32 lastGameIdx;

constructor() public {
    }

    // EVENTS

    event GameCreated(uint32 indexed gameIdx);
    event GameAccepted(uint32 indexed gameIdx);
    event GameStarted(uint32 indexed gameIdx);
    
    event PositionMarked(uint32 indexed gameIdx);
    event GameEnded(uint32 indexed gameIdx);


    // Member Functions

    //Callable 

    function getOpenGames() 
    public 
    view 
    returns (uint32[] memory){
      return openGames;
    }


    function getGameInfo(uint32 gameIdx)
    public
    view 
    returns (uint8[9] memory cells, uint8 status, uint amount, uint created, string memory nick1, string memory nick2) {
        return (

        gamesData[gameIdx].cells,
        gamesData[gameIdx].status,
        gamesData[gameIdx].amount,
        gamesData[gameIdx].created,
        gamesData[gameIdx].nicks[0],
        gamesData[gameIdx].nicks[1]
        );
    }

    function getGameTimestamps(uint32 gameIdx) 
    public 
    view 
  returns (uint created, uint lastTransaction1, uint lastTransaction2) {
      return (
          gamesData[gameIdx].created,
          gamesData[gameIdx].lastTransactions[0],
          gamesData[gameIdx].lastTransactions[1]
      );
  }

    function getGamePlayers(uint32 gameIdx) 
    public 
    view 
    returns (address player1, address player2) {
        return (
            gamesData[gameIdx].players[0],
            gamesData[gameIdx].players[1]
        );
    }


    // Operations

   function createGame(string memory randomNumberHash, string memory nick) 
   public 
   payable 
   returns (uint32 gameIdx) {
      gamesData[lastGameIdx].index = openGames.length;
      gamesData[lastGameIdx].creatorHash = randomNumberHash;
      gamesData[lastGameIdx].amount = msg.value;
      gamesData[lastGameIdx].created = now;
      gamesData[lastGameIdx].nicks[0] = nick;
      gamesData[lastGameIdx].players[0] = msg.sender;
      openGames.push(lastGameIdx);

      gameIdx = lastGameIdx;
      emit GameCreated(lastGameIdx);

      lastGameIdx++;
  }


    function acceptGame(uint32 gameIdx, uint8 randomNumber) public payable {
        emit GameAccepted(lastGameIdx+1);
    }

    function confirmGame(uint32 gameIdx, uint8 originalRandomNumber, bytes32 originalSalt) public {
        emit GameStarted(lastGameIdx+1);
    }

    function markPosition(uint gameIdx, uint8 cell) public {
        emit PositionMarked(lastGameIdx+1);
    }
    

    function withdraw(address gameId) public {
        emit GameEnded(lastGameIdx+1);
    }
   

    // Imported from library - public helper function
    function saltedHash(uint8 randomNumber, string memory salt) public pure returns (bytes32) {
        return StringSupport.saltedHash(randomNumber, salt);
    }

    // Fallback function

    function () external payable {
        revert();
    }

}









