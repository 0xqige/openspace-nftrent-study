// (yinxing)DONE2: : 配置合约ABI
export const marketABI = [
    {
        "type": "constructor",
        "inputs": [],
        "stateMutability": "nonpayable"
    },
    {
        "type": "function",
        "name": "ORDER_TYPE_HASH",
        "inputs": [],
        "outputs": [
            {
                "name": "",
                "type": "bytes32",
                "internalType": "bytes32"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "borrow",
        "inputs": [
            {
                "name": "order",
                "type": "tuple",
                "internalType": "struct RenftMarket.RentoutOrder",
                "components": [
                    {
                        "name": "maker",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "nft_ca",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "token_id",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "daily_rent",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "max_rental_duration",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "min_collateral",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "list_endtime",
                        "type": "uint256",
                        "internalType": "uint256"
                    }
                ]
            },
            {
                "name": "makerSignature",
                "type": "bytes",
                "internalType": "bytes"
            }
        ],
        "outputs": [],
        "stateMutability": "payable"
    },
    {
        "type": "function",
        "name": "cancelOrder",
        "inputs": [
            {
                "name": "order",
                "type": "tuple",
                "internalType": "struct RenftMarket.RentoutOrder",
                "components": [
                    {
                        "name": "maker",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "nft_ca",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "token_id",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "daily_rent",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "max_rental_duration",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "min_collateral",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "list_endtime",
                        "type": "uint256",
                        "internalType": "uint256"
                    }
                ]
            },
            {
                "name": "makerSignatre",
                "type": "bytes",
                "internalType": "bytes"
            }
        ],
        "outputs": [],
        "stateMutability": "nonpayable"
    },
    {
        "type": "function",
        "name": "canceledOrders",
        "inputs": [
            {
                "name": "",
                "type": "bytes32",
                "internalType": "bytes32"
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
        "name": "domainSeparator",
        "inputs": [],
        "outputs": [
            {
                "name": "",
                "type": "bytes32",
                "internalType": "bytes32"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "eip712Domain",
        "inputs": [],
        "outputs": [
            {
                "name": "fields",
                "type": "bytes1",
                "internalType": "bytes1"
            },
            {
                "name": "name",
                "type": "string",
                "internalType": "string"
            },
            {
                "name": "version",
                "type": "string",
                "internalType": "string"
            },
            {
                "name": "chainId",
                "type": "uint256",
                "internalType": "uint256"
            },
            {
                "name": "verifyingContract",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "salt",
                "type": "bytes32",
                "internalType": "bytes32"
            },
            {
                "name": "extensions",
                "type": "uint256[]",
                "internalType": "uint256[]"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "orderHash",
        "inputs": [
            {
                "name": "order",
                "type": "tuple",
                "internalType": "struct RenftMarket.RentoutOrder",
                "components": [
                    {
                        "name": "maker",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "nft_ca",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "token_id",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "daily_rent",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "max_rental_duration",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "min_collateral",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "list_endtime",
                        "type": "uint256",
                        "internalType": "uint256"
                    }
                ]
            }
        ],
        "outputs": [
            {
                "name": "",
                "type": "bytes32",
                "internalType": "bytes32"
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "function",
        "name": "orders",
        "inputs": [
            {
                "name": "",
                "type": "bytes32",
                "internalType": "bytes32"
            }
        ],
        "outputs": [
            {
                "name": "taker",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "collateral",
                "type": "uint256",
                "internalType": "uint256"
            },
            {
                "name": "start_time",
                "type": "uint256",
                "internalType": "uint256"
            },
            {
                "name": "rentinfo",
                "type": "tuple",
                "internalType": "struct RenftMarket.RentoutOrder",
                "components": [
                    {
                        "name": "maker",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "nft_ca",
                        "type": "address",
                        "internalType": "address"
                    },
                    {
                        "name": "token_id",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "daily_rent",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "max_rental_duration",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "min_collateral",
                        "type": "uint256",
                        "internalType": "uint256"
                    },
                    {
                        "name": "list_endtime",
                        "type": "uint256",
                        "internalType": "uint256"
                    }
                ]
            }
        ],
        "stateMutability": "view"
    },
    {
        "type": "event",
        "name": "BorrowNFT",
        "inputs": [
            {
                "name": "taker",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "maker",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "orderHash",
                "type": "bytes32",
                "indexed": false,
                "internalType": "bytes32"
            },
            {
                "name": "collateral",
                "type": "uint256",
                "indexed": false,
                "internalType": "uint256"
            }
        ],
        "anonymous": false
    },
    {
        "type": "event",
        "name": "EIP712DomainChanged",
        "inputs": [],
        "anonymous": false
    },
    {
        "type": "event",
        "name": "OrderCanceled",
        "inputs": [
            {
                "name": "maker",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "orderHash",
                "type": "bytes32",
                "indexed": false,
                "internalType": "bytes32"
            }
        ],
        "anonymous": false
    },
    {
        "type": "error",
        "name": "ECDSAInvalidSignature",
        "inputs": []
    },
    {
        "type": "error",
        "name": "ECDSAInvalidSignatureLength",
        "inputs": [
            {
                "name": "length",
                "type": "uint256",
                "internalType": "uint256"
            }
        ]
    },
    {
        "type": "error",
        "name": "ECDSAInvalidSignatureS",
        "inputs": [
            {
                "name": "s",
                "type": "bytes32",
                "internalType": "bytes32"
            }
        ]
    },
    {
        "type": "error",
        "name": "InvalidShortString",
        "inputs": []
    },
    {
        "type": "error",
        "name": "StringTooLong",
        "inputs": [
            {
                "name": "str",
                "type": "string",
                "internalType": "string"
            }
        ]
    }
];

// ERC721 ABI
export const ERC721ABI = [
    {
        "type": "function",
        "name": "approve",
        "inputs": [
            {
                "name": "_approved",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [],
        "stateMutability": "payable"
    },
    {
        "type": "function",
        "name": "balanceOf",
        "inputs": [
            {
                "name": "_owner",
                "type": "address",
                "internalType": "address"
            }
        ],
        "outputs": [
            {
                "name": "",
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
                "name": "_tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [
            {
                "name": "",
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
                "name": "_owner",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_operator",
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
                "name": "_tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [
            {
                "name": "",
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
                "name": "_from",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_to",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [],
        "stateMutability": "payable"
    },
    {
        "type": "function",
        "name": "safeTransferFrom",
        "inputs": [
            {
                "name": "_from",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_to",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_tokenId",
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
        "stateMutability": "payable"
    },
    {
        "type": "function",
        "name": "setApprovalForAll",
        "inputs": [
            {
                "name": "_operator",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_approved",
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
                "name": "interfaceID",
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
                "name": "_from",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_to",
                "type": "address",
                "internalType": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256",
                "internalType": "uint256"
            }
        ],
        "outputs": [],
        "stateMutability": "payable"
    },
    {
        "type": "event",
        "name": "Approval",
        "inputs": [
            {
                "name": "_owner",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "_approved",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "_tokenId",
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
                "name": "_owner",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "_operator",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "_approved",
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
                "name": "_from",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "_to",
                "type": "address",
                "indexed": true,
                "internalType": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256",
                "indexed": true,
                "internalType": "uint256"
            }
        ],
        "anonymous": false
    }
];
