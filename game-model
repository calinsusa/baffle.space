// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;
/***********************/
/* MODEL CONTRACT GAME */
/***********************/

contract Game {
error Game__is__close();
error Game__is__paused();
enum GameProgress {
    INPROGRESS,
    FINISH
}   
enum GameState {
    OPEN,
    CLOSE,
    PAUSE
}
string public s_gameName;
string public s_gameCategory;
uint256 public s_interval;
address public immutable i_owner;
address public s_contractAddress;
uint public s_ticketPrice;
uint public s_countPlayersInGame;
GameState public s_gameState;
GameProgress public s_gameProgress;
uint public s_startGameAt;
mapping(uint => address) public  players;

struct GameData {
        string gameName;
        string gameCategory;
        uint interval;
        uint ticketPrice;
        address gameAddress;
       }

      

constructor(address _owner, string memory _gameName, string memory _category, uint _interval, uint _ticketPrice){
      i_owner = _owner;
      s_gameName = _gameName;
      s_contractAddress = address(this);
      s_gameState = GameState.CLOSE;
      s_interval = _interval;
      s_gameCategory = _category;
      s_ticketPrice = _ticketPrice;
}
////////////
//GAME FUNC
////////////

function enterGame (address _player) external {
    if(s_gameState == GameState.CLOSE ){
        revert Game__is__close();
    } 
    if(s_gameState == GameState.PAUSE){
        revert Game__is__paused();
    }
    s_countPlayersInGame++;
    address playerAddres = _player;
    players[s_countPlayersInGame - 1] = playerAddres;
    s_startGameAt = block.timestamp;
    s_gameProgress = GameProgress.INPROGRESS;
}

function chackGameProgress() external{
    if((block.timestamp - s_startGameAt) > s_interval){
       s_gameProgress = GameProgress.FINISH;
    }
}
///////////
//SET FUNC
///////////

function setGameName (string memory  _name) external  {
   s_gameName = _name;
}

function setTicketPrice (uint _price) external {
    s_ticketPrice = _price;
}

function setGameState (uint state) external  {
    s_gameState = GameState(state);
}

function setInterval (uint256 _interval) external {
    s_interval = _interval;
}

/////////////
//RETURN FUNC
/////////////

function getGameData () public view returns(GameData memory) {
    GameData memory game = GameData(
        {gameName: s_gameName,
        gameCategory: s_gameCategory,
        interval: s_interval,
        ticketPrice:s_ticketPrice,
        gameAddress: s_contractAddress
        });
    return game;
}

function getTotalNumberOfPlayers () external view returns (uint) {
    return s_countPlayersInGame;
}

function getWinner (uint playerIndex) external view  returns(address)  {
    return players[playerIndex];
}

function getGameAddress () external view returns(address) {
    return s_contractAddress;
}

function getInterval () external view returns(uint) {
    return s_interval;
}

function getProgress () external view returns(uint) {
    return uint(s_gameProgress);
}

function getGameName () internal view returns(string memory){
    return s_gameName;
}




///////////
//MODIFIER
///////////
     modifier onlyOwner() {
      require(msg.sender == i_owner);
      _;
  }
}
