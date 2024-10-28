// SPDX-License-Identifier: MIT
// author: Othmane Hachad

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DonationNFT.sol";

contract ProjectFactory is Ownable {
    address[] public deployedProjects;

    constructor() {}

    function createProject(string memory _name, uint256 _goalAmount) external {
        Project newProject = new Project(msg.sender, _goalAmount, address(this));
        deployedProjects.push(address(newProject));
    }
}


// Project Contract
contract Project {
    address public owner;
    string public name;
    uint256 public goalAmount;
    uint256 public totalETHFunds;
    uint256 public totalUSDCFunds;
    IERC20 public usdcToken;

    address public lastDonationNFT;
    DonationNFT internal donationNFTContract;
    
    mapping(address => address) public donationNFTtoDonatorAddress;

    constructor(address _owner, uint256 _goalAmount, string memory _name) {
        owner = _owner;
        name = _name;
        goalAmount = _goalAmount;
        usdcToken = IERC20(); // TODO: Set USDC token address
        ProjectNFT(address(this), _owner, _name, "Project");
        donationNFTContract = DonationNFT(abi.encodePacked("Donation", name));
    }

    receive() external payable {
        require(msg.value > 0, "Must send ETH");
        totalETHFunds += msg.value;
        lastDonationNFT = mintDonationNFT(msg.sender, msg.value, "ETH");
        donationNFTtoDonatorAddress[lastDonationNFT] = msg.sender;
    }

    function depositUSDC(uint256 _amount) external {
        require(_amount > 0, "Must deposit some USDC");
        usdcToken.transferFrom(msg.sender, address(this), _amount);
        totalUSDCFunds += _amount;
        lastDonationNFT = mintDonationNFT(msg.sender, _amount, "USDC");
        donationNFTtoDonatorAddress[lastDonationNFT] = msg.sender;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only project owner can withdraw");
        uint256 balance = address(this).balance;
        if (balance > 0) {
            payable(owner).transfer(balance);
        }
        uint256 usdcBalance = usdcToken.balanceOf(address(this));
        if (usdcBalance > 0) {
            usdcToken.transfer(owner, usdcBalance);
        }
    }

    function mintDonationNFT(address donor, uint256 amount, string memory tokenType) internal {
        donationNFTContract.mintDonationNFT(donor, amount, tokenType);
    }

}


contract ProjectNFT is ERC721 {
    uint256 public nextTokenId;
    address public projectAddress;
    

    constructor(address _projectAddress, address _owner, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        nextTokenId = 1;
        projectAddress = _projectAddress;
        mintProjectNFT(_owner, nextTokenId);
    }

    function mintProjectNFT(address to, uint256 tokenId) internal {
        _safeMint(to, tokenId);
        nextTokenId++;

    }
}

