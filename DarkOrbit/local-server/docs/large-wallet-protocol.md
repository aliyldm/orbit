# Large local wallets

The native compact `AttributeCreditsUpdateCommand` declares both balances as
signed 32-bit integers. A 50,000,000,000 Uridium balance must never be sent in
that message: the integer rotation wraps it before the client receives it.

`game/net.js` now sends the captured `0|A|C|credits|uridium` legacy command when
either balance exceeds the signed integer range or contains a fractional value.
`SetAttributeAssembly.assembleCreditsUpdate()` assigns its strings through
`Number()` / `parseFloat()` to the two `Hero` Number fields and updates the HUD.
This requires no SWF or binary schema change. Ordinary integer balances preserve
the original binary command. No fabricated reward/deduction log or temporarily
clamped balance is sent.

The legacy command changes only credits and Uridium. Jackpot keeps the value
from initialization or its existing separate reward update; it is not replaced
by an obsolete float field every time a large wallet changes.

Initialization uses double balances, `InventoryItemModule.amount` uses a double,
the player database uses numeric balances, and the portal uses JavaScript
Numbers. The common network sender covers all normal shop, CPU, repair,
research, hangar, assembly and other balance update callers. This path permits
exact integer values through `Number.MAX_SAFE_INTEGER` (9,007,199,254,740,991),
and existing representable fractional fuel balances remain supported. Future
amounts must stay in the exact Number range.

`game/admin-wallet.js` provides the explicit, transaction-backed admin grant.
`tools/grant-live.js PID account amount request-key` verifies the server identity
and delegates to it. The grant preserves pending live rewards and fractional
balances, rejects range overflow, records a receipt, and uses the same receipt
key for a safe retry. A reused key with a different amount is rejected. The
server must be restarted with the new common sender before a large live grant.

Verification: `tests/large-wallet.test.js` checks the captured native parser,
53-bit codec round trips, exact 50-billion live grant, replay/rollback, a later
module purchase, initialization, Assembly inventory, portal output and reload.
These tests use an isolated memory database; they do not grant a real account.
