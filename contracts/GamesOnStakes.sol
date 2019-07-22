pragma solidity ^0.5.0;

///@title fun.fair _Consensys-bootcamp-final-project
 ///@author Sachin Mittal
 ///@notice Contract is built following the smart contract design pattern
 ///@dev 

 import "./StringSupport.sol";

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

    uint8 status;
          
    uint amount;                        // amount of money each user has sent

    address[2] players;
    string[2] nicks;
    uint lastTransaction;               // timestamp => block number
    bool[2] withdrawn;

    bytes32 creatorHash;
    uint guestRandomNumber;
  }

    uint32[] openGames;                    // list of active games' id's
    mapping(uint32 => Game) gamesData;     // data containers

    uint32 nextGameIdx;
    uint16 public timeout;

constructor() public {
    }

    // EVENTS

    event GameCreated(uint32 indexed gameIdx);
    event GameAccepted(uint32 indexed gameIdx);
    event GameStarted(uint32 indexed gameIdx);
    event GameEnded(uint32 indexed gameIdx);
    event PositionMarked(uint32 indexed gameIdx);

    // Member Functions

    //Callable 

    function getOpenGames() 
    public 
    view 
    returns (uint32[] memory){}


    function getGameInfo(uint gameIdx)
    public
    view 
    returns (uint8[9] memory cells, uint8 status, uint amount, string memory nick1, string memory nick2) {
        return (cells, status, amount, nick1, nick2);
    }

    // Operations

    function createGame(string memory randomNumberHash) public payable returns (address) {
        emit GameCreated(nextGameIdx);
    }

    function acceptGame(address gameId, uint8 randomNumber) public payable {
        emit GameAccepted(nextGameIdx);
    }

    function confirmGame(address gameId, uint8 originalRandomNumber, bytes32 originalSalt) public {
        emit GameStarted(nextGameIdx);
    }

    function markPosition(address gameId, uint8 cell) public {
        emit PositionMarked(nextGameIdx);
    }
    

    function withdraw(address gameId) public {
        emit GameEnded(nextGameIdx);
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











    // mapping (address => uint) balances;

    // event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // constructor() public {
    //     balances[msg.sender] = 10000;
    // }

    // function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
    //     if (balances[msg.sender] < amount) return false;
    //     balances[msg.sender] -= amount;
    //     balances[receiver] += amount;
    //     emit Transfer(msg.sender, receiver, amount);
    //     return true;
    // }

    // function getBalanceInEth(address addr) public view returns(uint){
    //     return ConvertLib.convert(getBalance(addr),2);
    // }

    // function getBalance(address addr) public view returns(uint) {
    //     return balances[addr];
    // }
