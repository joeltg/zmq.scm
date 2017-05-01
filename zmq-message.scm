;; Messages

(define zmq-message-size (c-sizeof "zmq_msg_t"))

(define (zmq-buffer-size data)
  (vector-8b-length data))

(define (make-zmq-buffer data)
  (let ((len (zmq-buffer-size data)))
    (let ((buf (malloc len 'char)))
      (let iter ((k 0) (elm (copy-alien buf)))
	(if (< k len)
	    (let ((char (vector-8b-ref data k)))
	      (c->= elm "char" char)
	      (alien-byte-increment! elm 1 'char)
	      (iter (+ k 1) elm))
	    buf)))))

(define (parse-zmq-buffer buf len ret)
  (if (> ret len) (warn "message truncated"))
  (let ((data (make-string (min len ret))))
    (let iter ((k 0) (elm buf))
      (if (< k (min len ret))
	  (let ((char (c-> elm "char")))
	    (vector-8b-set! data k char)
	    (alien-byte-increment! elm 1 'char)
	    (iter (+ k 1) elm))
	  data))))

(define (zmq-message-send message socket #!optional flags)
  (let ((ret (c-call "zmq_msg_send" message socket (get-zmq-flags flags))))
    (if (= -1 ret)
      (error "could not send message" (get-zmq-error-string))
      ret)))

(define (zmq-message-receive message socket #!optional flags)
  (let ((ret (c-call "zmq_msg_recv" message socket (get-zmq-flags flags))))
    (if (= -1 ret)
      (error "could not receive message" (get-zmq-error-string))
      ret)))

(define (zmq-message-init-data message data size)
  (if (= -1 (c-call "zmq_msg_init_data" message data size null-alien null-alien))
      (error "could not init data message" (get-zmq-error-string))))

(define (zmq-message-init-size message size)
  (if (= -1 (c-call "zmq_msg_init_size" message size))
    (error "could not init size message" (get-zmq-error-string))))

(define (zmq-message-init message)
  (if (= -1 (c-call "zmq_msg_init" message))
    (error "could not init message" (get-zmq-error-string))))

(define (zmq-message-close message)
  (if (= -1 (c-call "zmq_msg_close" message))
    (error "could not close message" (get-zmq-error-string))))

(define (zmq-message-move dest src)
  (if (= -1 (c-call "zmq_msg_move" dest src))
    (error "could not move message" (get-zmq-error-string))))

(define (zmq-message-copy dest src)
  (if (= -1 (c-call "zmq_msg_copy" dest src))
    (error "could not copy message" (get-zmq-error-string))))

(define (zmq-message-data message)
  (c-call "zmq_msg_data" (malloc 8 '(* void)) message))

(define (zmq-message-more? message)
  (= 1 (c-call "zmq_msg_more" message)))

(define (zmq-message-size message)
  (c-call "zmq_msg_size" message))

(define (zmq-message-property message property)
  (let ((ret (c-call "zmq_msg_get" message ((zmq-ref zmq-message-properties) property))))
    (if (= -1 ret)
      (error "could not get message property" (get-zmq-error-string))
      ret)))

(define (set-zmq-message-property! message property value)
  (if
    (= -1
      (c-call "zmq_msg_set"
        message
        ((zmq-ref zmq-message-properties) property)
        value))
    (error "could not set message property")))

(define (zmq-message-gets message property-string)
  (let ((ret (c-call "zmq_msg_gets" message property-string)))
    (if (= -1 ret)
      (error "could not get message property string" (get-zmq-error-string))
      ret)))

(define zmq-message-properties
  '((more 1)
    (srcfd 2)
    (shared 3)))
