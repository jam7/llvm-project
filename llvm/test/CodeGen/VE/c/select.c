typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned int uint32_t;
typedef long int64_t;
typedef unsigned long uint64_t;
typedef __int128 int128_t;
typedef unsigned __int128 uint128_t;
typedef long double quad;

#define SELECT(TY) \
TY func_ ## TY(_Bool cmp, TY a, TY b) { \
  return cmp ? a : b; \
}

SELECT(int8_t)
SELECT(uint8_t)
SELECT(int16_t)
SELECT(uint16_t)
SELECT(int32_t)
SELECT(uint32_t)
SELECT(int64_t)
SELECT(uint64_t)
SELECT(int128_t)
SELECT(uint128_t)
SELECT(float)
SELECT(double)
SELECT(quad)
