// TODO: 配置合约ABI
export const marketABI = [{ "inputs": [], "stateMutability": "nonpayable", "type": "constructor" }, { "inputs": [], "name": "ECDSAInvalidSignature", "type": "error" }, { "inputs": [{ "internalType": "uint256", "name": "length", "type": "uint256" }], "name": "ECDSAInvalidSignatureLength", "type": "error" }, { "inputs": [{ "internalType": "bytes32", "name": "s", "type": "bytes32" }], "name": "ECDSAInvalidSignatureS", "type": "error" }, { "inputs": [], "name": "InvalidShortString", "type": "error" }, { "inputs": [{ "internalType": "string", "name": "str", "type": "string" }], "name": "StringTooLong", "type": "error" }, { "anonymous": false, "inputs": [{ "indexed": true, "internalType": "address", "name": "taker", "type": "address" }, { "indexed": true, "internalType": "address", "name": "maker", "type": "address" }, { "indexed": false, "internalType": "bytes32", "name": "orderHash", "type": "bytes32" }, { "indexed": false, "internalType": "uint256", "name": "collateral", "type": "uint256" }], "name": "BorrowNFT", "type": "event" }, { "anonymous": false, "inputs": [], "name": "EIP712DomainChanged", "type": "event" }, { "anonymous": false, "inputs": [{ "indexed": true, "internalType": "address", "name": "maker", "type": "address" }, { "indexed": false, "internalType": "bytes32", "name": "orderHash", "type": "bytes32" }], "name": "OrderCanceled", "type": "event" }, { "inputs": [], "name": "ORDER_HASH", "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "components": [{ "internalType": "address", "name": "maker", "type": "address" }, { "internalType": "address", "name": "nft_ca", "type": "address" }, { "internalType": "uint256", "name": "token_id", "type": "uint256" }, { "internalType": "uint256", "name": "daily_rent", "type": "uint256" }, { "internalType": "uint256", "name": "max_rental_duration", "type": "uint256" }, { "internalType": "uint256", "name": "min_collateral", "type": "uint256" }, { "internalType": "uint256", "name": "list_endtime", "type": "uint256" }], "internalType": "struct RenftMarket.RentoutOrder", "name": "order", "type": "tuple" }, { "internalType": "bytes", "name": "makerSignature", "type": "bytes" }], "name": "borrow", "outputs": [], "stateMutability": "payable", "type": "function" }, { "inputs": [{ "components": [{ "internalType": "address", "name": "maker", "type": "address" }, { "internalType": "address", "name": "nft_ca", "type": "address" }, { "internalType": "uint256", "name": "token_id", "type": "uint256" }, { "internalType": "uint256", "name": "daily_rent", "type": "uint256" }, { "internalType": "uint256", "name": "max_rental_duration", "type": "uint256" }, { "internalType": "uint256", "name": "min_collateral", "type": "uint256" }, { "internalType": "uint256", "name": "list_endtime", "type": "uint256" }], "internalType": "struct RenftMarket.RentoutOrder", "name": "order", "type": "tuple" }, { "internalType": "bytes", "name": "signatre", "type": "bytes" }], "name": "cancelOrder", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }], "name": "canceledOrders", "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "domainSeparatorV4", "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "eip712Domain", "outputs": [{ "internalType": "bytes1", "name": "fields", "type": "bytes1" }, { "internalType": "string", "name": "name", "type": "string" }, { "internalType": "string", "name": "version", "type": "string" }, { "internalType": "uint256", "name": "chainId", "type": "uint256" }, { "internalType": "address", "name": "verifyingContract", "type": "address" }, { "internalType": "bytes32", "name": "salt", "type": "bytes32" }, { "internalType": "uint256[]", "name": "extensions", "type": "uint256[]" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "components": [{ "internalType": "address", "name": "maker", "type": "address" }, { "internalType": "address", "name": "nft_ca", "type": "address" }, { "internalType": "uint256", "name": "token_id", "type": "uint256" }, { "internalType": "uint256", "name": "daily_rent", "type": "uint256" }, { "internalType": "uint256", "name": "max_rental_duration", "type": "uint256" }, { "internalType": "uint256", "name": "min_collateral", "type": "uint256" }, { "internalType": "uint256", "name": "list_endtime", "type": "uint256" }], "internalType": "struct RenftMarket.RentoutOrder", "name": "order", "type": "tuple" }], "name": "orderHash", "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }], "name": "orders", "outputs": [{ "internalType": "address", "name": "taker", "type": "address" }, { "internalType": "uint256", "name": "collateral", "type": "uint256" }, { "internalType": "uint256", "name": "start_time", "type": "uint256" }, { "components": [{ "internalType": "address", "name": "maker", "type": "address" }, { "internalType": "address", "name": "nft_ca", "type": "address" }, { "internalType": "uint256", "name": "token_id", "type": "uint256" }, { "internalType": "uint256", "name": "daily_rent", "type": "uint256" }, { "internalType": "uint256", "name": "max_rental_duration", "type": "uint256" }, { "internalType": "uint256", "name": "min_collateral", "type": "uint256" }, { "internalType": "uint256", "name": "list_endtime", "type": "uint256" }], "internalType": "struct RenftMarket.RentoutOrder", "name": "rentinfo", "type": "tuple" }], "stateMutability": "view", "type": "function" }];

// ERC721 ABI
export const ERC721ABI = [
    {
        "type": "function",
        "name": "approve",
        "inputs": [
            {
                "name": "to",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [],
        "stateMutability": "nonpayable"
    },
    {
        "type": "function",
        "name": "balanceOf",
        "inputs": [
            {
                "name": "owner",
                "type": "address",
                "internalType": "address"
            }
        ],
        "outputs": [
            {
                "name": "balance",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "getApproved",
        "inputs": [
            {
                "name": "tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [
            {
                "name": "operator",
                "type": "address",
                "internalType": "address"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "isApprovedForAll",
        "inputs": [
            {
                "name": "owner",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "operator",
                "type": "address",
                "internalType": "address"
            }
        ],
        "outputs": [
            {
                "name": "",
                "type": "bool",
                "internalType": "bool"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "ownerOf",
        "inputs": [
            {
                "name": "tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [
            {
                "name": "owner",
                "type": "address",
                "internalType": "address"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "safeTransferFrom",
        "inputs": [
            {
                "name": "from",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "to",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [],
        "stateMutability": "nonpayable"
    },
    {
        "type": "function",
        "name": "safeTransferFrom",
        "inputs": [
            {
                "name": "from",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "to",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "tokenId",
                "type": "uint256",
                "internalType": "uint256"
            },
            {
                "name": "data",
                "type": "bytes",
                "internalType": "bytes"
            }
        ],
        "outputs": [],
        "stateMutability": "nonpayable"
    },
    {
        "type": "function",
        "name": "setApprovalForAll",
        "inputs": [
            {
                "name": "operator",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "approved",
                "type": "bool",
                "internalType": "bool"
            }
        ],
        "outputs": [],
        "stateMutability": "nonpayable"
    },
    {
        "type": "function",
        "name": "supportsInterface",
        "inputs": [
            {
                "name": "interfaceId",
                "type": "bytes4",
                "internalType": "bytes4"
            }
        ],
        "outputs": [
            {
                "name": "",
                "type": "bool",
                "internalType": "bool"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "transferFrom",
        "inputs": [
            {
                "name": "from",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "to",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [],
        "stateMutability": "nonpayable"
    },
    {
        "type": "event",
        "name": "Approval",
        "inputs": [
            {
                "name": "owner",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "approved",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "tokenId",
                "type": "uint256",
                "indexed": true,
                "internalType": "uint256"
            }
        ],
        "anonymous": false
    },
    {
        "type": "event",
        "name": "ApprovalForAll",
        "inputs": [
            {
                "name": "owner",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "operator",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "approved",
                "type": "bool",
                "indexed": false,
                "internalType": "bool"
            }
        ],
        "anonymous": false
    },
    {
        "type": "event",
        "name": "Transfer",
        "inputs": [
            {
                "name": "from",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "to",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "tokenId",
                "type": "uint256",
                "indexed": true,
                "internalType": "uint256"
            }
        ],
        "anonymous": false
    }
];
