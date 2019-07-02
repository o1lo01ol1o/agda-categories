{-# OPTIONS --without-K --safe #-}

module Categories.NaturalTransformation.NaturalIsomorphism where

open import Level
open import Data.Product using (_×_; _,_)
open import Relation.Binary using (IsEquivalence)

open import Categories.Category
open import Categories.Functor as ℱ hiding (id)
open import Categories.NaturalTransformation.Core as α hiding (id)
import Categories.Morphism as Morphism
import Categories.Morphism.Properties as Morphismₚ
import Categories.Square as Square
open import Categories.Functor.Properties

open import Relation.Binary

private
  variable
    o ℓ e o′ ℓ′ e′ : Level
    C D E : Category o ℓ e

record NaturalIsomorphism {C : Category o ℓ e}
                          {D : Category o′ ℓ′ e′}
                          (F G : Functor C D) : Set (o ⊔ ℓ ⊔ e ⊔ o′ ⊔ ℓ′ ⊔ e′) where
  private module C = Category C
  private module D = Category D
  private module F = Functor F
  private module G = Functor G
  open F
  open G renaming (F₀ to G₀; F₁ to G₁)

  field
    F⇒G : NaturalTransformation F G
    F⇐G : NaturalTransformation G F

  module ⇒ = NaturalTransformation F⇒G
  module ⇐ = NaturalTransformation F⇐G

  open Morphism D

  field
    iso : ∀ X → Iso (⇒.η X) (⇐.η X)

refl : Reflexive (NaturalIsomorphism {C = C} {D = D})
refl {C = C} {D = D} {x = F} = record
  { F⇒G = α.id
  ; F⇐G = α.id
  ; iso = λ A → record
    { isoˡ = Category.identityˡ D
    ; isoʳ = Category.identityʳ D
    }
  }

sym : Symmetric (NaturalIsomorphism {C = C} {D = D})
sym {C = C} {D = D} F≃G = record
  { F⇒G = F⇐G
  ; F⇐G = F⇒G
  ; iso = λ X →
    let open Iso (iso X) in record
    { isoˡ = isoʳ
    ; isoʳ = isoˡ
    }
  }
  where open NaturalIsomorphism F≃G
        open Morphism D

trans : Transitive (NaturalIsomorphism {C = C} {D = D})
trans {C = C} {D = D} F≃G G≃H = record
  { F⇒G = F⇒G G≃H ∘ᵥ F⇒G F≃G
  ; F⇐G = F⇐G F≃G ∘ᵥ F⇐G G≃H
  ; iso = λ X → record
    { isoˡ = begin
      D [ η (F⇐G F≃G ∘ᵥ F⇐G G≃H) X ∘ η (F⇒G G≃H ∘ᵥ F⇒G F≃G) X ] ≈⟨ cancelInner (isoˡ (iso G≃H X)) ⟩
      η (F⇐G F≃G ∘ᵥ F⇒G F≃G) X                                  ≈⟨ isoˡ (iso F≃G X) ⟩
      D.id                                                      ∎
    ; isoʳ = begin
      D [ η (F⇒G G≃H ∘ᵥ F⇒G F≃G) X ∘ η (F⇐G F≃G ∘ᵥ F⇐G G≃H) X ] ≈⟨ cancelInner (isoʳ (iso F≃G X)) ⟩
      η (F⇒G G≃H ∘ᵥ F⇐G G≃H) X                                  ≈⟨ isoʳ (iso G≃H X) ⟩
      D.id                                                      ∎
    }
  }
  where module D = Category D
        open NaturalIsomorphism
        open NaturalTransformation
        open Morphism D
        open Iso
        open Category.HomReasoning D
        open Square D

isEquivalence : (C : Category o ℓ e) (D : Category o′ ℓ′ e′) → IsEquivalence (NaturalIsomorphism {C = C} {D = D})
isEquivalence C D = record
  { refl  = refl
  ; sym   = sym
  ; trans = trans
  }

setoid : (C : Category o ℓ e) (D : Category o′ ℓ′ e′) → Setoid _ _
setoid C D = record 
  { Carrier       = Functor C D
  ; _≈_           = NaturalIsomorphism
  ; isEquivalence = isEquivalence C D
  }

infixr 9 _ⓘᵥ_ _ⓘₕ_ _ⓘˡ_ _ⓘʳ_

_ⓘᵥ_ : ∀ {F G H : Functor C D} →
         NaturalIsomorphism G H → NaturalIsomorphism F G → NaturalIsomorphism F H
_ⓘᵥ_ {D = D} α β = record
  { F⇒G = F⇒G α ∘ᵥ F⇒G β
  ; F⇐G = F⇐G β ∘ᵥ F⇐G α
  ; iso = λ X → Iso-∘ (iso β X) (iso α X)
  }
  where open NaturalIsomorphism
        open Morphismₚ D

_ⓘₕ_ : ∀ {H I : Functor D E} {F G : Functor C D} →
         NaturalIsomorphism H I → NaturalIsomorphism F G → NaturalIsomorphism (H ∘F F) (I ∘F G)
_ⓘₕ_ {E = E} {I = I} α β = record
  { F⇒G = F⇒G α ∘ₕ F⇒G β
  ; F⇐G = F⇐G α ∘ₕ F⇐G β
  ; iso = λ X → Iso-resp-≈ (Iso-∘ (iso α _) ([ I ]-resp-Iso (iso β X)))
                           E.Equiv.refl (commute (F⇐G α) (η (F⇐G β) X))
  }
  where open NaturalIsomorphism
        open NaturalTransformation
        module E = Category E
        open E.Equiv
        open Morphismₚ E

_ⓘˡ_ : ∀ {F G : Functor C D} →
         (H : Functor D E) → (η : NaturalIsomorphism F G) → NaturalIsomorphism (H ∘F F) (H ∘F G)
_ⓘˡ_ {C = C} {E = E} H η = record
  { F⇒G = H ∘ˡ F⇒G
  ; F⇐G = H ∘ˡ F⇐G
  ; iso = λ X → [ H ]-resp-Iso (iso X)
  }
  where open NaturalIsomorphism η
        open Functor H

_ⓘʳ_ : ∀ {F G : Functor C D} →
         (η : NaturalIsomorphism F G) → (K : Functor E C) → NaturalIsomorphism (F ∘F K) (G ∘F K)
_ⓘʳ_ η K = record
  { F⇒G = F⇒G ∘ʳ K
  ; F⇐G = F⇐G ∘ʳ K
  ; iso = λ X → iso (F₀ X)
  }
  where open NaturalIsomorphism η
        open Functor K

infix 4 _≅_
_≅_ : ∀ {F G : Functor C D} →
         (α β : NaturalIsomorphism F G) → Set _
α ≅ β = F⇒G ≃ β.F⇒G × F⇐G ≃ β.F⇐G
  where open NaturalIsomorphism α
        module β = NaturalIsomorphism β

≅-isEquivalence : ∀ {F G : Functor C D} → IsEquivalence (_≅_ {F = F} {G = G})
≅-isEquivalence {D = D} {F = F} {G = G} = record
  { refl  = H.refl , H.refl
  ; sym   = λ where
    (eq₁ , eq₂) → (H.sym eq₁) , (H.sym eq₂)
  ; trans = λ where
    (eq⇒₁ , eq⇐₁) (eq⇒₂ , eq⇐₂) →
      (H.trans eq⇒₁ eq⇒₂) , (H.trans eq⇐₁ eq⇐₂)
  }
  where module H = Category.HomReasoning D