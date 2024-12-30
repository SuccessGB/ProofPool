;; ProofPool Smart Contract
;; Decentralized Crowdfunding Platform with Bitcoin-backed security

;; Constants
(define-constant contract-owner tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-CAMPAIGN-EXISTS (err u101))
(define-constant ERR-INVALID-AMOUNT (err u102))
(define-constant ERR-DEADLINE-PASSED (err u103))
(define-constant ERR-GOAL-NOT-MET (err u104))
(define-constant ERR-ALREADY-CLAIMED (err u105))

;; Data Maps
(define-map campaigns
    { campaign-id: uint }
    {
        owner: principal,
        goal: uint,
        deadline: uint,
        total-raised: uint,
        claimed: bool,
        status: (string-ascii 20)
    }
)

(define-map contributions
    { campaign-id: uint, contributor: principal }
    { amount: uint }
)

;; Campaign counter
(define-data-var campaign-counter uint u0)

;; Public functions
(define-public (create-campaign (goal uint) (deadline uint))
    (let
        (
            (campaign-id (var-get campaign-counter))
        )
        (asserts! (> goal u0) ERR-INVALID-AMOUNT)
        (asserts! (> deadline block-height) ERR-DEADLINE-PASSED)
        (map-insert campaigns
            { campaign-id: campaign-id }
            {
                owner: tx-sender,
                goal: goal,
                deadline: deadline,
                total-raised: u0,
                claimed: false,
                status: "active"
            }
        )
        (var-set campaign-counter (+ campaign-id u1))
        (ok campaign-id)
    )
)

(define-public (contribute (campaign-id uint) (amount uint))
    (let
        (
            (campaign (unwrap! (map-get? campaigns { campaign-id: campaign-id }) ERR-NOT-AUTHORIZED))
            (current-total (get total-raised campaign))
        )
        (asserts! (> amount u0) ERR-INVALID-AMOUNT)
        (asserts! (< block-height (get deadline campaign)) ERR-DEADLINE-PASSED)
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set campaigns
            { campaign-id: campaign-id }
            (merge campaign { total-raised: (+ current-total amount) })
        )
        (map-set contributions
            { campaign-id: campaign-id, contributor: tx-sender }
            { amount: amount }
        )
        (ok true)
    )
)

(define-public (claim-funds (campaign-id uint))
    (let
        (
            (campaign (unwrap! (map-get? campaigns { campaign-id: campaign-id }) ERR-NOT-AUTHORIZED))
        )
        (asserts! (is-eq tx-sender (get owner campaign)) ERR-NOT-AUTHORIZED)
        (asserts! (>= (get total-raised campaign) (get goal campaign)) ERR-GOAL-NOT-MET)
        (asserts! (not (get claimed campaign)) ERR-ALREADY-CLAIMED)
        (try! (as-contract (stx-transfer? (get total-raised campaign) tx-sender (get owner campaign))))
        (map-set campaigns
            { campaign-id: campaign-id }
            (merge campaign { claimed: true, status: "completed" })
        )
        (ok true)
    )
)

(define-public (refund (campaign-id uint))
    (let
        (
            (campaign (unwrap! (map-get? campaigns { campaign-id: campaign-id }) ERR-NOT-AUTHORIZED))
            (contribution (unwrap! (map-get? contributions { campaign-id: campaign-id, contributor: tx-sender }) ERR-NOT-AUTHORIZED))
        )
        (asserts! (> block-height (get deadline campaign)) ERR-DEADLINE-PASSED)
        (asserts! (< (get total-raised campaign) (get goal campaign)) ERR-GOAL-NOT-MET)
        (try! (as-contract (stx-transfer? (get amount contribution) tx-sender tx-sender)))
        (map-delete contributions { campaign-id: campaign-id, contributor: tx-sender })
        (ok true)
    )
)

;; Read-only functions
(define-read-only (get-campaign-details (campaign-id uint))
    (map-get? campaigns { campaign-id: campaign-id })
)

(define-read-only (get-contribution (campaign-id uint) (contributor principal))
    (map-get? contributions { campaign-id: campaign-id, contributor: contributor })
)
