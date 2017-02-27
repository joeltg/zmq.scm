(define ld-library-path "/usr/local/lib/mit-scheme-x86-64/:/usr/local/lib/")
(set-environment-variable! "LD_LIBRARY_PATH" ld-library-path)

(load-option 'ffi)
(c-include "zmq")

(load "zmq-misc")
(load "zmq-poll")
(load "zmq-context")
(load "zmq-message")
(load "zmq-socket")

(define size (c-sizeof "zmq_pollitem_t"))
(define endpoint "tcp://127.0.0.1:1337")

(define server-context (make-zmq-context))
(define server (make-zmq-socket server-context 'rep))
(define client-context (make-zmq-context))
(define client (make-zmq-socket client-context 'req))

(zmq-socket-bind server endpoint)
(zmq-socket-connect client endpoint)

(define server-pollitem
  (malloc (* 2 size) 'zmq_pollitem_t))
(c->= server-pollitem "zmq_pollitem_t socket" server)
(c->= server-pollitem "zmq_pollitem_t events" (make-zmq-poll-event '(pollout pollin)))

(define client-pollitem
  (alien-byte-increment server-pollitem size 'zmq_pollitem_t))
(c->= client-pollitem "zmq_pollitem_t socket" client)
(c->= client-pollitem "zmq_pollitem_t events" (make-zmq-poll-event '(pollout pollin)))


;(define message (malloc (c-sizeof "zmq_msg_t") 'zmq_msg_t))
;(c-call "zmq_msg_init_size" message 4)
;(define data (c-call "zmq_msg_data" (make-alien 'int) message))
;(pp "data:")
;(pp data)
;(pp "data int:")
;(pp (c-> data "int"))

;(pp (c-call "zmq_send" client "hello" 5 0))
