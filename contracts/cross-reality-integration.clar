;; Cross-Reality Experience Integration Contract

(define-map integrations
  { integration-id: uint }
  {
    source-branch: uint,
    target-branch: uint,
    experience-hash: (buff 32),
    status: (string-ascii 20)
  }
)

(define-data-var next-integration-id uint u0)

(define-public (integrate-experience (source-branch uint) (target-branch uint) (experience-hash (buff 32)))
  (let
    ((new-id (+ (var-get next-integration-id) u1)))
    (var-set next-integration-id new-id)
    (ok (map-set integrations
      { integration-id: new-id }
      {
        source-branch: source-branch,
        target-branch: target-branch,
        experience-hash: experience-hash,
        status: "pending"
      }
    ))
  )
)

(define-public (update-integration-status (integration-id uint) (new-status (string-ascii 20)))
  (let
    ((integration (unwrap! (map-get? integrations { integration-id: integration-id }) (err u404))))
    (ok (map-set integrations
      { integration-id: integration-id }
      (merge integration { status: new-status })
    ))
  )
)

(define-read-only (get-integration (integration-id uint))
  (map-get? integrations { integration-id: integration-id })
)

