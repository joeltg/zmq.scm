;; Contexts

(define zmq-context-options
  '((io-threads          1)
    (max-sockets         2)
    (socket-limit        3)
    (thread-priority     3)
    (thread-sched-policy 4)
    (max-msgsz           5)))

(define (make-zmq-context)
  (let ((context (c-call "zmq_ctx_new" null-alien)))
    (if (alien-null? context)
      (error "could not make context" (get-zmq-error-string))
      context)))

(define (zmq-context-terminate context)
  (if (= -1 (c-call "zmq_ctx_term" context))
    (error "could not terminate context" (get-zmq-error-string))))

(define (zmq-context-shutdown context)
  (if (= -1 (c-call "zmq_ctx_shutdown" context))
    (error "could not shutdown context" (get-zmq-error-string))))

(define (set-zmq-context-option! context option value)
  (if (= -1 (c-call "zmq_ctx_set" context ((zmq-ref zmq-context-options) option) value))
    (error "could not set context option" (get-zmq-error-string))))

(define (zmq-context-option context option)
  (let ((value (c-call "zmq_ctx_get" context ((zmq-ref zmq-context-options) option))))
    (if (= -1 value)
      (error "could not get context option" (get-zmq-error-string))
      value)))
