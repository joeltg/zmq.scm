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
(define socket (make-zmq-socket context 'rep))

(zmq-socket-bind socket endpoint)

(define pollitem (make-zmq-pollitem socket '(pollout pollin)))

(define (check)
  (zmq-poll pollitem 1 0)
  (zmq-pollitem-revents pollitem))

;(let iter ((status (zmq-pollitem-revents pollitem)))
;  (if (= status 1)
;    (let ((pointer (make-message-pointer)))
;      (c-call "zmq_msg_recv" socket pointer 0))
;    (let ((buf (malloc frame 'cstring))
;          (puf (malloc 8 '(* cstring))))
;      (c-poke-pointer puf buf)
;      (c-call "zmq_recv" socket puf frame 0)
;      (pp (c-peek-cstring puf))
;      (zmq-poll pollitem 1 0)
;      (iter (zmq-pollitem-revents pollitem)))
;  (begin
;    (zmq-poll pollitem 1 0)
;    (iter (zmq-pollitem-revents pollitem)))))
