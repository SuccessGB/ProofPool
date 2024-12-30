
# ProofPool - Decentralized Crowdfunding Platform

ProofPool is a decentralized crowdfunding platform built on the Stacks blockchain, leveraging Bitcoin's security and Clarity smart contracts for transparent fund management.

## Features

- Create crowdfunding campaigns with customizable goals and deadlines
- Secure contribution handling with STX tokens
- Automatic fund distribution when campaign goals are met
- Built-in refund mechanism for failed campaigns
- Transparent campaign verification system
- Integration with PoX (Proof of Transfer) mechanism

## Smart Contract Overview

The smart contract implements the following key functionalities:

### Campaign Creation
- Campaign owners can create new campaigns with specified funding goals and deadlines
- Each campaign gets a unique identifier
- Initial campaign status is set to "active"

### Contributing
- Users can contribute STX tokens to active campaigns
- Contributions are tracked per user and campaign
- Built-in checks for campaign deadline and validity

### Fund Management
- Automatic fund locking until campaign goals are met
- Campaign owners can claim funds only if goal is reached
- Contributors can claim refunds if campaign fails

### Security Features
- Time-locked funding using Stacks' post-conditions
- Error handling for various edge cases
- Permission controls for fund management

## Contract Functions

### Public Functions

1. `create-campaign (goal uint) (deadline uint)`
   - Creates a new crowdfunding campaign
   - Parameters:
     - goal: Target amount in STX
     - deadline: Block height for campaign end

2. `contribute (campaign-id uint) (amount uint)`
   - Contributes STX to a campaign
   - Parameters:
     - campaign-id: Unique campaign identifier
     - amount: Contribution amount in STX

3. `claim-funds (campaign-id uint)`
   - Allows campaign owner to claim funds if goal is met
   - Only callable by campaign owner

4. `refund (campaign-id uint)`
   - Allows contributors to claim refunds for failed campaigns
   - Only available after deadline if goal wasn't met

### Read-Only Functions

1. `get-campaign-details (campaign-id uint)`
   - Returns detailed information about a campaign

2. `get-contribution (campaign-id uint) (contributor principal)`
   - Returns contribution amount for a specific user

## Usage Examples

```clarity
;; Create a new campaign
(contract-call? .proofpool create-campaign u1000000 u1000)

;; Contribute to a campaign
(contract-call? .proofpool contribute u1 u50000)

;; Check campaign details
(contract-call? .proofpool get-campaign-details u1)
```

## Development Setup

1. Install Clarinet for local development:
```bash
curl -L https://github.com/hirosystems/clarinet/releases/download/v1.0.0/clarinet-linux-x64.tar.gz | tar xz
```

2. Initialize a new Clarity project:
```bash
clarinet new proofpool
```

3. Deploy the contract:
```bash
clarinet deploy
```

## Testing

Run the test suite:
```bash
clarinet test
```

## Security Considerations

- All financial transactions are handled through the smart contract
- Time-locks prevent premature fund withdrawal
- Built-in checks prevent double-claiming and unauthorized access
- Automatic refund mechanism protects contributors

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
