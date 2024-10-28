// DonationNFT Contract
contract DonationNFT is ERC721 {
    uint256 public nextTokenId;
    string public tokenType;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mintDonationNFT(address to, uint256 amount, string memory _tokenType) external {
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _safeMint(to, tokenId);
        tokenType = _tokenType;

        // Store donation metadata (amount, tokenType) - could be off-chain using IPFS
    }
}