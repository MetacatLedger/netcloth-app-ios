
#ifndef SECP256K1_ECMULT_H
#define SECP256K1_ECMULT_H

#include "num.h"
#include "group.h"
#include "scalar.h"
#include "scratch.h"

typedef struct {
    
    secp256k1_ge_storage (*pre_g)[];    
#ifdef USE_ENDOMORPHISM
    secp256k1_ge_storage (*pre_g_128)[]; 
#endif
} secp256k1_ecmult_context;

static void secp256k1_ecmult_context_init(secp256k1_ecmult_context *ctx);
static void secp256k1_ecmult_context_build(secp256k1_ecmult_context *ctx, const secp256k1_callback *cb);
static void secp256k1_ecmult_context_clone(secp256k1_ecmult_context *dst,
                                           const secp256k1_ecmult_context *src, const secp256k1_callback *cb);
static void secp256k1_ecmult_context_clear(secp256k1_ecmult_context *ctx);
static int secp256k1_ecmult_context_is_built(const secp256k1_ecmult_context *ctx);


static void secp256k1_ecmult(const secp256k1_ecmult_context *ctx, secp256k1_gej *r, const secp256k1_gej *a, const secp256k1_scalar *na, const secp256k1_scalar *ng);

typedef int (secp256k1_ecmult_multi_callback)(secp256k1_scalar *sc, secp256k1_ge *pt, size_t idx, void *data);

static int secp256k1_ecmult_multi_var(const secp256k1_ecmult_context *ctx, secp256k1_scratch *scratch, secp256k1_gej *r, const secp256k1_scalar *inp_g_sc, secp256k1_ecmult_multi_callback cb, void *cbdata, size_t n);

#endif 