// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./GameModel.sol";
/*********************************************************************************/

// interface GameModel {
//     function enterGame (address _player) external;
//     function chackGameProgress() external;
//     function setGameName (string memory  _name) external;
//     function setTicketPrice (uint _price) external;
//     function setGameState (uint state) external; 

// }
/***********************/
/* CONTRACT LOTERIE */
/***********************/
// error Nici__un__joc__nu__a__ajuns__la__final();
contract Lotery{
  
    address immutable i_owner;
    Game game;
    Game[] public games;
    address[] public createdGamesAddresses; 
    uint[] s_intervals;//?
    address[] public s_finisedGames;
    address[] public s_winners;
    // mapping(string => mapping(address => string)) public allGamesCreatedInCategories;
    mapping(address => uint256) public gamesIntervals;// ?
   
   constructor() {
        i_owner = msg.sender;
    }
  
////////////// 
//LOTTERY FUNC
////////////// 

/*CREAZA JOCUL
@dev - Functia primeste din front-end parametrii nume joc si intervalul => (durata de desfasurare a jocului )
       intervalul este dat in secunde
     - constructorul noului contract generat  
*/
function createGame (string memory _gameName, string memory _category,  uint _interval, uint _ticketPrice ) external {
    game = new Game(address(this),_gameName, _category, _interval, _ticketPrice );
    games.push(game);
    address newGameAddress = address(game);
    createdGamesAddresses.push(newGameAddress);
    gamesIntervals[newGameAddress] = _interval;// seteaza adresa si intervalul de extragere al jocului in map
    //////////
   

}

function enterInGame (address _gameAddress) external {
      address player = msg.sender;
      Game(_gameAddress).enterGame(player);
    //   (bool succes, bytes memory _data) = _gameAddress.call(abi.encodeWithSignature("enterGame(address)",player));
    //   require(succes, "call fail");
} 


function chackGamesProgress () external {
   for (uint i = 0; i < createdGamesAddresses.length; i++){
       Game(createdGamesAddresses[i]).chackGameProgress();
       if(Game(createdGamesAddresses[i]).getProgress() == 1){
            s_finisedGames.push(createdGamesAddresses[i]);
       }else{
           revert ("Nici__un__joc__nu__a__ajuns__la__final");
       }
   }
}

function getWinnerFromFinisedGames() external{
    for(uint i = 0; i < s_finisedGames.length; i++){
      s_winners.push(Game(s_finisedGames[i]).getWinner(mockGenerateRandomNumber() % Game(s_finisedGames[i]).getTotalNumberOfPlayers()));
    }
 
} 

function mockGenerateRandomNumber() internal view returns(uint256) {
      return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
}

////////////////// 
//LOTTERY SET FUNC
//////////////////

function setGameNameInContractGame (address _gameAddres ,string memory _gameName) external  {
    Game(_gameAddres).setGameName(_gameName);
    }

function setTicketPriceInContractGame (address _gameAddres ,uint256 _price) external  {
    Game(_gameAddres).setTicketPrice(_price);
    }

 function setGameState (address _gameAddres,uint8 state) external  {
    Game(_gameAddres).setGameState(state);
    }  

 function setGameInterval (address _gameAddres,uint256 _interval)  external {
     Game(_gameAddres).setInterval(_interval);
     gamesIntervals[_gameAddres] = _interval;// seteaza adresa si intervalul de extragere al jocului in map
    }

 ///////////////
 //GET FUNCTIONS
 ///////////////  
function getAllGames () external view returns (address[]memory){
    return createdGamesAddresses;
}


 ///////////////////
 //MODIFIER
 ///////////////////

     modifier onlyOwner() {
      require(msg.sender == i_owner);
      _;
  }

}
