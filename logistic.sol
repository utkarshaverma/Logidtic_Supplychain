pragma solidity ^0.5.16;

contract Logistics {
    
    //////// Declarations //////
    
    address Owner;
    
    struct package{
        
        bool isUidGenerated; //makes sure this smart contract is authentic
        uint itemId;  // unique id
        string itemName;
        string transitStatus;  // updated everytime something changes
        uint orderStatus;  // status of order in different integers : 
                            // 1 - ordered
                            // 2 - in-transit
                            // 3 - delivered
                            // 4 - canceled
        
        address customer;  // address
        uint ordertime;
        
        // defining three carriers who will be handling the package accross the transit
        address carrier1;
        uint carrier1_time;
        
        address carrier2;
        uint carrier2_time;
        
        address carrier3;
        uint carrier3_time;
        
    }
    
    // create a new mapping of unique address id to package
    mapping (address => package) public packagemapping;
    
    // mapping of carriers
    mapping (address => bool) public carriers;  
    // the addreess of certain carriers will be set to true 
    // so that only authorised carriers will be able to access the package
    // and so that nobody can tamper with the package
    
    //////////////// END Declaration /////////////////
    
    /////////////// Modifiers ///////////////
    
    constructor() public {
        // executed only once, sets the owner while deploying
        Owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(Owner == msg.sender);
        _;
    }
    
    ///////////////////// Modifiers END ////////////////
    
    
    //////////////////// Manage Carriers ////////////
    
    function ManageCarriers (address _carrierAddress) onlyOwner public returns (string memory){
        // adding "onlyOwner" makes this function executable by the owner only.
        
        if(!carriers[_carrierAddress]){
            
            carriers[_carrierAddress] = true;
            
        } else{
            
            carriers[_carrierAddress] = false;
        }
        
        return "Carrier status is updated";
    }
    
    
    /////////////////// END Manage carriers ///////////
    
    /////////////// Functions - 1. Order item ///////////////
    
    function OrderItem(uint _itemId, string memory _itemName ) public returns(address){
        
        address uniqueId = address(uint256(sha256(abi.encodePacked(msg.sender, now))));
        
        packagemapping[uniqueId].isUidGenerated = true;
        packagemapping[uniqueId].itemId = _itemId;
        packagemapping[uniqueId].itemName = _itemName;
        packagemapping[uniqueId].transitStatus = "Ordered and Processing";
        packagemapping[uniqueId].orderStatus = 1;
        
        packagemapping[uniqueId].customer = msg.sender;
        packagemapping[uniqueId].ordertime = now;
        
        return uniqueId;
    }
    
    //////////////////// end order item function  /////////////////
    
    
    
    ////////// Function - 2. Cancel order ////////////////
    
    function CancelOrder(address _uniqueId) public returns (string memory){
        
        require (packagemapping[_uniqueId].isUidGenerated); 
        // should have valid unique id generated , this is set in the making order function
        require (packagemapping[_uniqueId].customer == msg.sender); 
        // checks if it this is the same customer that made the order in the previous fucntion
        
        packagemapping[_uniqueId].orderStatus = 4; // order is canceled
        packagemapping[_uniqueId].transitStatus = "Order has been canceled";
        
        return "You canceled the order, successful.";
        
    }
    
    ////////// END Cancel order function ////////////////
    
    
    
    ////////// Carriers Functions ////////////
    
    function Carrier1Report( address _uniqueId, string memory _transitStatus) public {
        
        require (packagemapping[_uniqueId].isUidGenerated);
        require (carriers[msg.sender]); // the bool value corresponding to the carriers is set to true
        // that is , this carrier has permission tomake changes.
        require (packagemapping[_uniqueId].orderStatus == 1);
        
        packagemapping[_uniqueId].transitStatus = _transitStatus;  // change in status that is made by first carrier
        packagemapping[_uniqueId].carrier1 = msg.sender;
        packagemapping[_uniqueId].carrier1_time = now;
        packagemapping[_uniqueId].orderStatus = 2; //order is in transit.
    }
    
    function Carrier2Report( address _uniqueId, string memory _transitStatus) public {
        
        require (packagemapping[_uniqueId].isUidGenerated);
        require (carriers[msg.sender]); // the bool value corresponding to the carriers is set to true
        // that is , this carrier has permission tomake changes.
        require (packagemapping[_uniqueId].orderStatus == 1);
        
        packagemapping[_uniqueId].transitStatus = _transitStatus;  // change in status that is made by first carrier
        packagemapping[_uniqueId].carrier2 = msg.sender;
        packagemapping[_uniqueId].carrier2_time = now;
        packagemapping[_uniqueId].orderStatus = 2; //order is in transit.
    }
    
    function Carrier3Report( address _uniqueId, string memory _transitStatus) public {
        
        require (packagemapping[_uniqueId].isUidGenerated);
        require (carriers[msg.sender]); // the bool value corresponding to the carriers is set to true
        // that is , this carrier has permission tomake changes.
        require (packagemapping[_uniqueId].orderStatus == 1);
        
        packagemapping[_uniqueId].transitStatus = _transitStatus;  // change in status that is made by first carrier
        packagemapping[_uniqueId].carrier3 = msg.sender;
        packagemapping[_uniqueId].carrier3_time = now;
        packagemapping[_uniqueId].orderStatus = 3; //order is delivered.
    }
    
    ////////// END Carriers Functions ////////////
    
    
}