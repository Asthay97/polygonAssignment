// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/*
 * @dev Extension of {ERC20} that allows token holders to use their tokens
 * without sending any transactions by setting Allowance with a
 * signature using the {permit} method, and then spend them via
 * {IERC20-transferFrom}.
 *
 * The {permit} signature mechanism is in accordance with ERC2612.
 */
contract ERC20Permit is ERC20{
    mapping(address => uint) private _nonces;
    uint256 constant UINT_MAX = 2**256 -1;
    bytes32 public domainSeperator;
    bytes32 private constant _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    
    /**
     *  @dev Initializes the {EIP712} domain separator using the name parameter, and setting version to `"1"`.
     */
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
        uint chainId;
        assembly {
            chainId := chainid()
        }
        domainSeperator = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes("Dai stablecoin")),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    /**
     * @dev Sets max value as the allowance of `spender` over `owner`'s tokens,
     * given `owner`'s signed approval. Amount has been removed only because of max amount for allowance. Else it can be given in input(as in ERC2612)
     */
    function permit(
        address owner,
        address spender,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, UINT_MAX, _nonces[owner]++, deadline));
        bytes32 hash = keccak256(abi.encodePacked("\x19\x01", domainSeperator, structHash));

        //Verify the signature
        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");

        //For max allowance
        _approve(owner, spender, UINT_MAX);
    }

    /**
     *  @dev Sets max value as the allowance of `spender` over `owner`'s tokens,
     * given `owner`'s signed approval. Amount has been removed only because of max amount for allowance. Else it can be given in input(as in ERC2612).
     * To be noted: It is not in accordance to ERC2612, but can be used incase the spender wants to provide only the signature instead of v,r,s values
     */
    function permitUsingSignature(
        address owner,
        address spender,
        uint256 deadline,
        bytes memory signature
    ) public {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, UINT_MAX, _nonces[owner]++, deadline));
        bytes32 hash = keccak256(abi.encodePacked("\x19\x01", domainSeperator, structHash));

        //Verify the signature
        address signer = ECDSA.recover(hash, signature);
        require(signer == owner, "ERC20Permit: invalid signature");

        //For max allowance
        _approve(owner, spender, UINT_MAX);
    }

    /**
     * @dev Returns the current ERC2612 nonce for `owner`.
     * Every successful call to {permit} increases owners nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) public view returns (uint256) {
        return _nonces[owner];
    }

    function DOMAIN_SEPARATOR() external view returns (bytes32){
        return domainSeperator;
    }
}
