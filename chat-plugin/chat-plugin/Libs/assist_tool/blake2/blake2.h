
#include <stdint.h>
#include <stddef.h>
#include <limits.h>
#ifndef PORTABLE_BLAKE2_H
#define PORTABLE_BLAKE2_H

enum blake2b_constant {
    BLAKE2B_BLOCKBYTES = 128,
    BLAKE2B_OUTBYTES = 64,
    BLAKE2B_KEYBYTES = 64,
    BLAKE2B_SALTBYTES = 16,
    BLAKE2B_PERSONALBYTES = 16
};

typedef struct __blake2b_param {
    uint8_t digest_length;                   
    uint8_t key_length;                      
    uint8_t fanout;                          
    uint8_t depth;                           
    uint32_t leaf_length;                    
    uint64_t node_offset;                    
    uint8_t node_depth;                      
    uint8_t inner_length;                    
    uint8_t reserved[14];                    
    uint8_t salt[BLAKE2B_SALTBYTES];         
    uint8_t personal[BLAKE2B_PERSONALBYTES]; 
} blake2b_param;

typedef struct __blake2b_state {
    uint64_t h[8];
    uint64_t t[2];
    uint64_t f[2];
    uint8_t buf[BLAKE2B_BLOCKBYTES];
    unsigned buflen;
    unsigned outlen;
    uint8_t last_node;
} blake2b_state;



enum {
    blake2_size_check_0 = 1 / !!(CHAR_BIT == 8),
    blake2_size_check_2 =
        1 / !!(sizeof(blake2b_param) == sizeof(uint64_t) * CHAR_BIT)
};

#ifdef __cplusplus
extern "C" {
#endif


int blake2b_init(blake2b_state *S, size_t outlen);
int blake2b_init_key(blake2b_state *S, size_t outlen, const void *key,
                     size_t keylen);
int blake2b_init_param(blake2b_state *S, const blake2b_param *P);
int blake2b_update(blake2b_state *S, const void *in, size_t inlen);
int blake2b_final(blake2b_state *S, void *out, size_t outlen);


int blake2b(void *out, size_t outlen, const void *in, size_t inlen,
                         const void *key, size_t keylen);





#ifdef __cplusplus
};
#endif

#endif