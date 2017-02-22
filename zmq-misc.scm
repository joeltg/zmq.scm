(define zmq-group-max-length 15)
(define zmq-pollin 1)
(define zmq-pollout 2)
(define zmq-pollerr 4)
(define zmq-pollpri 8)

(define ((zmq-ref table) property)
  (let ((entry (assq property table)))
    (if entry (cadr entry) (error "invalid property" property))))

(define (get-zmq-flags flags)
  (if (default-object? flags)
    0
    (fold-left + 0 (map (zmq-ref zmq-flags) flags))))

(define (get-zmq-error)
  (c-call "zmq_errno"))

(define (get-zmq-error-string)
  (c-peek-cstring (c-call "zmq_strerror" null-alien (get-zmq-error))))

;; I/O
(define (zmq-poll items nitems timeout)
  (c-call "zmq_poll" items nitems timeout))

;; Proxy
(define (zmq-proxy frontend backend capture)
  (c-call "zmq_proxy" frontend backend capture))

(define (zmq-proxy-steerable frontend backend capture control)
  (c-call "zmq_proxy_steerable" frontend backend capture control))

;; Probe
(define (zmq-has? capability)
  (= (c-call "zmq_has" capability) 1))

;; Crypto
(define (zmq-z85-encode dest data size)
  (c-call "zmq_z85_encode" dest data size))

(define (zmq-z85-decode dest string)
  (c-call "zmq_z85_decode" dest string))

(define (zmq-curve-keypair public secret)
  (c-call "zmq_curve_keypair" public secret))

(define (zmq-curve-public public secret)
  (c-call "zmq_curve_public" public secret))

; Atomic
(define (make-zmq-atomic-counter)
  (c-call "zmq_atomic_counter_new" null-alien))

(define (zmq-atomic-counter-set! counter value)
  (c-call "zmq_atomic_counter_set" counter value))

(define (zmq-atomic-counter-inc! counter)
  (c-call "zmq_atomic_counter_inc" counter))

(define (zmq-atomic-counter-dec! counter)
  (c-call "zmq_atomic_counter_dec" counter))

(define (zmq-atomic-counter-value counter)
  (c-call "zmq_atomic_counter_value" counter))

(define (zmq-atomic-counter-destroy! counter_p)
  (c-call "zmq_atomic_counter_destroy" counter_p))

(define zmq-flags
  '((dontwait 1)
    (sndmore 2)))

(define zmq-security-mechanisms
  '((zmq-null 0)
    (zmq-plain 1)
    (zmq-curve 2)
    (zmq-gssapi 3)))
