// SPDX-License-Identifier: MIT
pragma solidity^0.8.4;

import "@openzeppelin/contracts@4.7.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.0/access/Ownable.sol";

contract ArtToken is ERC721, Ownable {

    // Smart contract Constructor
    constructor(string memory _name, string memory _symbol) ERC721 (_name, _symbol){}

    // NFT Token counter
    uint256 COUNTER;

    // Pricing of NFT Tokens (price of the art work)
    uint256 public fee = 5 ether;

    // Data structure  with the properties of the artwork
    struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;

    }

    // Storage structure for keeping artiworks
    Art [] public Art_works;

    // Declaration of an event
    event  NewArtWork (address indexed owner, uint256 id, uint256 dni);

    // Creation of a random number (required for NFT token properties)
    function _createRandomNum(uint256 _mod) internal view returns (uint256){
        bytes32 hash_randomNum = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum  = uint256 (hash_randomNum);
        return randomNum % _mod;
    }

    // NFT Token Creation (Artwork)
    function _creationArtwork(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(1000));
        uint256 randomDna = _createRandomNum(10**16);
        Art memory newArtWork = Art(_name, COUNTER, randomDna, 1, randRarity);
        Art_works.push(newArtWork);
        _safeMint(msg.sender, COUNTER);
        emit NewArtWork (msg.sender, COUNTER, randomDna);
        COUNTER ++;
    }

    // NFT Token Price Update
    function updateFee(uint256 _fee) external onlyOwner{
        fee = _fee;
    }

    // Visualize the balance of the Smart Contract (ethers)
    function infoSmartContract() public view returns (address, uint256){
        address SC_address = address(this);
        uint256 SC_money = address(this).balance / 10**18;
        return (SC_address, SC_money);
    }

    // Obtening all created NFT tokenks (artwork)
    function getArtWorks() public view returns (Art [] memory){
        return Art_works;
    }

    // Obtening a user's Token NFT
    function getOwnerArtWork(address _owner) public view returns (Art [] memory) {
        Art [] memory result = new Art [](balanceOf(_owner));
        uint256 counter_owner = 0;
        for (uint256 i = 0; i < Art_works.length; i++){
            if(ownerOf(i) == _owner) {
                result[counter_owner] = Art_works[i];
                counter_owner++;
            }
        }

        return result;
    }

   



    // NFT  Token Payment
    function createRandom(string memory _name) public payable {
        require (msg.value >= fee);
        _creationArtwork(_name);
    }

    // Extraction of ethers from the Smart Contract to the Owner
    function withdraw () external payable onlyOwner {
        address payable _owner  = payable (owner());
        _owner.transfer(address(this).balance);
    }


    // Level up NFT Tokens
    function levelUp(uint256 _artId) public {
        require(ownerOf(_artId) == msg.sender, "you don't have permissions");
        Art storage art = Art_works[_artId];
        art.level++;
    }


}
