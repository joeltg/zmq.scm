(define ld-library-path "/usr/local/lib/mit-scheme-x86-64/:/usr/local/lib/")
(set-environment-variable! "LD_LIBRARY_PATH" ld-library-path)

(load-option 'ffi)
(c-include "zmq")

(load "zmq-misc")
(load "zmq-poll")
(load "zmq-context")
(load "zmq-message")
(load "zmq-socket")

(define poll-size (c-sizeof "zmq_pollitem_t"))
(define message-size (c-sizeof "zmq_msg_t"))
(define pointer-size (c-sizeof "*"))
(define endpoint "tcp://127.0.0.1:1337")

(define context (make-zmq-context))
(define socket (make-zmq-socket context 'req))

(zmq-socket-connect socket endpoint)

(define pollitem (make-zmq-pollitem socket '(pollout pollin)))

(define (check)
  (zmq-poll pollitem 1 0)
  (zmq-pollitem-revents pollitem))

;(zmq-send socket "hello world")
