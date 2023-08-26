// contracts/MSMILLION.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender)
        external
        view
        returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    )
        external
        returns (
            uint amountA,
            uint amountB,
            uint liquidity
        );

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (
            uint amountToken,
            uint amountETH,
            uint liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path)
        external
        view
        returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path)
        external
        view
        returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract MilestoneMillions is ERC20, ERC20Burnable, Ownable {
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled;
    address public operationalFeeReceiver;

    struct TokenInfo {
        string name;
        string symbol;
        address routerAddress;
        address operationalFeeReceiver;
        uint8 maxPercentageForWallet;
        uint8 maxPercentageForTx;
        uint8 feesToSwapPercentage;
        uint8 liquidityFeeRate;
        uint8 operationalFeeRate;
        uint256 totalSupply;
    }
    TokenInfo private _tokenInfo;

    uint256 private numTokensSellToAddToLiquidity;

    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcludeFromTxLimit;
    mapping(address => bool) private _isExcludeFromWalletLimit;

    uint256 tokensForOperations;
    uint256 tokensForLiquidity;

    uint256 public maxAmountForWallet;
    uint256 public maxAmountForTx;

    enum FEES_BRACKET {
        NONE,
        STANDARD,
        DOUBLE
    }

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    event SwapAndLiquifyEnabledUpdated(bool enabled);

    event TransferFee(uint256 operationsTax, uint256 indexed lpTax);
    event OperationsWalletUpdated(address newWallet, address oldWallet);
    event DevWalletUpdated(address newWallet, address oldWallet);

    // Create a uniswap pair for this new token
    address public uniswapV2Pair;
    // set the rest of the contract variables
    IUniswapV2Router02 private uniswapV2Router;

    constructor(TokenInfo memory tokenInfo_)
        ERC20(tokenInfo_.name, tokenInfo_.symbol)
    {
        _tokenInfo = tokenInfo_;

        //Mint tokens
        _mint(owner(), _tokenInfo.totalSupply * 10**18);
        _approve(address(this), _tokenInfo.routerAddress, type(uint256).max);

        //setup uniswap liquidity pair
        uniswapV2Router = IUniswapV2Router02(_tokenInfo.routerAddress);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(this),
                uniswapV2Router.WETH()
            );

        operationalFeeReceiver = _tokenInfo.operationalFeeReceiver;

        //exclude this contract and its associates from fee
        walletExclusions(owner());
        walletExclusions(address(this));
        walletExclusions(operationalFeeReceiver);

        _isExcludeFromTxLimit[_tokenInfo.routerAddress] = true;
        _isExcludeFromWalletLimit[_tokenInfo.routerAddress] = true;
        _isExcludeFromWalletLimit[uniswapV2Pair] = true;
        swapAndLiquifyEnabled = true;

        maxAmountForTx = (totalSupply() * _tokenInfo.maxPercentageForTx) / 100;
        maxAmountForWallet =
            (totalSupply() * _tokenInfo.maxPercentageForWallet) /
            100;
        numTokensSellToAddToLiquidity =
            (totalSupply() * _tokenInfo.feesToSwapPercentage) /
            100;
    }

    function decimals() public view virtual override returns (uint8) {
        return uint8(18);
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function currentFeesStructure()
        public
        view
        virtual
        returns (uint256, uint256)
    {
        return (_tokenInfo.liquidityFeeRate, _tokenInfo.operationalFeeRate);
    }

    function changeFeesStructure(uint8 liquidityFee, uint8 operationalFee)
        public
        virtual
        onlyOwner
    {
        _tokenInfo.liquidityFeeRate = liquidityFee;
        _tokenInfo.operationalFeeRate = operationalFee;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(from != address(0), "Transfer from the zero address");
        require(to != address(0), "Transfer to the zero address");
        require(amount > 0, "Amount less than zero");
        uint256 fromBalance = balanceOf(from);
        require(fromBalance >= amount, "Amount exceeds balance");

        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is uniswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));
        FEES_BRACKET feesMultiplier = FEES_BRACKET.STANDARD;

        bool overMinTokenBalance = contractTokenBalance >=
            numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            from != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            contractTokenBalance = numTokensSellToAddToLiquidity;
            //swap tokens for liquidity and fees
            swapAndLiquify(contractTokenBalance);
        }

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            feesMultiplier = FEES_BRACKET.NONE;
        } else if (to == uniswapV2Pair || to == _tokenInfo.routerAddress) {
            feesMultiplier = FEES_BRACKET.DOUBLE;
        }

        if (!_isExcludeFromTxLimit[from] && !_isExcludeFromTxLimit[to])
            require(maxAmountForTx >= amount, "Amount exceed txn limit");
        if (!_isExcludeFromWalletLimit[to])
            require(
                (balanceOf(to) + amount) <= maxAmountForWallet,
                "Amount exceed wallet limit"
            );

        //transfer amount, it will take all fees
        _tokenTransfer(from, to, amount, feesMultiplier);
    }

    //this method is responsible for taking all fee, depending on FEE Bracket
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        FEES_BRACKET feesMultiplier
    ) private {
        uint256 liquidityFee = calculateLiquidityFee(amount) *
            uint256(feesMultiplier);
        uint256 operationalFee = calculateOperationalFee(amount) *
            uint256(feesMultiplier);
        uint256 transferAmount = (amount - liquidityFee) - operationalFee;

        tokensForLiquidity += liquidityFee;
        tokensForOperations += operationalFee;
        super._transfer(sender, address(this), liquidityFee + operationalFee);
        super._transfer(sender, recipient, transferAmount);
    }

    function calculateLiquidityFee(uint256 _amount)
        private
        view
        returns (uint256)
    {
        return (_amount * _tokenInfo.liquidityFeeRate) / 10**2;
    }

    function calculateOperationalFee(uint256 _amount)
        private
        view
        returns (uint256)
    {
        return (_amount * _tokenInfo.operationalFeeRate) / 10**2;
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 totalFees = contractTokenBalance;

        //Separate the liquidity
        uint256 halfLpFee = tokensForLiquidity / 2;
        totalFees -= halfLpFee;

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(totalFees);

        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance - initialBalance;

        uint256 lpTaxFeeETH = (newBalance * halfLpFee) / totalFees;
        uint256 operationsTaxFeeETH = (newBalance * tokensForOperations) /
            totalFees;

        if (operationsTaxFeeETH > 0) {
            payable(operationalFeeReceiver).transfer(operationsTaxFeeETH);
        }

        // add liquidity to uniswap
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), halfLpFee);
        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: lpTaxFeeETH}(
            address(this),
            halfLpFee,
            0,
            0,
            owner(),
            block.timestamp
        );

        emit TransferFee(tokensForOperations, tokensForLiquidity);
        tokensForOperations = 0;
        tokensForLiquidity = 0;
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function isExcludeFromTxLimit(address account) public view returns (bool) {
        return _isExcludeFromTxLimit[account];
    }

    function excludeFromTxLimit(address account) public onlyOwner {
        _isExcludeFromTxLimit[account] = true;
    }

    function includeInTxLimit(address account) public onlyOwner {
        _isExcludeFromTxLimit[account] = false;
    }

    function isExcludeFromWalletLimit(address account)
        public
        view
        returns (bool)
    {
        return _isExcludeFromWalletLimit[account];
    }

    function excludeFromWalletLimit(address account) public onlyOwner {
        _isExcludeFromWalletLimit[account] = true;
    }

    function includeInWalletLimit(address account) public onlyOwner {
        _isExcludeFromWalletLimit[account] = false;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function updateOperationsWallet(address newWallet) external onlyOwner {
        address oldWallet = operationalFeeReceiver;
        operationalFeeReceiver = newWallet;
        walletExclusions(newWallet);
        emit OperationsWalletUpdated(newWallet, oldWallet);
    }

    function walletExclusions(address walletAddress) private {
        excludeFromTxLimit(walletAddress);
        excludeFromWalletLimit(walletAddress);
        excludeFromFee(walletAddress);
    }

    function setMaxAmountForWallet(uint8 percentage) public onlyOwner {
        _tokenInfo.maxPercentageForWallet = percentage;
        maxAmountForWallet =
            (totalSupply() * _tokenInfo.maxPercentageForWallet) /
            100;
    }

    function setMaxAmountForTxn(uint8 percentage) public onlyOwner {
        _tokenInfo.maxPercentageForTx = percentage;
        maxAmountForTx = (totalSupply() * _tokenInfo.maxPercentageForTx) / 100;
    }

    function setTokenAmountToBeginSwap(uint8 percentage) public onlyOwner {
        _tokenInfo.feesToSwapPercentage = percentage;
        numTokensSellToAddToLiquidity =
            (totalSupply() * _tokenInfo.feesToSwapPercentage) /
            100;
    }

    receive() external payable {}
}
