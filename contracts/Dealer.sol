 pragma solidity ^0.5.0;
 
 ///@title fun.fair _Consensys-bootcamp-final-project
 ///@author Sachin Mittal
 ///@notice Contract is built following the smart contract design pattern
 ///@dev Uses hybrid commit-reveal method + block hash RNG. Provides provably fair gambling, and arbitrary high bets

 contract Dealer{

///@title Contract properties - Monolithic, 
///@dev For any queries, generate an issue, or email at " "


// * Ethereum smart contract, deployed at "given address". */

/// *** STATE VARIABLES 

// Each bet is deducted 1% in favour of the house, but no less than some minimum i.e. 0.0003 eth

uint constant HOUSE_COMM_PER = 1;
uint constant HOUSE_MIN_COMM = 0.0003 ether;

// Bets lower than this amount do not participate in rolls (and are not deducted jackpot fees).

uint constant MIN_JACKPOT_BET = 0.1 ether;

// Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.

uint constant JACKPOT_WIN_PER = 1;
uint constant JACKPOT_FEE = 0.001 ether;

// Allowed minimum and maximum bets.

uint constant MIN_BET = 0.01 ether;
uint constant MAX_BET = 300000 ether;
// Not sure about the amount

// Modulo is a number of equiprobable outcomes in a betting game:
    //  - 2 for coin flip
    //  - 6 for dice
    //  - 6*6 = 36 for double dice
    //  - 100 for etheroll
    //  - 37 for roulette
    //  etc.

// 256-bit entropy is treated like a huge integer, and therefore modulo is called. 

// Since roll has a bar of 100, 

//uint constant MAX_MODULO = 100;

//uint constant MAX_MASK_MODULO = 40;

//   uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;


  // Accumulated jackpot fund.
    uint128 public jackpotSize;

    // Funds that are locked in potentially winning bets.
    uint128 public lockedInBets;

 }