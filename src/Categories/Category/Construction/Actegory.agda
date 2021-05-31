{-# OPTIONS --without-K --safe --show-implicit #-}

open import Categories.Category
open import Categories.Category.Monoidal.Core using (Monoidal)
open import Categories.Category.Monoidal.Symmetric using (Symmetric)

module Categories.Category.Construction.Actegory {o ℓ e o' ℓ' e'} {M : Category o ℓ e} {Mon : Monoidal M} (M : Category o ℓ e) (A : Category o' ℓ' e') (Sym : Symmetric Mon)  where
open import Categories.Category.Product using (Product)
open import Categories.Functor.Core
open import Level

F = Functor (Product M A) A
