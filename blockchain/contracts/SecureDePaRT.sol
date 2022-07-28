// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Structure.sol";


contract SecureDePaRT {
       address public immutable i_owner; //This will be the Employe

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Must be a Owner to call this");
        _;
    }


    mapping(address => Structure.Roles) public role; //address mapped to roles
    mapping(address => Structure.ManufactureDetails) public manufacture; //manufacture
    mapping(address => Structure.WarehouseDetails) public warehouse; //warehouse
    mapping(uint256 => Structure.Product) public products; //products to be added by Employe

    event RoleAdded(address _address, Structure.Roles _role);
    event ManufactureAdded(
        uint256 _uid,
        address _address,
        string _manufactureName
    );
    event ProductsAdded(uint256 _uid, string _productName);

    // Used by Employe
    function addRole(address _address, Structure.Roles _role) public onlyOwner{
        require(
            role[_address] == Structure.Roles.NoRole,
            "Role has already been assigned"
        );
        role[_address] = _role;
        emit RoleAdded(_address, _role);
    }

    function getRole(address _address) public view returns (Structure.Roles) {
        return role[_address];
    }

    function addManufacturer(
        uint256 _uid,
        address _address,
        string memory _manufacturerName,
        string memory _manufacturerDetails,
        string memory _location
    ) public {
        manufacture[_address] = Structure.ManufactureDetails(
            _uid,
            _Manufacturer,
            _manufacturerName,
            _manufacturerDetails,
            _location,
            block.timestamp
        );
        emit ManufactureAdded(_uid, _Manufacturer, _manufacturerName);
    }

    // Used by  Manufacturer
    modifier isManufacturer() {
        require(
            role[msg.sender] == Structure.Roles.Manufacturer,
            "Must be a Manufacturer to call this"
        );
        _;
    }
    
      // Used by Warehouse
    modifier isWarehouse() {
        require(
            role[msg.sender] == Structure.Roles.Warehouse,
            "Must be a Warehouse to call this"
        );
        _;
    }

     // Used by Delivery
    modifier isDelivery() {
        require(
            role[msg.sender] == Structure.Roles.DeliveryBoy,
            "Must be a Delivery Boy to call this"
        );
        _;
    }

       // Used by Customer
    modifier isCustomer() {
        require(
            role[msg.sender] == Structure.Roles.Customer,
            "Must be a Customer to call this"
        );
        _;
    }


    function initiateProductHistory(uint256 _uid,Structure.State _state,uint256 latitude,uint256 longitude,uint256 time,
    bool returnStatus,string memory pointName) public {
        products[_uid].history.push(Structure.History(_state,latitude,longitude,time,returnStatus,pointName));
    }

     function updateProductHistory(uint256 _uid,Structure.State _state,uint256 latitude,uint256 longitude,uint256 time,string memory pointName) public {
        bool _returnStatus;
        uint256 len=products[_uid].history.length;
        _returnStatus=products[_uid].history[len-1].returnStatus;
        products[_uid].history.push(Structure.History(_state,latitude,longitude,time,_returnStatus,pointName));
    }

    function addProducts(
        uint256 _uid,
        string memory _productName,
        uint256 _productPrice,
        uint _quantity,
        address _owner,
        address _manufacturer,
        uint _warrantyPeriod,
        bool _warrentyExpire,
        uint256 latitude,
        uint256 longitude,
        string memory pointName
    ) public isManufacturer {
        products[_uid].uid=_uid;
        products[_uid].productName=_productName;
        products[_uid].productPrice=_productPrice;
        products[_uid].quantity=_quantity;
        products[_uid].owner=_owner;
        products[_uid].manufacturer=_manufacturer;
        products[_uid].warrantyPeriod=_warrantyPeriod;
        products[_uid].warrantyExpire=_warrentyExpire;
        products[_uid].productState=Structure.State.ShippedByManufacturer;
        initiateProductHistory(_uid,Structure.State.ShippedByManufacturer,latitude,longitude,block.timestamp,false,pointName);
        emit ProductsAdded(_uid, _productName);
    }
   
    
    function userReturn(
        uint256 _uid

    )public isCustomer{
      uint256 len=products[_uid].history.length;
      Structure.History memory hist= products[_uid].history[len-1];
      hist.returnStatus= true;
      hist.state= Structure.State.UserReturnInitiated;
      products[_uid].history.push(hist);
    }

    function packageDamaged(uint256 _uid) public{
      uint256 len=products[_uid].history.length;
      Structure.History memory hist= products[_uid].history[len-1];
      hist.returnStatus= true;
      hist.state= Structure.State.PackageDamgedAndReturnInitiated;
      products[_uid].history.push(hist);
    }




}
