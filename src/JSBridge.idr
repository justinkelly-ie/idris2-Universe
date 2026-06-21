module JSBridge

import Data.String
import Data.List
import Math.Multiset
import Math.IntPolynumber
import Math.Chromogeometry
import Math.BoxInt
import Math.Pixel
import Simplex.Core
import Evolution.LocalSpreadPolynumber
import Evolution.Cycle
import Evolution.State
import Data.List1

-- EXPOSE PARSERS
forgetList : List1 a -> List a
forgetList (x ::: xs) = x :: xs

splitList : (Char -> Bool) -> String -> List String
splitList f s = forgetList (split f s)

parseInt : String -> Integer
parseInt s = case parseInteger s of
               Just i => i
               Nothing => 0

parseNat : String -> Nat
parseNat s = fromInteger (parseInt s)

parseEdge : String -> Maybe ((Geometry, Geometry), Integer)
parseEdge s =
  case splitList (\c => c == ':') s of
    [edgePart, countPart] =>
      case splitList (\c => c == ',') edgePart of
        [x1, y1, x2, y2] =>
          Just (((MkPixel (intToBoxInt (parseInt x1)) (intToBoxInt (parseInt y1))), (MkPixel (intToBoxInt (parseInt x2)) (intToBoxInt (parseInt y2)))), parseInt countPart)
        _ => Nothing
    _ => Nothing

parseSubstrate : String -> Substrate
parseSubstrate s =
  if s == "" then ZeroM else
  let items = splitList (\c => c == ';') s
      edges = mapMaybe parseEdge items
  in fromList edges

parseTerms : List String -> List ((Nat, Nat), BoxInt)
parseTerms [] = []
parseTerms (a :: b :: c :: rest) =
  ((parseNat a, parseNat b), intToBoxInt (parseInt c)) :: parseTerms rest
parseTerms _ = []

parseAmplitude : String -> Amplitude
parseAmplitude s =
  if s == "" then ZeroM else
  fromList (parseTerms (splitList (\c => c == ',') s))

parseMaxelItem : String -> Maybe ((Geometry, Amplitude), Integer)
parseMaxelItem s =
  case splitList (\c => c == ':') s of
    [geomPart, countPart, ampPart] =>
      case splitList (\c => c == ',') geomPart of
        [gx, gy] =>
          let geom = MkPixel (intToBoxInt (parseInt gx)) (intToBoxInt (parseInt gy))
              count = parseInt countPart
              amp = parseAmplitude ampPart
          in Just ((geom, amp), count)
        _ => Nothing
    _ => Nothing

parseVexel : String -> Vexel
parseVexel s =
  if s == "" then ZeroM else
  let items = splitList (\c => c == ';') s
      maxels = mapMaybe parseMaxelItem items
  in fromList maxels

-- FFI EXPORTS FOR TYPED ARRAY OUTPUT

%foreign "javascript:lambda:() => { if (globalThis.clearUniverseBuffers) globalThis.clearUniverseBuffers(); }"
prim_clearBuffers : PrimIO ()

%foreign "javascript:lambda:(px, py, cx, cy, count) => { if (globalThis.pushEdge) globalThis.pushEdge(px, py, cx, cy, count); }"
prim_pushEdge : Int -> Int -> Int -> Int -> Int -> PrimIO ()

%foreign "javascript:lambda:(x, y, alpha, beta, count) => { if (globalThis.pushMaxel) globalThis.pushMaxel(x, y, alpha, beta, count); }"
prim_pushMaxel : Int -> Int -> Int -> Int -> Int -> PrimIO ()

clearBuffers : IO ()
clearBuffers = primIO prim_clearBuffers

pushEdge : Integer -> Integer -> Integer -> Integer -> Integer -> IO ()
pushEdge px py cx cy count = primIO (prim_pushEdge (fromInteger px) (fromInteger py) (fromInteger cx) (fromInteger cy) (fromInteger count))

pushMaxel : Integer -> Integer -> Nat -> Nat -> Integer -> IO ()
pushMaxel x y alpha beta count = primIO (prim_pushMaxel (fromInteger x) (fromInteger y) (cast alpha) (cast beta) (fromInteger count))

exportSubstrate : Substrate -> IO ()
exportSubstrate sub = do
  traverse_ (\((MkPixel s t, MkPixel cx cy), count) => do
      let (MkUr px) = boxToInt s
      let (MkUr py) = boxToInt t
      let (MkUr c_x) = boxToInt cx
      let (MkUr c_y) = boxToInt cy
      pushEdge px py c_x c_y count) (multisetToList sub)
  
exportVexel : Vexel -> IO ()
exportVexel v = do
  traverse_ (\((MkPixel s t, amp), mCount) => do
      let (MkUr px) = boxToInt s
      let (MkUr py) = boxToInt t
      traverse_ (\((alpha, beta), tCount) => do
          let (MkUr tC) = boxToInt tCount
          pushMaxel px py alpha beta (tC * mCount)) (multisetToList amp)) (multisetToList v)

exportUniverseState : UniverseState -> IO ()
exportUniverseState (MkUniverseState sub stateVec) = do
  clearBuffers
  exportSubstrate sub
  exportVexel stateVec

-- EXPOSE API FUNCTIONS

runAdaptiveCycleBridge : String -> String -> String -> String -> String -> IO ()
runAdaptiveCycleBridge capacityLimitStr metricStr macroTargetStr substrateStr stateVectorStr = do
  let capLimit = parseNat capacityLimitStr
  let metricVal = parseInt metricStr
  let metric = case metricVal of
                 1 => Red
                 2 => Green
                 _ => Blue
  let macroTarget = case splitList (\c => c == ',') macroTargetStr of
                      [x, y] => MkPixel (intToBoxInt (parseInt x)) (intToBoxInt (parseInt y))
                      _ => MkPixel (intToBoxInt 0) (intToBoxInt 0)
  let sub = parseSubstrate substrateStr
  let stateVec = parseVexel stateVectorStr
  let stateIn = MkUniverseState sub stateVec
  let stateOut = runAdaptiveCycle capLimit metric macroTarget stateIn
  exportUniverseState stateOut

stepUniverseLocalizedBridge : String -> String -> String -> String -> IO ()
stepUniverseLocalizedBridge capacityLimitStr metricStr substrateStr stateVectorStr = do
  let capLimit = parseNat capacityLimitStr
  let metricVal = parseInt metricStr
  let metric = case metricVal of
                 1 => Red
                 2 => Green
                 _ => Blue
  let sub = parseSubstrate substrateStr
  let stateVec = parseVexel stateVectorStr
  let (subOut, stateVecOut) = stepUniverseLocalized capLimit metric sub stateVec
  let stateOut = MkUniverseState subOut stateVecOut
  exportUniverseState stateOut

-- EXPOSING TO JAVASCRIPT

%foreign "javascript:lambda:(name, fn) => { globalThis[name] = (a) => (b) => (c) => (d) => (e) => { fn(a)(b)(c)(d)(e)(); return 0; }; }"
prim_exportFunction : String -> (String -> String -> String -> String -> String -> PrimIO ()) -> PrimIO ()

%foreign "javascript:lambda:(name, fn) => { globalThis[name] = (a) => (b) => (c) => (d) => { fn(a)(b)(c)(d)(); return 0; }; }"
prim_exportFunction4 : String -> (String -> String -> String -> String -> PrimIO ()) -> PrimIO ()

main : IO ()
main = do
  primIO $ prim_exportFunction "idris_runAdaptiveCycle" (\a,b,c,d,e => toPrim (runAdaptiveCycleBridge a b c d e))
  primIO $ prim_exportFunction4 "idris_stepUniverseLocalized" (\a,b,c,d => toPrim (stepUniverseLocalizedBridge a b c d))
  putStrLn "Idris physics engine JSBridge initialized successfully!"
