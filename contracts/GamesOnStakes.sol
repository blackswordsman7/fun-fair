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

    
    uint32 index;            // position in openGames[]
    uint8[9] cells;  

    // [123 | 456 | 789] containing [0 => nobody, 1 => X, 2 => O]    

    // 0 => not started, 1 => player 1, 2 => player 2
    // 10 => draw, 11 => player 1 wins, 12 => player 2 wins

    uint8 status;                   
    uint amount;                        // amount of money each user has sent

    address[2] players;                 // Player;s array
    string[2] nicks;                    
    uint[2] lastTransactions;               // timestamp => block number
    bool[2] withdrawn;

    bytes32 creatorHash;                   
    uint8 guestRandomNumber;
  }

    uint32[] openGames;                    // list of active games' id's
    mapping(uint32 => Game) gamesData;     // data containers

    uint32 nextGameIdx;
    uint16 public timeout;                  // Game Timeout

    // TODO: Apply limit!

    constructor(uint16 givenTimeout) public {
      if(givenTimeout!= 0){
          timeout = givenTimeout;    
      }
      else{
        timeout = 10 minutes;
      }
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
    returns (uint8[9] memory cells, uint8 status, uint amount, string memory nick1, string memory nick2) {
        return (

        gamesData[gameIdx].cells,
        gamesData[gameIdx].status,
        gamesData[gameIdx].amount,
        gamesData[gameIdx].nicks[0],
        gamesData[gameIdx].nicks[1]
        );
    }

    function getGameTimestamps(uint32 gameIdx) 
    public 
    view 
  returns (uint lastTransaction1, uint lastTransaction2) {
      return (
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

   function createGame(bytes32 randomNumberHash, string memory nick) 
   public 
   payable 
   returns (uint32 gameIdx) {
     require(nextGameIdx + 1 > nextGameIdx);

      gamesData[nextGameIdx].index = uint32(openGames.length);
      gamesData[nextGameIdx].creatorHash = randomNumberHash;
      gamesData[nextGameIdx].amount = msg.value;
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

    // Remove Accepted game from the openGames list
    uint32 idxToDelete = gamesData[gameIdx].index;
    openGames[idxToDelete] = openGames[openGames.length - 1];
    gamesData[gameIdx].index = idxToDelete;
    openGames.length--;

    }

    function confirmGame(uint32 gameIdx, uint8 revealedRandomNumber, string memory revealedSalt) public {
        require(gameIdx < nextGameIdx);
        require(gamesData[gameIdx].players[0] == msg.sender);
        require(gamesData[gameIdx].players[1] != address(0x0));
        require(gamesData[gameIdx].status == 0);


        // TODO Compare hashes directly, no extra hashing | Figure out, Ask!
        bytes32 computedHash = saltedHash(revealedRandomNumber, revealedSalt);
        if(computedHash != gamesData[gameIdx].creatorHash){
            gamesData[gameIdx].status = 12;
            emit GameEnded(gameIdx);
            return;
        }

        gamesData[gameIdx].lastTransactions[0] = now;

        // Logic for deciding turns, if even-even/odd-odd, game creator will have the first chance
        // If odd-even, guest will have the first chance - ||Define starting player||
        if((revealedRandomNumber ^ gamesData[gameIdx].guestRandomNumber) & 0x0 == 0){
            gamesData[gameIdx].status = 1;
        }
        else {
            gamesData[gameIdx].status = 2;
            emit GameStarted(gameIdx);
        }
    }


    function markPosition(uint32 gameIdx, uint8 cell) public {

        require(gameIdx < nextGameIdx);
        require(cell<=8, "The parameter must contain a value less than max cell value limit");

        uint8[9] storage cells = gamesData[gameIdx].cells;
        require(cells[cell] == 0, "No Player has started yet");

        if(gamesData[gameIdx].status == 1){
          require(gamesData[gameIdx].players[0] == msg.sender, "Position marked! Game creator is the player 1");
        }

        else if(gamesData[gameIdx].status == 2){
          require(gamesData[gameIdx].players[1] == msg.sender, "Position marked! Guest is the player 1");
        }
        else{
          revert();
        }

        emit PositionMarked(gameIdx);

        // Board indexes:
        //    0 1 2
        //    3 4 5
        //    6 7 8

        // Detect a winner:
        // Need Help!!
        // Winning probability in all rows, and columns

        if((cells[0] & cells [1] & cells [2] != 0x0) || (cells[3] & cells [4] & cells [5] != 0x0) ||
        (cells[6] & cells [7] & cells [8] != 0x0) || (cells[0] & cells [3] & cells [6] != 0x0) ||
        (cells[1] & cells [4] & cells [7] != 0x0) || (cells[2] & cells [5] & cells [8] != 0x0) ||
        (cells[0] & cells [4] & cells [8] != 0x0) || (cells[2] & cells [4] & cells [6] != 0x0)) {
            // winner
            gamesData[gameIdx].status = 10 + cells[cell];  // 11 or 12
            emit GameEnded(gameIdx);
        }

        // All cells filled..! Hence, a draw
        else if(cells[0] != 0x0 && cells[1] != 0x0 && cells[2] != 0x0 && 
            cells[3] != 0x0 && cells[4] != 0x0 && cells[5] != 0x0 && cells[6] != 0x0 && 
            cells[7] != 0x0 && cells[8] != 0x0) {
            
            gamesData[gameIdx].status = 10;
            emit GameEnded(gameIdx);
        }
        else {
            if(cells[cell] == 1){
                gamesData[gameIdx].status = 2;
            }
            else if(cells[cell] == 2){
                gamesData[gameIdx].status = 1;
            }
            else{
              revert();
            }
        }
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









