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

    uint32 nextGameIdx;

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
     require(nextGameIdx + 1 > nextGameIdx);

      gamesData[nextGameIdx].index = openGames.length;
      gamesData[nextGameIdx].creatorHash = randomNumberHash;
      gamesData[nextGameIdx].amount = msg.value;
      gamesData[nextGameIdx].created = now;
      gamesData[nextGameIdx].nicks[0] = nick;
      gamesData[nextGameIdx].players[0] = msg.sender;
      openGames.push(nextGameIdx);

      gameIdx = nextGameIdx;
      emit GameCreated(nextGameIdx);

      nextGameIdx++;
  }


    function acceptGame(uint32 gameIdx, uint8 randomNumber, string memory nick) 
    public 
    payable {
    
    require(gameIdx < nextGameIdx);
    require(gamesData[gameIdx].players[0] != address(0x0));
    require(msg.value == gamesData[gameIdx].amount);
    require(gamesData[gameIdx].players[1] == address(0x0));
    require(gamesData[gameIdx].status == 0);

    gamesData[gameIdx].guestRandomNumber = randomNumber;
    gamesData[gameIdx].nicks[1] = nick;
    gamesData[gameIdx].players[1] = msg.sender;
    gamesData[gameIdx].lastTransactions[1] = now;

    emit GameAccepted(gameIdx);
    }

    function confirmGame(uint32 gameIdx, uint8 originalRandomNumber, string memory originalSalt) public {
        require(gameIdx < nextGameIdx);
        require(gamesData[gameIdx].players[0] == msg.sender);
        require(gamesData[gameIdx].players[1] != address(0x0));
        require(gamesData[gameIdx].status == 0);


        // TODO Compare hashes directly, no extra hashing | Figure out, Ask!
        string memory hash = saltedHash(originalRandomNumber, originalSalt);
        if(keccak256(hash) != keccak256(gamesData[gameIdx].creatorHash)){
            gamesData[gameIdx].status = 12;
            return;
        }

        gamesData[gameIdx].lastTransactions[0] = now;

        // Logic for deciding turns, if even-even/odd-odd, game creator will have the first chance
        // If odd-even, guest will have the first chance
        if((originalRandomNumber ^ gamesData[gameIdx].guestRandomNumber) % 2 == 0){
            gamesData[gameIdx].status = 1;
        }
        else {
            gamesData[gameIdx].status = 2;
        }
    }


    function markPosition(uint32 gameIdx, uint8 cell) public {
        emit PositionMarked(gameIdx);
    }
    

    function withdraw(uint32 gameIdx) public {
        emit GameEnded(gameIdx);
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









