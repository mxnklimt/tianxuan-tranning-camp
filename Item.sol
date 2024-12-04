pragma solidity ^0.4.24;

import "./ERC721.sol";

contract Item is ERC721{
    
    struct GameItem{
        string name; // Name of the Item
        uint level; // Item Level
        uint rarityLevel;  // 1 = normal, 2 = rare, 3 = epic, 4 = legendary
    }
    
    GameItem[] public items; // First Item has Index 0
    address public owner;
    mapping(address => bool) public whitelist;
    
    constructor () public {
        owner = msg.sender; // The Sender is the Owner; Ethereum Address of the Owner
    }
    
    function createItem(string _name, address _to) public{
        require(owner == msg.sender); // Only the Owner can create Items
        uint id = items.length; // Item ID = Length of the Array Items
        items.push(GameItem(_name,5,1)); // Item ("Sword",5,1)
        _mint(_to,id); // Assigns the Token to the Ethereum Address that is specified
    }
    
    function changeOwner(address newOwner) public{
        require(owner == msg.sender); // Only the Owner can change the Owner
        owner = newOwner;
    }

    function batchMintByOwner(address[] users, uint[] tokenIds) public {
        require(owner == msg.sender); // Only the Owner can mint Tokens
        require(users.length == tokenIds.length); // The Number of Users must be equal to the Number of Token IDs
        for(uint i = 0; i < users.length; i++){
            _mint(users[i], tokenIds[i]); // Mint the Token
        }
    }

    function mint() payable public {
        require(msg.value > 0, "Ether value must be greater than 0");
        uint id = items.length;
        items.push(GameItem("Default Item", 1, 1));
        _mint(msg.sender, id);
    }

    function mintByWhitelist() public {
        require(whitelist[msg.sender] == true, "You are not in the whitelist");
        uint id = items.length;
        items.push(GameItem("Default Item", 1, 1));
        _mint(msg.sender, id);
    }

    function addWhiteList(address[] users) public {
        require(owner == msg.sender, "Only owner can add whitelist");
        for(uint i = 0; i < users.length; i++){
            whitelist[users[i]] = true;
        }
    }

    function removeWhiteList(address[] users) public {
        require(owner == msg.sender, "Only owner can remove whitelist");
        for(uint i = 0; i < users.length; i++){
            whitelist[users[i]] = false;
        }
    }

    function ownerTokens(address user) public view returns(uint[]) {
        uint[] memory tokens = new uint[](balanceOf(user));
        uint counter = 0;
        for(uint i = 0; i < items.length; i++){
            if(ownerOf(i) == user){
                tokens[counter] = i;
                counter++;
            }
        }
        return tokens;
    }
}