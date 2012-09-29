#ifndef NFCGLOBAL_H
#define NFCGLOBAL_H

namespace nfc {
#ifdef NFC_USE_DOUBLE_PRECISION
    typedef double nfcReal;
//    #define NFC_EPSILON 1e-14;
#else
    typedef float nfcReal;
//    #define NFC_EPSILON 1e-6;
#endif
}

#endif // NFCGLOBAL_H
