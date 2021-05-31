{-# OPTIONS --without-K --safe --show-implicit #-}

open import Categories.Category
open import Categories.Category.Monoidal.Core using (Monoidal)
open import Categories.Category.Monoidal.Symmetric using (Symmetric)

-- Throughout this section, let (M,J,⊙) be a symmetric monoidal category and let C be a category
-- So, here, we've got our module parameterized by two categories A and M with the symmetric monoidal structure of M given by Sym
module Categories.Category.Construction.Actegory {o ℓ e o' ℓ' e'} {M : Category o ℓ e} {Mon : Monoidal M} (M : Category o ℓ e) (A : Category o' ℓ' e') (Sym : Symmetric Mon)  where
open import Categories.Category.Product using (Product)
open import Categories.Functor.Core
open import Level


-- An M-actegory is a category C together with a functor • : M ×C → C
-- This is our functor that goes from M × C → C, it's parameterized by parameters given to this module.
F = Functor (Product M A) A
