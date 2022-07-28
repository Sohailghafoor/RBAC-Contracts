// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./Roles.sol";


contract RBAC is ERC721{
    using Roles for Roles.Role;
    Roles.Role private _approvers;

    event ApproverAdded(address indexed account);
    event ApproverRemoved(address indexed account);


    address SuperAdmin;
    address Admin;
    address Authority;


    mapping(address => bool) signed; // Signed flag

    constructor() ERC721("MyToken", "MTK") {
        SuperAdmin = msg.sender;
    }

    modifier onlyApprover() {
        require(isApprover(msg.sender));
        _;
    }
    modifier onlyAuthority() {
       require(isApprover(msg.sender));
        _;
    }
      modifier onlyAdmin() {
       require(isApprover(msg.sender));
        _;
    }
    function isApprover(address account) public view returns (bool) {
        return _approvers.has(account);
    }

    function AddNewSubAdmin(address account) external onlyApprover {
        require(signed[Admin]);
        _addApprover(account);

        signed[Admin] = false;
    }
  function safeMint(address to, uint256 tokenId) payable public onlyAdmin {

     require(msg.value >= 10, "Not enough ETH sent; check price!");
        _safeMint(to, tokenId);
        _transfer(msg.sender, to, msg.value);
    }
    function RemoveNewSubAdmin(address account) external onlyAuthority {
        require(signed[Authority]);
        _removeApprover(account);
        signed[Admin] = false;
    }

    function _addApprover(address account) internal {
        _approvers.add(account);
        emit ApproverAdded(account);
    }

    function _removeApprover(address account) internal {
        _approvers.remove(account);
        emit ApproverRemoved(account);
    }
}