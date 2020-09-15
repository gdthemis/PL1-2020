fun parse file =
    let
      	val inStream = TextIO.openIn file

        fun aux acc =
          let
            val line = TextIO.inputLine inStream
          in
            if line = NONE
            then (rev acc)
            else ( aux ( explode (valOf line ) :: acc ))
        end;
        val world = aux []
    in
   	    (length world,length (hd world) - 1,world)
end;

fun main (n,m,c) = 
  let
    (* parameteres are Xaxis, Yaxis and a counter which will go to 4 *)
    val visited = Array2.array(n,m,~1)
    val world = Array2.fromList(c)
    val goBack = Array2.array(n,m,"a")
    val tempQ1 = Queue.mkQueue(): (int * int) Queue.queue
    val tempQ2 = Queue.mkQueue(): (int * int) Queue.queue
    val tempQ3 = Queue.mkQueue(): (int * int) Queue.queue
    val airflag = Array.array(1,~1)
    val final = Array.array(1,(~1,~1))
    val q1 = Queue.mkQueue(): (int * int) Queue.queue (*Starting place of virus and the next places*)
    val q2 = Queue.mkQueue(): (int * int) Queue.queue (*Airports and places after that*)
    val q3 = Queue.mkQueue(): (int * int) Queue.queue (*Sotiris*)
    val timeReachedAirport = Array.array(1,~1)
    val isPosssible = Array.array(1,~1)
    fun finish (a,b) = if Array2.sub(goBack,a,b) <> "a" then if Array2.sub(goBack,a,b) = "R" then (finish (a,b-1); print(Array2.sub(goBack,a,b))) 
                                                             else if Array2.sub(goBack,a,b) = "L" then (finish (a,b+1); print(Array2.sub(goBack,a,b)))
                                                             else if Array2.sub(goBack,a,b) = "U" then (finish (a+1,b); print(Array2.sub(goBack,a,b)))    
                                                             else if Array2.sub(goBack,a,b) = "D" then (finish (a-1,b); print(Array2.sub(goBack,a,b)))  
                        else () else()                                                                   
    fun positionLetter (a,b) (c,d) = if a = c then if b = d + 1 then ("L") else ("R") else if a = c + 1 then ("U") else ("D")
    fun refillQueue q1 q2 = if Queue.isEmpty q2 = false then (Queue.enqueue(q1,Queue.dequeue(q2)); refillQueue q1 q2) else ()
    fun getStarting i j = if i = n then () else
                          if j = m then getStarting (i+1) 0 else if Array2.sub(world,i,j) = #"S" then (Queue.enqueue(q3,(i,j)); Array2.update(visited,i,j,1))
                          else getStarting i (j+1)
    fun getVirusStartingPlace i j = if i = n then () else
                                    if j = m then( getVirusStartingPlace (i+1) 0 )else if Array2.sub(world,i,j) = #"W" then (Queue.enqueue(q1,(i,j));Array2.update(visited,i,j,2))
                                    else getVirusStartingPlace i (j+1)

    fun getAirports i j = if i = n then [] else
                          if j = m then getAirports (i+1) 0 else if Array2.sub(world,i,j) = #"A" then let val a = getAirports i (j+1) in (i,j)::a end
                          else getAirports i (j+1)

    fun nextSpot (x,y) counter =if counter = 0 then if x + 1 < n andalso Array2.sub(world,x+1,y) <> #"X"
                                 then let val a = nextSpot (x,y) (counter+1) in ((x+1,y)::a) end else nextSpot (x,y) (counter+1)
                        else if counter = 1 then if y > 0 andalso Array2.sub(world,x,y-1) <> #"X" 
                             then let val a = nextSpot (x,y) (counter+1) in ((x,y-1)::a) end else nextSpot (x,y) (counter+1)
                        else if counter = 2 then if y + 1 < m andalso Array2.sub(world,x,y+1) <> #"X"
                              then let val a = nextSpot (x,y) (counter+1) in ((x,y+1)::a) end else nextSpot (x,y) (counter+1)
                        else if counter = 3 then if x > 0 andalso Array2.sub(world,x-1,y) <> #"X"
                             then let val a = nextSpot (x,y) (counter+1) in ((x-1,y)::a) end else nextSpot (x,y) (counter+1) 
                        else ([])

    fun advance1 [] time = ()
      | advance1 ((a,b)::xs) time = if (Array2.sub(visited,a,b) = ~1 orelse Array2.sub(visited,a,b) = 1) then 
      if Array2.sub(world,a,b) = #"A" andalso Array.sub(airflag,0) = ~1 
      then (Array2.update(visited,a,b,2);
      (Queue.enqueue(tempQ1,(a,b)));
      Array.update(airflag,0,1);
      Array.update(timeReachedAirport,0,time+5);
      (advance1 xs time))
      else if Array2.sub(world,a,b) = #"T" 

      then (Array.update(isPosssible,0,1);
      print("IMPOSSIBLE\n");
      Queue.clear q1;
      Queue.clear q2; 
      Queue.clear q3;
      Queue.clear tempQ1; 
      Queue.clear tempQ2; 
      Queue.clear tempQ3)

      else (Array2.update(visited,a,b,2);Queue.enqueue(tempQ1,(a,b));(advance1 xs time))
      else (advance1 xs time)

    fun advance2 [] = ()
      | advance2 ((a,b)::xs) = if Array2.sub(visited,a,b) = ~ 1 then (Array2.update(visited,a,b,2);Queue.enqueue(q2,(a,b)); advance2 xs) else (advance2 xs)

    fun advance21 [] = ()
      | advance21 ((a,b)::xs) = if Array2.sub(visited,a,b) = ~ 1 then if Array2.sub(world,a,b) = #"T" then (Array.update(isPosssible,0,1);print("IMPOSSIBLE\n");Queue.clear q1;Queue.clear q2; Queue.clear q3;
      Queue.clear tempQ1; Queue.clear tempQ2; Queue.clear tempQ3)
      else (Array2.update(visited,a,b,2);(Queue.enqueue(tempQ2,(a,b))); advance21 xs)
      else (advance21 xs)

    fun advance3 [] (old1,old2) = ()
      | advance3 ((a,b)::xs) (old1,old2) = if Array2.sub(visited,a,b) = ~ 1 then if Array2.sub(world,a,b) = #"T" 

                              then (Array.update(final,0,(a,b));
                              Queue.clear q1;
                              Queue.clear q2; 
                              Queue.clear q3; 
                              Queue.clear tempQ1; 
                              Queue.clear tempQ2; 
                              Queue.clear tempQ3;
                              Array2.update(goBack,a,b,positionLetter (old1,old2) (a,b)))

                               else (Array2.update(visited,a,b,1);
                               (Queue.enqueue(tempQ3,(a,b)));
                                Array2.update(goBack,a,b,positionLetter (old1,old2) (a,b));
                                advance3 xs (old1,old2))

                                    else (if Array2.sub(world,a,b) = #"T" 
                                    then (Array.update(final,0,(a,b)); 
                                    Queue.clear q1;Queue.clear q2; 
                                    Queue.clear q3;
                                    Queue.clear tempQ1; 
                                    Queue.clear tempQ2; 
                                    Queue.clear tempQ3;
                                    Array2.update(goBack,a,b,positionLetter (old1,old2) (a,b)) ) 
            
                                          else (advance3 xs (old1,old2)))

    fun startQ1 q1 time = if time mod 2 = 0 andalso Queue.isEmpty q1 = false then ((advance1 (nextSpot (Queue.dequeue q1) 0) time); startQ1 q1 time)
                          else (if time mod 2 = 0 andalso Queue.isEmpty q1 = true then ((refillQueue q1 tempQ1); Queue.clear tempQ1) else())

    fun startQ2 q2 time = if Array.sub(airflag,0) = 1 andalso time = Array.sub(timeReachedAirport,0) then (advance2 (getAirports 0 0)) 
                          else (
                            if Array.sub(airflag,0) = 1 andalso time > Array.sub(timeReachedAirport,0) andalso time mod 2 = 1 andalso Queue.isEmpty q2 = false
                            then (advance21 (nextSpot (Queue.dequeue q2) 0); startQ2 q2 time)
                            else (if Queue.isEmpty q2 = true then ((refillQueue q2 tempQ2); Queue.clear tempQ2) else ()))

    fun startQ3 q3 time = if Queue.isEmpty q3 = false then (advance3 (nextSpot (Queue.head q3) 0) (Queue.dequeue q3); startQ3 q3 time)
                          else ((refillQueue q3 tempQ3); Queue.clear tempQ3)

    fun startBfs q1 q2 q3 time = if Queue.isEmpty q1 = true andalso Queue.isEmpty q2 = true andalso Queue.isEmpty q3 = true 
                                 then(if Array.sub(isPosssible,0) = ~1
                                          then (print(Int.toString(time - 1));print("\n");finish (Array.sub(final,0)); print("\n") )else ())
                                 else (startQ1 q1 time ;startQ2 q2 time ;startQ3 q3 time; startBfs q1 q2 q3 (time + 1))
  in
    getStarting 0 0; getVirusStartingPlace 0 0; startBfs q1 q2 q3 1
  end

  fun stayhome st = main (parse st)    

