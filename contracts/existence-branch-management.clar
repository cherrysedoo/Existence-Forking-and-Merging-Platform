;; Existence Branch Management Contract

(define-map branches
  { branch-id: uint }
  {
    parent-snapshot: uint,
    branch-hash: (buff 32),
    creator: principal,
    status: (string-ascii 20)
  }
)

(define-data-var next-branch-id uint u0)

(define-public (create-branch (parent-snapshot uint) (branch-hash (buff 32)))
  (let
    ((new-id (+ (var-get next-branch-id) u1)))
    (var-set next-branch-id new-id)
    (ok (map-set branches
      { branch-id: new-id }
      {
        parent-snapshot: parent-snapshot,
        branch-hash: branch-hash,
        creator: tx-sender,
        status: "active"
      }
    ))
  )
)

(define-public (update-branch-status (branch-id uint) (new-status (string-ascii 20)))
  (let
    ((branch (unwrap! (map-get? branches { branch-id: branch-id }) (err u404))))
    (asserts! (is-eq tx-sender (get creator branch)) (err u403))
    (ok (map-set branches
      { branch-id: branch-id }
      (merge branch { status: new-status })
    ))
  )
)

(define-read-only (get-branch (branch-id uint))
  (map-get? branches { branch-id: branch-id })
)

