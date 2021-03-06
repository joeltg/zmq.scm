(define ld-library-path "/usr/local/lib/mit-scheme-x86-64/:/usr/local/lib/")
(set-environment-variable! "LD_LIBRARY_PATH" ld-library-path)

(load-option 'ffi)
(c-include "zmq")

(load "zmq-misc")
(load "zmq-poll")
(load "zmq-context")
(load "zmq-message")
(load "zmq-socket")

(define endpoint "tcp://127.0.0.1:1337")

