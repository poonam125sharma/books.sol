pragma solidity 0.5.3;

contract Buy_Novels_Old {
    struct Novel {
        uint256 id;
        string title;
        string author;
        uint256 price;
        
        // If novel is available for buying
        mapping(uint256 => bool) novelStatus;
    }
    
    mapping(address => Novel) novels;
    
    function addNovel(uint256 _id, string memory _title, string memory _author, uint256 _price) public {
        Novel memory novel = novels[_id];
        
        novel.id = _id;
        novel.title = _title;
        novel.author = _author;
        novel.price = _price;
    }
    
    function buyNovel(uint256 _id) public {
        var novel = novels[_id];
        
        // Novel has been bought, not available now
        novel.novelStatus = false;
    }
    
    function getBalance() public returns(uint256) {
        return address(this).balance;
    }
    
    function returnNovel(uint256 _id) public {
        var novel = novels[_id];
        
        // Novel has been returned, available for further buying now
        novel.novelStatus = true;
    }
}
