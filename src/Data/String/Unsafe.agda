------------------------------------------------------------------------
-- The Agda standard library
--
-- Unsafe String operations and proofs
------------------------------------------------------------------------

{-# OPTIONS --with-K #-}

module Data.String.Unsafe where

import Data.List.Base as List using (List; _∷_; _++_; length; replicate; tail)
import Data.List.Properties as Listₚ using (length-replicate; length-++)
open import Data.Maybe.Base using (maybe′)
open import Data.Nat.Base using (zero; suc; _+_)
open import Data.Product.Base using (proj₂)
open import Data.String.Base
  using (String; toList; fromList; length; tail; _++_; replicate)
open import Function.Base using (_∘′_)
open import Relation.Binary.PropositionalEquality.Core using (_≡_; cong)
open import Relation.Binary.PropositionalEquality.Properties
  using (module ≡-Reasoning)
open import Relation.Binary.PropositionalEquality.TrustMe using (trustMe)

open ≡-Reasoning

------------------------------------------------------------------------
-- Properties of tail

length-tail : ∀ s → length s ≡ maybe′ (suc ∘′ length) zero (tail s)
length-tail s = trustMe

------------------------------------------------------------------------
-- Properties of conversion functions

toList∘fromList : ∀ s → toList (fromList s) ≡ s
toList∘fromList s = trustMe

fromList∘toList : ∀ s → fromList (toList s) ≡ s
fromList∘toList s = trustMe

toList-++ : ∀ s t → toList (s ++ t) ≡ toList s List.++ toList t
toList-++ s t = trustMe

length-++ : ∀ s t → length (s ++ t) ≡ length s + length t
length-++ s t = begin
  length (s ++ t)                         ≡⟨⟩
  List.length (toList (s ++ t))           ≡⟨ cong List.length (toList-++ s t) ⟩
  List.length (toList s List.++ toList t) ≡⟨ Listₚ.length-++ (toList s) ⟩
  length s + length t                     ∎

length-replicate : ∀ n {c} → length (replicate n c) ≡ n
length-replicate n {c} = let cs = List.replicate n c in begin
  length (replicate n c) ≡⟨ cong List.length (toList∘fromList cs) ⟩
  List.length cs         ≡⟨ Listₚ.length-replicate n ⟩
  n                      ∎
