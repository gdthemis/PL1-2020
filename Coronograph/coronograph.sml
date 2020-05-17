fun parse file option =
    let
        fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file
        (* Read an integer (number of countries) and consume newline. *)
        (* A function to read N integers from the open file. *)
	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
  
  fun getlist 1 = [(~1,1,readInt inStream,readInts (2*(readInt inStream)) [])]
    | getlist b =  (~1,1,readInt inStream,readInts (2*(readInt inStream)) []) :: getlist (b-1)

    in
   	(* if option = 1 then (1,1,readInt inStream,[])
    else (~1,1,readInt inStream,List.rev(readInts (2*(readInt inStream)) [])) *)
    getlist (readInt inStream)
    end

fun adjList (_,_,vertices,s) = 
    let
      val ast = Array.array(vertices ,[])
      fun addedge a b = (Array.update(ast,a,(b::(Array.sub(ast,a)))); Array.update(ast,b,(a::(Array.sub(ast,b)))))
      fun teliko [a,b] = addedge (a-1) (b-1)
        | teliko (x::y::ys) = ((addedge (x-1) (y-1)); teliko ys)
      fun arrayToList arr = Array.foldr (op ::) [] arr
    in
      teliko s; arrayToList ast
    end

fun dfs node adjlist = 
    let
      val aux = List.length(adjlist)
      val visited = Array.array (aux, 0)
      val adnew = Array.fromList adjlist;
      val cycle = Array.array(aux,~1)
      val bool = Array.array(1,0)
      val keep = Array.array(1,~1)
      fun arrayToList arr = Array.foldr (op ::) [] arr
      fun getfinal [x] = if x <> (~1) then [x] else []
        | getfinal (x::xs) = if x <> (~1) then x::(getfinal xs) else getfinal xs
      fun dfs1 node parent = 
        let
          fun dfs2 [] = false 
            | dfs2 [x] = if Array.sub(visited,x) = 0 then if dfs1 x node = true then(
              if (Array.sub(keep,0) <> x andalso Array.sub(bool,0) = 0 )then(Array.update(cycle,x,x); true)
              else(Array.update(bool,0,1);true))
                                                          else false else if x <> parent then(Array.update(cycle,x,x);Array.update(keep,0,x); true) 
                                                                          else false
            | dfs2 (x::xs) = if Array.sub(visited,x) = 0 then if dfs1 x node = true then(
              if (Array.sub(keep,0) <> x andalso Array.sub(bool,0) = 0 )then(Array.update(cycle,x,x); true)
              else(Array.update(bool,0,1);true))
                                                               else dfs2 (xs)
                             else if x <> parent then(Array.update(cycle,x,x);Array.update(keep,0,x); true) else dfs2 (xs)
        in
        Array.update(visited,node,1); dfs2 (Array.sub(adnew, node))
        end
    in
      (dfs1 0 (~1),getfinal (arrayToList cycle), adjlist)
    end

fun getNodes (pipa,y,z) = 
  let
    val visited = Array.array(List.length(z)+1,0)
    val part = Array.array(List.length(y)+1, 0)
    val trick = Array.fromList z
    fun incycle [] = () 
      | incycle [x] = (Array.update(visited, x, 1))
      | incycle (x::xs) = (Array.update(visited, x, 1); incycle xs)
    fun getNodes1 node count = 
      let
        fun dfs [x] = if Array.sub(visited, x) = 0 then ((getNodes1 x count)) else ()
          | dfs (x::xs) = if Array.sub(visited, x) = 0 then ((getNodes1 x count);(dfs xs)) else (dfs xs)
      in
        Array.update(visited,node,1); Array.update(part,count,Array.sub(part,count)+1); dfs (Array.sub(trick,node))
      end 
    fun finale [] a = () 
      | finale [x] a = (getNodes1 x a)
      | finale (x::xs) q = (getNodes1 x q; finale xs (q+1))
    fun arrayToList arr = Array.foldr (op ::) [] arr
    val sum = foldl op+ 0
  in
    incycle y;finale y 0;  (ListMergeSort.sort (fn(x,y)=> x>y) (arrayToList part),List.length(y) ,sum(arrayToList part) = List.length(z))
  end

fun printList [x] = if x = 0 then () else print(Int.toString(x))
  | printList (x::xs) = if x = 0 then printList xs else (print(Int.toString(x)); print(" "); printList xs)

fun teliko3 (a,b,c) = (if c = true then( print("CORONA "); print(Int.toString(b)); print("\n");  printList a; print("\n")) else (print("NO CORONA\n")))

fun teliko aux1 = teliko3(getNodes(dfs 0 (adjList aux1))) 

fun teliko1 (a,b,c,d) =  (if c <> (List.length(d) div 2) then (print("NO CORONA\n")) else (teliko3 (getNodes(dfs 0 (adjList (a,b,c,d))))))

fun coronograph pipa = 
  let
    val a = parse (pipa) 0
    fun go [x] = (teliko1 x)
      | go (x::xs) = (teliko1 x; go xs)
  in
    go a
  end

















