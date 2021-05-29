//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Buy_Novels_Old2 {
    struct Novel {
        uint256 id;
        string title;
        string author;
        uint256 price;
        bool isAvailable;   // If novel is available for buying
        address addingAddress;      // Address of the person who added this novel
    }
    
    mapping(uint256 => Novel) public novels;       // mapping of novel id to Novel
    
    mapping(address => bool) public notAllowedAddresses;    // mapping of address to bool(true if not allowed to add a novel)
    
    constructor(uint256 _id, string memory _title, string memory _author, uint256 _price) {
        address sender = msg.sender;
        novels[_id].id = _id;
        novels[_id].title = _title;
        novels[_id].author = _author;
        novels[_id].price = _price;
        novels[_id].isAvailable = true;
        novels[_id].addingAddress = sender;      // Assign the addingAddress to the address who added this novel.
        
        // Add this address to the notAllowedAddresses mapping
        notAllowedAddresses[sender] = true;
    }
    
    function checkIfNovelAlreadyAddedByAddress(address _sender) public view returns(bool) {
        
        if( notAllowedAddresses[_sender] == true ) {
            return true;
        } else {
            return false;
        }
    }
    
    function addNovel(uint256 _id, string memory _title, string memory _author, uint256 _price) public {
        
        // Address of the person calling this method
        address sender = msg.sender;
        
        // A particular address can only add a novel one time
        require(checkIfNovelAlreadyAddedByAddress(sender) == false, "This address has already added a novel, can't add more");
        
        novels[_id].id = _id;
        novels[_id].title = _title;
        novels[_id].author = _author;
        novels[_id].price = _price;
        novels[_id].isAvailable = true;
        novels[_id].addingAddress = sender;      // Assign the addingAddress to the address who added this novel.
        
        // Add this address to the notAllowedAddresses mapping
        notAllowedAddresses[sender] = true;
    }
    
    function buyNovel(uint256 _id) public payable {
        
        // Check if the particular novel exists at all or not
        require(novels[_id].id == _id, "Novel with the given id does not exist");
        
        // Check if the particular novel is available for buying or not
        require(novels[_id].isAvailable == true, "Novel with the given id is not available for buying");
        
        // Check if user has the balance to buy the novel or not
        require(novels[_id].price == msg.value, "Not enough balance to buy the novel");
        
        
        // Novel has been bought, not available now
        novels[_id].isAvailable = false;
    }
    
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
    
    function returnNovel(uint256 _id) public payable {
        require(novels[_id].isAvailable == false, "This novel was not bought");
        
        require(novels[_id].addingAddress == msg.sender, "This novel was not bought by this address");
        
        payable (novels[_id].addingAddress).transfer(novels[_id].price);
        
        // Novel has been returned, available for further buying now
        novels[_id].isAvailable = true;
    }
}
