
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DonateToken is ERC20, Ownable {
    uint256 totalsupplycap;
    uint256 individualCap;
    uint256 tokenID;

    constructor(uint256 _totalSupplyCap, uint256 _individualCap) ERC20("DonateToken", "DT"){
        totalsupplycap = _totalSupplyCap;
        individualCap = _individualCap;
    }
    
    function mintToken(address _minter, uint amount) {
        require(totalSupply() + amount <= totalSupplyCap, "Exceeds total supply cap");
        require(balanceOf(_minter) + amount <= individualCap, "Exceeds individual cap");
        
        _mint(_minter, amount);
    }

    function transfer(address _owner, address _to, uint256 _value) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(balanceOf(recipient) + amount <= individualCap, "Recipient exceeds individual cap");

        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function setCaps(uint256 _newTotalCap, uint256 _newIndividualCap) external onlyOwner {
        totalSupplyCap = _newTotalCap;
        individualCap = _newIndividualCap;
    }
}