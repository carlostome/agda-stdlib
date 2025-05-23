------------------------------------------------------------------------
-- The Agda standard library
--
-- Homogeneously-indexed binary relations
------------------------------------------------------------------------

-- The contents of this module should be accessed via
-- `Relation.Binary.Indexed.Homogeneous`.

{-# OPTIONS --cubical-compatible --safe #-}

module Relation.Binary.Indexed.Homogeneous.Bundles where

open import Level using (suc; _⊔_)
open import Relation.Binary.Core using (Rel)
open import Relation.Binary.Bundles as B using (Setoid; Preorder; Poset)
open import Relation.Binary.Indexed.Homogeneous.Core using (IRel; Lift)
open import Relation.Binary.Indexed.Homogeneous.Structures
  using (IsIndexedEquivalence; IsIndexedDecEquivalence; IsIndexedPreorder
        ; IsIndexedPartialOrder)
open import Relation.Nullary.Negation.Core using (¬_)

-- Indexed structures are laid out in a similar manner as to those
-- in Relation.Binary. The main difference is each structure also
-- contains proofs for the lifted version of the relation.

------------------------------------------------------------------------
-- Equivalences

record IndexedSetoid {i} (I : Set i) c ℓ : Set (suc (i ⊔ c ⊔ ℓ)) where
  infix 4 _≈ᵢ_ _≈_
  field
    Carrierᵢ       : I → Set c
    _≈ᵢ_           : IRel Carrierᵢ ℓ
    isEquivalenceᵢ : IsIndexedEquivalence Carrierᵢ _≈ᵢ_

  open IsIndexedEquivalence isEquivalenceᵢ public

  Carrier : Set _
  Carrier = ∀ i → Carrierᵢ i

  infix 4 _≉_

  _≈_ : Rel Carrier _
  _≈_ = Lift Carrierᵢ _≈ᵢ_

  _≉_ : Rel Carrier _
  x ≉ y = ¬ (x ≈ y)

  setoid : B.Setoid _ _
  setoid = record
    { isEquivalence = isEquivalence
    }


record IndexedDecSetoid {i} (I : Set i) c ℓ : Set (suc (i ⊔ c ⊔ ℓ)) where
  infix 4 _≈ᵢ_
  field
    Carrierᵢ          : I → Set c
    _≈ᵢ_              : IRel Carrierᵢ ℓ
    isDecEquivalenceᵢ : IsIndexedDecEquivalence Carrierᵢ _≈ᵢ_

  open IsIndexedDecEquivalence isDecEquivalenceᵢ public

  indexedSetoid : IndexedSetoid I c ℓ
  indexedSetoid = record
    { isEquivalenceᵢ = isEquivalenceᵢ
    }

  open IndexedSetoid indexedSetoid public
    using (Carrier; _≈_; _≉_; setoid)

------------------------------------------------------------------------
-- Preorders

record IndexedPreorder {i} (I : Set i) c ℓ₁ ℓ₂ :
                       Set (suc (i ⊔ c ⊔ ℓ₁ ⊔ ℓ₂)) where

  infix 4 _≈ᵢ_ _∼ᵢ_ _≈_ _∼_

  field
    Carrierᵢ    : I → Set c
    _≈ᵢ_        : IRel Carrierᵢ ℓ₁
    _∼ᵢ_        : IRel Carrierᵢ ℓ₂
    isPreorderᵢ : IsIndexedPreorder Carrierᵢ _≈ᵢ_ _∼ᵢ_

  open IsIndexedPreorder isPreorderᵢ public

  Carrier : Set _
  Carrier = ∀ i → Carrierᵢ i

  _≈_ : Rel Carrier _
  x ≈ y = ∀ i → x i ≈ᵢ y i

  _∼_ : Rel Carrier _
  x ∼ y = ∀ i → x i ∼ᵢ y i

  preorder : B.Preorder _ _ _
  preorder = record
    { isPreorder = isPreorder
    }

------------------------------------------------------------------------
-- Partial orders

record IndexedPoset {i} (I : Set i) c ℓ₁ ℓ₂ :
                    Set (suc (i ⊔ c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈ᵢ_ _≤ᵢ_
  field
    Carrierᵢ        : I → Set c
    _≈ᵢ_            : IRel Carrierᵢ ℓ₁
    _≤ᵢ_            : IRel Carrierᵢ ℓ₂
    isPartialOrderᵢ : IsIndexedPartialOrder Carrierᵢ _≈ᵢ_ _≤ᵢ_

  open IsIndexedPartialOrder isPartialOrderᵢ public

  preorderᵢ : IndexedPreorder I c ℓ₁ ℓ₂
  preorderᵢ = record
    { isPreorderᵢ = isPreorderᵢ
    }

  open IndexedPreorder preorderᵢ public
    using (Carrier; _≈_; preorder) renaming (_∼_ to _≤_)

  poset : B.Poset _ _ _
  poset = record
    { isPartialOrder = isPartialOrder
    }
