;; Reality Snapshot Contract

(define-map snapshots
  { snapshot-id: uint }
  {
    universe-hash: (buff 32),
    timestamp: uint,
    creator: principal
  }
)

(define-data-var next-snapshot-id uint u0)

(define-public (create-snapshot (universe-hash (buff 32)))
  (let
    ((new-id (+ (var-get next-snapshot-id) u1)))
    (var-set next-snapshot-id new-id)
    (ok (map-set snapshots
      { snapshot-id: new-id }
      {
        universe-hash: universe-hash,
        timestamp: block-height,
        creator: tx-sender
      }
    ))
  )
)

(define-read-only (get-snapshot (snapshot-id uint))
  (map-get? snapshots { snapshot-id: snapshot-id })
)

(define-read-only (get-latest-snapshot-id)
  (var-get next-snapshot-id)
)

