pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


    contract ProjectNFT is ERC721URIStorage {
        address public projectOwner;

        constructor(string memory name, string memory symbol, address _owner) ERC721(name, symbol) {
            projectOwner = _owner;
        }

        function mint(address recipient, uint256 tokenId) external {
            require(msg.sender == projectOwner, "Only project owner can mint");
            _mint(recipient, tokenId);
        }
    }


 contract Project is Ownable {
    string name;
    address owner;

    event Deposity(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);


    constructor(string _name) Project() {
        name = _name;
        owner = payable(msg.sender);
    }

    function withdrawFunds() onlyOwner{
        //owner takes funds out of contract
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available");
        payable(owner()).transfer(balance);
        emit FundsWithdrawn(owner(), balance);
    }

    function donateFunds() external payable {
        require(msg.value > 0, "Donation must be greater than 0");
        emit Deposit(msg.sender, msg.value);
    }

    function mintProjectNFT(address recipient, uint256 tokenId) external onlyOwner {
        projectNFT.mint(recipient, tokenId);
    }


    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        donateFunds();
    }
 }
 
