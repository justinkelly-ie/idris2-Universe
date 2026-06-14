module JSBridge

import Data.String
import Data.List
import Math.Multiset
import Math.IntPolynumber
import Math.Chromogeometry
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
          Just (((MkPixel (parseInt x1) (parseInt y1)), (MkPixel (parseInt x2) (parseInt y2))), parseInt countPart)
        _ => Nothing
    _ => Nothing

parseSubstrate : String -> Substrate
parseSubstrate s =
  if s == "" then ZeroM else
  let items = splitList (\c => c == ';') s
      edges = mapMaybe parseEdge items
  in fromList edges

parseTerms : List String -> List ((Nat, Nat), Integer)
parseTerms [] = []
parseTerms (a :: b :: c :: rest) =
  ((parseNat a, parseNat b), parseInt c) :: parseTerms rest
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
          let geom = MkPixel (parseInt gx) (parseInt gy)
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

-- EXPOSE API FUNCTIONS

runAdaptiveCycleBridge : String -> String -> String -> String -> String -> String
runAdaptiveCycleBridge capacityLimitStr metricStr macroTargetStr substrateStr stateVectorStr =
  let capLimit = parseNat capacityLimitStr
      metricVal = parseInt metricStr
      metric = case metricVal of
                 1 => Red
                 2 => Green
                 _ => Blue
      macroTarget = case splitList (\c => c == ',') macroTargetStr of
                      [x, y] => MkPixel (parseInt x) (parseInt y)
                      _ => MkPixel 0 0
      sub = parseSubstrate substrateStr
      stateVec = parseVexel stateVectorStr
      stateIn = MkUniverseState sub stateVec Refl
      stateOut = runAdaptiveCycle capLimit metric macroTarget stateIn
  in serializeUniverseState stateOut

stepUniverseLocalizedBridge : String -> String -> String -> String -> String
stepUniverseLocalizedBridge capacityLimitStr metricStr substrateStr stateVectorStr =
  let capLimit = parseNat capacityLimitStr
      metricVal = parseInt metricStr
      metric = case metricVal of
                 1 => Red
                 2 => Green
                 _ => Blue
      sub = parseSubstrate substrateStr
      stateVec = parseVexel stateVectorStr
      (subOut ** stateVecOut ** prfOut) = stepUniverseLocalized capLimit metric sub stateVec Refl
      stateOut = MkUniverseState subOut stateVecOut prfOut
  in serializeUniverseState stateOut

-- EXPOSING TO JAVASCRIPT

%foreign "javascript:lambda:(name, fn) => { globalThis[name] = fn; }"
prim_exportFunction : String -> (String -> String -> String -> String -> String -> String) -> PrimIO ()

%foreign "javascript:lambda:(name, fn) => { globalThis[name] = fn; }"
prim_exportFunction4 : String -> (String -> String -> String -> String -> String) -> PrimIO ()

main : IO ()
main = do
  primIO $ prim_exportFunction "idris_runAdaptiveCycle" runAdaptiveCycleBridge
  primIO $ prim_exportFunction4 "idris_stepUniverseLocalized" stepUniverseLocalizedBridge
  putStrLn "Idris physics engine JSBridge initialized successfully!"
