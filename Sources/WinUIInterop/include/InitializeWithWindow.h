#include <inspectable.h>
#include <EventToken.h>
#include <windowscontracts.h>
#include "Windows.Foundation.h"

#if !defined(__ABI_IInitializeWithWindow_INTERFACE_DEFINED__)
    #define __ABI_IInitializeWithWindow_INTERFACE_DEFINED__

    typedef struct ABI_IInitializeWithWindowVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IInitializeWithWindow * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IInitializeWithWindow * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IInitializeWithWindow * This);
        
        HRESULT ( STDMETHODCALLTYPE *Initialize )( 
            IInitializeWithWindow * This,
            /* [in] */ HWND hwnd);
        
        END_INTERFACE
    } IInitializeWithWindowVtbl;

    interface ABI_IInitializeWithWindow
    {
        CONST_VTBL struct IInitializeWithWindowVtbl *lpVtbl;
    };
    
    EXTERN_C const IID IID_IInitializeWithWindow;
#endif /* !defined(__ABI_IInitializeWithWindow_INTERFACE_DEFINED__) */
