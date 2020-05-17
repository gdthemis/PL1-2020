(*
Θεμελής Γεώργιος el17131
έχω να κάνω :
1) να φτιάξω την περίπτωση που δεν ισχύει (PENDING) DONE (6/4/2020) √
2) να φτιάξω τα μηδενικά στο τέλος (PENDING) DONE (5/4/2020) √
3) να φτιάξω τη συνάρτηση που θα εκτυπώνει το αποτέλεσμα (PENDING) DONE (6/4/2020) √
4) να φτιάξω το διάβασμα από αρχείο (PENDING) DONE (6/4/2020) √
https://stackoverflow.com/questions/30201666/convert-array-to-list-in-sml από εδώ πήρα την arrayToList
και έχω χρησιμοποιήσει και τη συνάρτηση για το διάβασμα αρχείου
Την make_list την έχω πάρει από το φυλλάδιο του πρώτου εργαστηρίου
*)

fun parse file =
    let
        fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
	val n = readInt inStream
	val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	(n, readInts (2*n) [])
    end

fun power 0 = 1
  | power n = 2 * power (n-1)

fun first n k x 0 = [0]
  | first n k x s = if k < n then (first n (power (x) + k ) (x+1) s)
                    else (
                      if k = n then ([x])
                      else (
                          let
                            val a = first n (k - power(x-1)) 0 (s-1)
                          in
                            (x-1)::a
                          end
                          )
                  )

fun make_list n =
let fun loop 0 result = result
      | loop i result = loop (i-1) (0::result)
in
loop n []
end

fun mhdenika1 l n= 
  let
    fun a n = make_list n
    fun m (nil,z) = z
      | m (y::ys, z) = m (ys, y::z)
  in
    m (a n, l)
  end

fun aux k q = 
let
  val a =  Array.array(q+60,0)
  fun arrayToList arr = Array.foldr (op ::) [] arr
  fun telos1 list = case list of [x] => (Array.update(a, x, Array.sub(a,x)+1))
                           |   x::xs => (Array.update(a, x, Array.sub(a,x) + 1); telos1 (xs))
in
  telos1 k; arrayToList a
end

fun printList xs = (print("["); print(String.concatWith "," (map Int.toString xs)); print"]"; print "\n");

fun gamw [0] = []
  | gamw [x] = [x]
  | gamw (x::xs) = if x = 0 then(gamw (xs)) else (x::xs)
  

fun teliko a k = printList (List.rev (gamw (List.rev (aux (mhdenika1 (a) (k - List.length (a))) k))))


fun teliko1 n k x s = 
    let
     val a = first n k x s 
     val b = List.rev a
    in
    if hd b = 0 then (printList []) else (teliko a k)
    end

fun teliko2 n k = teliko1 n k 0 k

fun deutero (x,y) = y

fun powers2 file = 
  let
    val b = List.rev (deutero (parse file))
    fun go [x,y] = (teliko2 x y)
      | go (x::y::xs) = ((teliko2 x y); go (xs))
  in
    go b 
  end 



