// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract OnChainNft is ERC721Enumerable, Ownable {
  using Strings for uint256;
  bool public paused = false;
  constructor() ERC721("On Chain NFT", "OCN") {}


  struct Word {
    string name;
    string description;
    string bgHue;
    string textHue;
    string level;
  }

   mapping(uint256 => Word) public words;
  // internal
 

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    require(!paused);
    require(supply + 1 <= 10000);
    Word memory newWord = Word(
      string(abi.encodePacked('OCN #',uint256(supply + 1).toString())),
      "This is an on chain test NFT",
      randomNum(361,block.difficulty,supply).toString(),
      randomNum(361,block.timestamp,supply).toString(),
      string(abi.encodePacked('Genesis #' , (supply + 1).toString()))
    );
    if (msg.sender != owner()) {
      require(msg.value >= 0.05 ether);
    }
     words[supply + 1] = newWord;
    _safeMint(msg.sender, supply + 1);
  
  }
   function tokenURI(uint256 _tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(_tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
     Word memory currentWord = words[_tokenId];
    return string(abi.encodePacked(
      'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
        '{"name":"',currentWord.name,'", "description":"',currentWord.description,'","image":"','data:image/svg+xml;base64,',buildImage(_tokenId),'"}'
      )))));
  }

  function randomNum (uint256 _mod, uint256 _seed, uint256 _salt ) public view returns(uint256) {
    uint256 num = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
    return num;
  }

  function buildImage (uint256 _tokenId) public view returns(string memory){
      Word memory currentWord = words[_tokenId];
      return Base64.encode(bytes(abi.encodePacked(
        '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">',
        '<rect height="500" width="500" y="0" x="0" fill="hsl(',currentWord.bgHue,',50%,25%)"/>'
        '<text  text-anchor="start" font-family="Raleway" font-size="24"   y="247.48213" x="102.51809"   fill="hsl(',currentWord.textHue,',100%,80%)">Baffle Space NFT on Chain</text>',
        '<text  text-anchor="start" font-family="Raleway" font-size="24"  y="288.84906" x="192.80587"   fill="hsl(',currentWord.textHue,',100%,80%)">sn ',currentWord.level,'</text>',
        '</svg>'
        )));
  }

  //only owner
  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
  function withdraw() public payable onlyOwner {
   
    (bool succes, ) = payable(owner()).call{value: address(this).balance}("");
    require(succes);
  
  }
}
