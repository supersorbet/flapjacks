/* PancakeV3Pool
Solidity API
PancakeV3Pool
factory
address factory
The contract that deployed the pool, which must adhere to the IPancakeV3Factory interface
Return Values
token0
address token0
The first of the two tokens of the pool, sorted by address
Return Values
token1
address token1
The second of the two tokens of the pool, sorted by address
Return Values
fee
uint24 fee
The pool's fee in hundredths of a bip, i.e. 1e-6
Return Values
tickSpacing
int24 tickSpacing
The pool tick spacing
Ticks can only be used at multiples of this value, minimum of 1 and always positive e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ... This value is an int24 to avoid casting even though it is always positive.
Return Values
maxLiquidityPerTick
uint128 maxLiquidityPerTick
The maximum amount of position liquidity that can use any tick in the range
This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
Return Values
PROTOCOL_FEE_SP
uint32 PROTOCOL_FEE_SP
PROTOCOL_FEE_DENOMINATOR
uint256 PROTOCOL_FEE_DENOMINATOR
Slot0
struct Slot0 {
  uint160 sqrtPriceX96;
  int24 tick;
  uint16 observationIndex;
  uint16 observationCardinality;
  uint16 observationCardinalityNext;
  uint32 feeProtocol;
  bool unlocked;
}
slot0
struct PancakeV3Pool.Slot0 slot0
The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas when accessed externally.
Return Values
feeGrowthGlobal0X128
uint256 feeGrowthGlobal0X128
The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
This value can overflow the uint256
feeGrowthGlobal1X128
uint256 feeGrowthGlobal1X128
The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
This value can overflow the uint256
ProtocolFees
struct ProtocolFees {
  uint128 token0;
  uint128 token1;
}
protocolFees
struct PancakeV3Pool.ProtocolFees protocolFees
The amounts of token0 and token1 that are owed to the protocol
Protocol fees will never exceed uint128 max in either token
liquidity
uint128 liquidity
The currently in range liquidity available to the pool
This value has no relationship to the total liquidity across all ticks
ticks
mapping(int24 => struct Tick.Info) ticks
Look up information about a specific tick in the pool
Parameters
Return Values
tickBitmap
mapping(int16 => uint256) tickBitmap
Returns 256 packed tick initialized boolean values. See TickBitmap for more information
positions
mapping(bytes32 => struct Position.Info) positions
Returns the information about a position by the position's key
Parameters
Return Values
observations
struct Oracle.Observation[65535] observations
Returns data about a specific observation index
You most likely want to use #observe() instead of this method to get an observation as of some amount of time ago, rather than at a specific index in the array.
Parameters
Return Values
lmPool
contract IPancakeV3LmPool lmPool
SetLmPoolEvent
event SetLmPoolEvent(address addr)
lock
modifier lock()
Mutually exclusive reentrancy protection into the pool to/from a method. This method also prevents entrance to a function before the pool is initialized. The reentrancy guard is required throughout the contract because we use balance checks to determine the payment status of interactions such as mint, swap and flash.
onlyFactoryOwner
modifier onlyFactoryOwner()
Prevents calling a function from anyone except the address returned by IPancakeV3Factory#owner()
constructor
constructor() public
_blockTimestamp
function _blockTimestamp() internal view virtual returns (uint32)
Returns the block timestamp truncated to 32 bits, i.e. mod 2**32. This method is overridden in tests.
snapshotCumulativesInside
function snapshotCumulativesInside(int24 tickLower, int24 tickUpper) external view returns (int56 tickCumulativeInside, uint160 secondsPerLiquidityInsideX128, uint32 secondsInside)
Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
Snapshots must only be compared to other snapshots, taken over a period for which a position existed. I.e., snapshots cannot be compared if a position is not held for the entire period between when the first snapshot is taken and the second snapshot is taken.
Parameters
Name
Type
Description
tickLower
int24
The lower tick of the range
tickUpper
int24
The upper tick of the range
Return Values
Name
Type
Description
tickCumulativeInside
int56
The snapshot of the tick accumulator for the range
secondsPerLiquidityInsideX128
uint160
The snapshot of seconds per liquidity for the range
secondsInside
uint32
The snapshot of seconds per liquidity for the range
observe
function observe(uint32[] secondsAgos) external view returns (int56[] tickCumulatives, uint160[] secondsPerLiquidityCumulativeX128s)
Returns the cumulative tick and liquidity as of each timestamp secondsAgo from the current block timestamp
To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick, you must call it with secondsAgos = [3600, 0]. The time weighted average tick represents the geometric time weighted average price of the pool, in log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
Parameters
Name
Type
Description
secondsAgos
uint32[]
From how long ago each cumulative tick and liquidity value should be returned
Return Values
Name
Type
Description
tickCumulatives
int56[]
Cumulative tick values as of each secondsAgos from the current block timestamp
secondsPerLiquidityCumulativeX128s
uint160[]
Cumulative seconds per liquidity-in-range value as of each secondsAgos from the current block timestamp
increaseObservationCardinalityNext
function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external
Increase the maximum number of price and liquidity observations that this pool will store
This method is no-op if the pool already has an observationCardinalityNext greater than or equal to the input observationCardinalityNext.
Parameters
Name
Type
Description
observationCardinalityNext
uint16
The desired minimum number of observations for the pool to store
initialize
function initialize(uint160 sqrtPriceX96) external
Sets the initial price for the pool
not locked because it initializes unlocked
Parameters
Name
Type
Description
sqrtPriceX96
uint160
the initial sqrt price of the pool as a Q64.96
ModifyPositionParams
struct ModifyPositionParams {
  address owner;
  int24 tickLower;
  int24 tickUpper;
  int128 liquidityDelta;
}
mint
function mint(address recipient, int24 tickLower, int24 tickUpper, uint128 amount, bytes data) external returns (uint256 amount0, uint256 amount1)
Adds liquidity for the given recipient/tickLower/tickUpper position
_noDelegateCall is applied indirectly via modifyPosition
Parameters
Name
Type
Description
recipient
address
The address for which the liquidity will be created
tickLower
int24
The lower tick of the position in which to add liquidity
tickUpper
int24
The upper tick of the position in which to add liquidity
amount
uint128
The amount of liquidity to mint
data
bytes
Any data that should be passed through to the callback
Return Values
Name
Type
Description
amount0
uint256
The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
amount1
uint256
The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
collect
function collect(address recipient, int24 tickLower, int24 tickUpper, uint128 amount0Requested, uint128 amount1Requested) external returns (uint128 amount0, uint128 amount1)
Collects tokens owed to a position
Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity. Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
Parameters
Name
Type
Description
recipient
address
The address which should receive the fees collected
tickLower
int24
The lower tick of the position for which to collect fees
tickUpper
int24
The upper tick of the position for which to collect fees
amount0Requested
uint128
How much token0 should be withdrawn from the fees owed
amount1Requested
uint128
How much token1 should be withdrawn from the fees owed
Return Values
Name
Type
Description
amount0
uint128
The amount of fees collected in token0
amount1
uint128
The amount of fees collected in token1
burn
function burn(int24 tickLower, int24 tickUpper, uint128 amount) external returns (uint256 amount0, uint256 amount1)
Burn liquidity from the sender and account tokens owed for the liquidity to the position
_noDelegateCall is applied indirectly via modifyPosition
Parameters
Name
Type
Description
tickLower
int24
The lower tick of the position for which to burn liquidity
tickUpper
int24
The upper tick of the position for which to burn liquidity
amount
uint128
How much liquidity to burn
Return Values
Name
Type
Description
amount0
uint256
The amount of token0 sent to the recipient
amount1
uint256
The amount of token1 sent to the recipient
SwapCache
struct SwapCache {
  uint32 feeProtocol;
  uint128 liquidityStart;
  uint32 blockTimestamp;
  int56 tickCumulative;
  uint160 secondsPerLiquidityCumulativeX128;
  bool computedLatestObservation;
}
SwapState
struct SwapState {
  int256 amountSpecifiedRemaining;
  int256 amountCalculated;
  uint160 sqrtPriceX96;
  int24 tick;
  uint256 feeGrowthGlobalX128;
  uint128 protocolFee;
  uint128 liquidity;
}
StepComputations
struct StepComputations {
  uint160 sqrtPriceStartX96;
  int24 tickNext;
  bool initialized;
  uint160 sqrtPriceNextX96;
  uint256 amountIn;
  uint256 amountOut;
  uint256 feeAmount;
}
swap
function swap(address recipient, bool zeroForOne, int256 amountSpecified, uint160 sqrtPriceLimitX96, bytes data) external returns (int256 amount0, int256 amount1)
Swap token0 for token1, or token1 for token0
The caller of this method receives a callback in the form of IPancakeV3SwapCallback#pancakeV3SwapCallback
Parameters
Name
Type
Description
recipient
address
The address to receive the output of the swap
zeroForOne
bool
The direction of the swap, true for token0 to token1, false for token1 to token0
amountSpecified
int256
The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
sqrtPriceLimitX96
uint160
The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this value after the swap. If one for zero, the price cannot be greater than this value after the swap
data
bytes
Any data to be passed through to the callback
Return Values
Name
Type
Description
amount0
int256
The delta of the balance of token0 of the pool, exact when negative, minimum when positive
amount1
int256
The delta of the balance of token1 of the pool, exact when negative, minimum when positive
flash
function flash(address recipient, uint256 amount0, uint256 amount1, bytes data) external
Receive token0 and/or token1 and pay it back, plus a fee, in the callback
The caller of this method receives a callback in the form of IPancakeV3FlashCallback#pancakeV3FlashCallback Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling with 0 amount{0,1} and sending the donation amount(s) from the callback
Parameters
Name
Type
Description
recipient
address
The address which will receive the token0 and token1 amounts
amount0
uint256
The amount of token0 to send
amount1
uint256
The amount of token1 to send
data
bytes
Any data to be passed through to the callback
setFeeProtocol
function setFeeProtocol(uint32 feeProtocol0, uint32 feeProtocol1) external
Set the denominator of the protocol's % share of the fees
Parameters
Name
Type
Description
feeProtocol0
uint32
new protocol fee for token0 of the pool
feeProtocol1
uint32
new protocol fee for token1 of the pool
collectProtocol
function collectProtocol(address recipient, uint128 amount0Requested, uint128 amount1Requested) external returns (uint128 amount0, uint128 amount1)
Collect the protocol fee accrued to the pool
Parameters
Name
Type
Description
recipient
address
The address to which collected protocol fees should be sent
amount0Requested
uint128
The maximum amount of token0 to send, can be 0 to collect fees in only token1
amount1Requested
uint128
The maximum amount of token1 to send, can be 0 to collect fees in only token0
Return Values
Name
Type
Description
amount0
uint128
The protocol fee collected in token0
amount1
uint128
The protocol fee collected in token1
setLmPool
function setLmPool(contract IPancakeV3LmPool _lmPool) external
*/