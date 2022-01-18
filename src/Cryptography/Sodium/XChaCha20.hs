{-# LANGUAGE CApiFFI #-}
{-# LANGUAGE Trustworthy #-}

-- |
-- Module: Cryptography.Sodium.XChaCha20.Direct
-- Description: Direct bindings to XChaCha20 primitives
-- Copyright: (C) Koz Ross 2022
-- License: BSD-3-Clause
-- Maintainer: koz.ross@retro-freedom.nz
-- Stability: Stable
-- Portability: GHC only
--
-- Direct bindings to XChaCha20 primitives.
module Cryptography.Sodium.XChaCha20
  ( -- * Constants
    cryptoStreamXChaCha20KeyBytes,
    cryptoStreamXChaCha20NonceBytes,

    -- * Functions
    cryptoStreamXChaCha20,
    cryptoStreamXChaCha20Xor,
    cryptoStreamXChaCha20XorIC,
    cryptoStreamXChaCha20Keygen,
  )
where

import Data.Word (Word64)
import Foreign.C.Types
  ( CInt (CInt),
    CSize (CSize),
    CUChar,
    CULLong (CULLong),
  )
import Foreign.Ptr (Ptr)

-- | Generate and store a given number of pseudorandom bytes, using a nonce
-- and a secret key. The amount of data read from the nonce location and secret
-- key location will be 'cryptoStreamXChaCha20NonceBytes' and
-- 'cryptoStreamXChaCha20KeyBytes' respectively.
--
-- This function theoretically returns 0 on success, and -1 on failure. However,
-- [this cannot ever
-- fail](https://github.com/jedisct1/libsodium/discussions/1148#discussioncomment-1979161),
-- although its documentation does not explain this.
--
-- = Corresponds to
--
-- [@crypto_stream_xchacha20@](https://libsodium.gitbook.io/doc/advanced/stream_ciphers/xchacha20#usage)
--
-- @since 1.0
foreign import capi "sodium.h crypto_stream_xchacha20"
  cryptoStreamXChaCha20 ::
    -- | Out-parameter where pseudorandom bytes will be stored
    Ptr CUChar ->
    -- | How many bytes to write
    CULLong ->
    -- | Nonce location (see documentation, won't be modified)
    Ptr CUChar ->
    -- | Secret key location (see documentation, won't be modified)
    Ptr CUChar ->
    -- | Always 0 (see documentation)
    IO CInt

-- | Encrypt a message of the given length, using a nonce and a secret key. The
-- amount of data read from the nonce location and secret key location will be
-- 'cryptoStreamXChaCha20NonceBytes' and 'cryptoStreamXChaCha20KeyBytes'
-- respectively.
--
-- The resulting ciphertext does /not/ include an authentication tag. It will be
-- combined with the output of the stream cipher using the XOR operation.
--
-- This function theoretically returns 0 on success, and -1 on failure. However,
-- [this cannot ever
-- fail](https://github.com/jedisct1/libsodium/discussions/1148#discussioncomment-1979161),
-- although its documentation does not explain this.
--
-- = Important note
--
-- The message location and ciphertext location can be the same: this will
-- produce in-place encryption. However, if they are /not/ the same, they must
-- be non-overlapping.
--
-- = Corresponds to
--
-- [@crypto_stream_xchacha20_xor@](https://libsodium.gitbook.io/doc/advanced/stream_ciphers/xchacha20#usage)
--
-- @since 1.0
foreign import capi "sodium.h crypto_stream_xchacha20_xor"
  cryptoStreamXChaCha20Xor ::
    -- | Out-parameter where the ciphertext will be stored
    Ptr CUChar ->
    -- | Message location (won't be modified)
    Ptr CUChar ->
    -- | Message length
    CULLong ->
    -- | Nonce location (see documentation, won't be modified)
    Ptr CUChar ->
    -- | Secret key location (see documentation, won't be modified)
    Ptr CUChar ->
    -- | Always 0 (see documentation)
    IO CInt

-- | As 'cryptoStreamXChaCha20Xor', but allows setting the initial value of the
-- block counter to a non-zero value. This permits direct access to any block
-- without having to compute previous ones.
--
-- See the documentation of 'cryptoStreamXChaCha20Xor' for caveats on the use of
-- this function.
--
-- = Corresponds to
--
-- [@crypto_stream_xchacha20_xor_ic@](https://libsodium.gitbook.io/doc/advanced/stream_ciphers/xchacha20#usage)
--
-- @since 1.0
foreign import capi "sodium.h crypto_stream_xchacha20_xor_ic"
  cryptoStreamXChaCha20XorIC ::
    -- | Out-parameter where the ciphertext will be stored
    Ptr CUChar ->
    -- | Message location (won't be modified)
    Ptr CUChar ->
    -- | Message length
    CULLong ->
    -- | Nonce location (see documentation, won't be modified)
    Ptr CUChar ->
    -- | Value of block counter (see documentation)
    Word64 ->
    -- | Secret key location (see documentation, won't be modified)
    Ptr CUChar ->
    -- | Always 0 (see documentation)
    IO CInt

-- | Generate a random XChaCha20 secret key. This will always write
-- 'cryptoStreamXChaCha20KeyBytes' to the out-parameter.
--
-- = Corresponds to
--
-- [@crypto_stream_xchacha20_keygen@](https://libsodium.gitbook.io/doc/advanced/stream_ciphers/xchacha20#usage)
--
-- @since 1.0
foreign import capi "sodium.h crypto_stream_xchacha20_keygen"
  cryptoStreamXChaCha20Keygen ::
    -- | Out-parameter where the key will be stored
    Ptr CUChar ->
    -- | Doesn't return anything meaningful
    IO ()

-- | The number of bytes in an XChaCha20 secret key.
--
-- @since 1.0
foreign import capi "sodium.h value crypto_stream_xchacha20_KEYBYTES"
  cryptoStreamXChaCha20KeyBytes :: CSize

-- | The number of bytes in an XChaCha20 nonce.
--
-- @since 1.0
foreign import capi "sodium.h value crypto_stream_xchacha20_NONCEBYTES"
  cryptoStreamXChaCha20NonceBytes :: CSize
