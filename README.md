# ProofPool - Decentralized Crowdfunding Platform

ProofPool is a decentralized crowdfunding platform built on the Stacks blockchain, leveraging Bitcoin's security and Clarity smart contracts for transparent fund management.

## Features

- Create and manage crowdfunding campaigns with customizable goals and deadlines
- Secure contribution handling with STX tokens
- Automatic fund distribution when campaign goals are met
- Built-in refund mechanism for failed campaigns
- Campaign status tracking and detailed analytics
- Campaign deadline extension functionality
- Campaign cancellation options for unused campaigns
- Comprehensive contribution history tracking
- Transparent campaign verification system
- Integration with PoX (Proof of Transfer) mechanism

## Smart Contract Overview

The smart contract implements the following key functionalities:

### Campaign Management
- Create new campaigns with funding goals and deadlines
- Update campaign deadlines (extension only)
- Cancel empty campaigns
- Campaign status monitoring and reporting
- Optional campaign descriptions

### Contributing System
- Contribute STX tokens to active campaigns
- Track contribution history with timestamps
- Monitor contribution progress
- View detailed campaign analytics

### Fund Management
- Automatic fund locking until campaign goals are met
- Secure fund distribution to campaign owners
- Contributor refund system for failed campaigns
- Protection against unauthorized fund access

## Contract Functions

### Campaign Creation and Management

1. `create-campaign (goal uint) (deadline uint)`
   - Creates a new crowdfunding campaign
   - Parameters:
     - goal: Target amount in STX
     - deadline: Block height for campaign end
   - Returns campaign ID

2. `update-deadline (campaign-id uint) (new-deadline uint)`
   - Extends campaign deadline
   - Only callable by campaign owner
   - New deadline must be later than current deadline

3. `cancel-campaign (campaign-id uint)`
   - Cancels a campaign with no contributions
   - Only callable by campaign owner
   - Campaign must have zero contributions

### Contribution Management

1. `contribute (campaign-id uint) (amount uint)`
   - Contributes STX to a campaign
   - Records contribution timestamp
   - Updates campaign total
   - Returns success status

2. `refund (campaign-id uint)`
   - Claims refund for failed campaigns
   - Available after deadline if goal wasn't met
   - Automatically removes contribution record

### Fund Distribution

1. `claim-funds (campaign-id uint)`
   - Claims raised funds for successful campaigns
   - Only callable by campaign owner
   - Requires goal achievement
   - Prevents double-claiming

### Information and Analytics

1. `get-campaign-status (campaign-id uint)`
   - Returns comprehensive campaign details:
     - Current amount raised
     - Goal progress percentage
     - Remaining time
     - Success status
     - Claim status
     - Activity status

2. `get-contribution-history (campaign-id uint) (contributor principal)`
   - Returns contributor's history:
     - Total amount contributed
     - Last contribution timestamp
     - Campaign association

## Error Handling

The contract includes comprehensive error handling:

- ERR-NOT-AUTHORIZED (u100): Unauthorized access attempt
- ERR-CAMPAIGN-EXISTS (u101): Duplicate campaign creation
- ERR-INVALID-AMOUNT (u102): Invalid contribution amount
- ERR-DEADLINE-PASSED (u103): Expired campaign
- ERR-GOAL-NOT-MET (u104): Insufficient funds raised
- ERR-ALREADY-CLAIMED (u105): Duplicate claim attempt
- ERR-INVALID-CAMPAIGN (u106): Non-existent campaign
- ERR-INVALID-DEADLINE (u107): Invalid deadline update
- ERR-NO-CONTRIBUTION (u108): No contribution found
- ERR-CAMPAIGN-ACTIVE (u109): Campaign has contributions

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

- Time-locked funding prevents premature withdrawals
- Owner-only access for sensitive operations
- Contribution timestamps for audit trails
- Automatic refund mechanism
- Double-claim prevention
- Campaign cancellation restrictions
- Deadline extension limitations

## Example Usage

```clarity
;; Create a new campaign
(contract-call? .proofpool create-campaign u1000000 u1000)

;; Contribute to campaign
(contract-call? .proofpool contribute u1 u50000)

;; Check campaign status
(contract-call? .proofpool get-campaign-status u1)

;; Update campaign deadline
(contract-call? .proofpool update-deadline u1 u2000)

;; View contribution history
(contract-call? .proofpool get-contribution-history u1 tx-sender)

;; Cancel empty campaign
(contract-call? .proofpool cancel-campaign u1)
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request


## Support

For support and questions, please open an issue in the GitHub repository.