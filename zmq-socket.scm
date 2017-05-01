;; Sockets

(define (make-zmq-socket context type)
  (let ((a (malloc 8 '(* void)))
	(t ((zmq-ref zmq-socket-types) type)))
    (let ((socket (c-call "zmq_socket" a context t)))
      (if (alien-null? socket)
	  (error "could not make socket" (get-zmq-error-string))
	  socket))))

(define (zmq-socket-close socket)
  (if (= -1 (c-call "zmq_close" socket))
    (error "could not close socket" (get-zmq-error-string))))

(define (zmq-socket-option socket option)
  (let ((opt ((zmq-ref zmq-socket-options) option)))
    (if opt
	(let ((len (malloc 8 'size_t)))
	  (let ((val (alien-byte-increment len 4 'int)))
	    (c->= len "int" 4)
	    (c->= val "int" 0)
	    (if (= -1 (c-call "zmq_getsockopt" socket opt val len))
		(error "could not get socket option"
		       (get-zmq-error-string))
		(c-> val "int"))))
	(error "invalid socket option"))))

(define (set-zmq-socket-option! socket option value)
  (let ((opt ((zmq-ref zmq-socket-options) option)))
    (if opt
	(let ((val (malloc 4 `(const ,type))))
	  (c->= val "int" value)
	  (if (= -1 (c-call "zmq_setsockopt" socket opt val 4))
	      (error "could not set socket option"
		     (get-zmq-error-string))))
	(error "invalid socket option"))))

(define (zmq-socket-bind socket address)
  (if (= -1 (c-call "zmq_bind" socket address))
    (error "could not bind socket" (get-zmq-error-string))))

(define (zmq-socket-connect socket address)
  (if (= -1 (c-call "zmq_connect" socket address))
    (error "could not connect socket" (get-zmq-error-string))))

(define (zmq-socket-unbind socket address)
  (if (= -1 (c-call "zmq_unbind" socket address))
    (error "could not unbind socket" (get-zmq-error-string))))

(define (zmq-socket-disconnect socket address)
  (if (= -1 (c-call "zmq_disconnect" socket address))
    (error "could not disconnect socket" (get-zmq-error-string))))

(define (zmq-socket-send socket buffer length #!optional flags)
  (if (= -1 (c-call "zmq_send" socket buffer length (get-zmq-flags flags)))
    (error "could not send socket" (get-zmq-error-string))))

(define (zmq-socket-receive socket buffer length #!optional flags)
  (if (= -1 (c-call "zmq_recv" socket buffer length (get-zmq-flags flags)))
    (error "could not receive socket" (get-zmq-error-string))))

(define (get-zmq-socket-events events)
  (cond
    ((default-object? events) 0)
    ((number? events) events)
    ((list? events) (fold-left + 0 (map (zmq-ref zmq-socket-events) events)))
    (else (error "invalid socket event" events))))

(define zmq-socket-types
  '((pair   0)
    (pub    1)
    (sub    2)
    (req    3)
    (rep    4)
    (dealer 5)
    (router 6)
    (pull   7)
    (push   8)
    (xpub   9)
    (xsub   10)
    (stream 11)))

(define zmq-socket-events
  '((event-connected         0x0001)
    (event-connect-delayed   0x0002)
    (event-connect-retried   0x0004)
    (event-listening         0x0008)
    (event-bind-failed       0x0010)
    (event-accepted          0x0020)
    (event-accept-failed     0x0040)
    (event-closed            0x0080)
    (event-close-failed      0x0100)
    (event-disconnected      0x0200)
    (event-monitor-stopped   0x0400)
    (event-all               0xffff)))

(define zmq-socket-options
  '((sndbuf 11 'int 4)
    (rcvbuf 12 'int 4)
    (rcvmore 13 'int 4)
    (events 15 'int 4)
    (type 16 'int 4)
    (backlog 19 'int 4)
    (sndhwm 23 'int 4)
    (rcvhwm 24 'int 4)
    (rcvtimeo 27 'int 4)
    (sndtimeo 28 'int 4)
    (ipv6 42 'int 4)
    (mechanism 43 'int 4)
    (connect-timeout 79 'int 4)))
