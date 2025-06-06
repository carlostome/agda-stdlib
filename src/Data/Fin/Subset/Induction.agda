------------------------------------------------------------------------
-- The Agda standard library
--
-- Induction over Subset
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Data.Fin.Subset.Induction where

open import Data.Nat.Base using (ℕ)
open import Data.Nat.Induction using (<-wellFounded)
open import Data.Fin.Subset using (Subset; ∁; _⊂_; _⊃_; ∣_∣)
open import Data.Fin.Subset.Properties using (p⊂q⇒∣p∣<∣q∣; p⊂q⇒∁p⊃∁q)
open import Induction using (RecStruct)
open import Induction.WellFounded as WF
open import Level using (Level)
import Relation.Binary.Construct.On as On using (wellFounded)

private
  variable
    ℓ : Level
    n : ℕ

------------------------------------------------------------------------
-- Re-export accessability

open WF public using (Acc; acc)

------------------------------------------------------------------------
-- Complete induction based on _⊂_

⊂-Rec : RecStruct (Subset n) ℓ ℓ
⊂-Rec = WfRec _⊂_

⊂-wellFounded : WellFounded {A = Subset n} _⊂_
⊂-wellFounded = Subrelation.wellFounded p⊂q⇒∣p∣<∣q∣
  (On.wellFounded ∣_∣ <-wellFounded)

------------------------------------------------------------------------
-- Complete induction based on _⊃_

⊃-Rec : RecStruct (Subset n) ℓ ℓ
⊃-Rec = WfRec _⊃_

⊃-wellFounded : WellFounded {A = Subset n} _⊃_
⊃-wellFounded = Subrelation.wellFounded p⊂q⇒∁p⊃∁q
  (On.wellFounded ∁ ⊂-wellFounded)
