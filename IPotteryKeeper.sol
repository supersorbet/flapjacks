pragma solidity ^0.8.0;

interface IPotteryKeeper {
    function addActiveVault(address _vault) external;

    function removeActiveVault(address _vault, uint256 _pos) external;
}