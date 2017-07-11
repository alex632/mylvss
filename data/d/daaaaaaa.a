// Agent.cpp : Implementation of CEagentApp and DLL registration.

#include "stdafx.h"
#include "Eagent.h"
#include "Agent.h"
#include <ExDispID.h>
#include <Mshtml.h>

/////////////////////////////////////////////////////////////////////////////
//

/*
STDMETHODIMP CAgent::InterfaceSupportsErrorInfo(REFIID riid)
{
	static const IID* arr[] =
	{
		&IID_IAgent,
	};

	for (int i=0;i<sizeof(arr)/sizeof(arr[0]);i++)
	{
		if (InlineIsEqualGUID(*arr[i],riid))
			return S_OK;
	}
	return S_FALSE;
}
*/


BOOL CAgent::ManageConnection(enum ConnectType eConnectType)
{
   HRESULT hr = E_FAIL;

   //
   // If eConnectType is Advise then we are advising IE that we
   // want to handle events.  If eConnectType is Unadvise, we are
   // telling IE that we no longer want to handle events.
   //
   CComQIPtr<IConnectionPointContainer,&IID_IConnectionPointContainer> spCPContainer(m_spWebBrowser2);

   if (spCPContainer != NULL)
   {
      CComPtr<IConnectionPoint> spConnectionPoint;

      hr = spCPContainer->FindConnectionPoint(DIID_DWebBrowserEvents2, &spConnectionPoint);
      if (SUCCEEDED(hr))
      {
         if (eConnectType == Advise)
         {
            // Advise the client site of our desire to be handle events
            hr = spConnectionPoint->Advise((IDispatch*)this, &m_dwCookie);
            if (FAILED(hr))
               ATLTRACE("ManageConnection(): Failed to Advise\n");
         }
         else
         {
            // Remove us from the list of people interested...
            hr = spConnectionPoint->Unadvise(m_dwCookie);
            if (FAILED(hr))
               ATLTRACE("ManageConnection(): Failed to Unadvise\n");
         }
      }
   }

   return (SUCCEEDED(hr));
}

//
// IObjectWithSite Methods
//
STDMETHODIMP CAgent::SetSite(IUnknown *pUnkSite)
{
	// Retrieve and store the IWebBrowser2 pointer
	m_spWebBrowser2 = pUnkSite;
	if (m_spWebBrowser2 == NULL)
		return E_INVALIDARG;

	// Connect to the browser in order to handle events.
	if (!ManageConnection(Advise))
	{
		ATLTRACE("SetSite(): Failure connecting to Browser\n");
		return E_FAIL;
	}

	return S_OK;
}

//
// IDispatch Methods
//
STDMETHODIMP CAgent::Invoke(
	DISPID dispidMember, REFIID riid, LCID lcid, WORD wFlags,
	DISPPARAMS* pDispParams, VARIANT* pvarResult,
	EXCEPINFO*  pExcepInfo,  UINT* puArgErr)
{
	//USES_CONVERSION;
	if (!pDispParams)
		return E_INVALIDARG;

	switch (dispidMember)
	{
	//
	// The parameters for this DISPID:
	// [0]: URL navigated to - VT_BYREF|VT_VARIANT
	// [1]: An object that evaluates to the top-level or frame
	//      WebBrowser object corresponding to the event.
	//
	case DISPID_DOCUMENTCOMPLETE:
		if (pDispParams->rgvarg[0].vt == (VT_BYREF|VT_VARIANT))
		{
			CComVariant varURL(*pDispParams->rgvarg[0].pvarVal);
			varURL.ChangeType(VT_BSTR);
			if ( pDispParams->rgvarg[1].vt == VT_DISPATCH )
			{
				CComPtr<IDispatch> pDisp = pDispParams->rgvarg[1].pdispVal;
				HackIt(varURL.bstrVal, pDisp);
			}
		}
		break;

	//
	// The parameters for this DISPID:
	// [0]: Address of cancel flag - VT_BYREF|VT_BOOL
	//
	case DISPID_QUIT:
		ManageConnection(Unadvise);
		break;

	default:
		break;
	}

	return S_OK;
}

//
// Make sure the page is what I want to hack. Leave others alone.
// This page must have <img id='imgcode'> and <input id='imagenumberrefresh'>.
//
bool VerifyTarget(IHTMLDocument2* pDoc2)
{
	CComQIPtr<IHTMLDocument3> pDoc3 = pDoc2;
	if ( !pDoc3 )
		return false;

	CComPtr<IHTMLElement> img, btn;
	CComBSTR tagImg, tagBtn;
	HRESULT hr;

	hr = pDoc3->getElementById(L"imgcode", &img);
	if FAILED(hr)	// always S_OK, bug?
		return false;
	if ( !img )
		return false;	// not found
	hr = img->get_tagName(&tagImg);
	if ( FAILED(hr) )
		return false;
	if ( tagImg != L"IMG" )
		return false;

	hr = pDoc3->getElementById(L"imagenumberrefresh", &btn);
	if FAILED(hr)	// always S_OK, bug?
		return false;
	if ( !btn )
		return false;	// not found
	hr = btn->get_tagName(&tagBtn);
	if ( FAILED(hr) )
		return false;
	if ( tagBtn != L"A" )
		return false;

	return true;
}

void AddScript(IHTMLDocument2* pDoc, BSTR bstrScript)
{
	HRESULT hr;
	CComPtr<IHTMLElement> htmlElement;

	if ( !SUCCEEDED(hr = pDoc->createElement(CComBSTR("script"), &htmlElement)) )
	{
		ATLTRACE(_T("createElement of type script failed: %X\n"), hr);
		return;
	}

	CComPtr<IHTMLScriptElement> htmlScript;
	if ( !SUCCEEDED(hr = htmlElement.QueryInterface<IHTMLScriptElement>(&htmlScript)) )
	{
		ATLTRACE(_T("QueryInterface<IHTMLScriptElement> failed: %X\n"), hr);
		return;
	}

	htmlScript->put_type(CComBSTR("text/javascript"));
	htmlScript->put_text(bstrScript);

	CComPtr<IHTMLDocument3> htmlDocument3;
	if ( !SUCCEEDED(hr = pDoc->QueryInterface<IHTMLDocument3>(&htmlDocument3)) )
	{
		ATLTRACE(_T("QueryInterface<IHTMLDocument3> failed: %X\n"), hr);
		return;
	}

	CComPtr<IHTMLElementCollection> htmlElementCollection;
	if ( !SUCCEEDED(hr = htmlDocument3->getElementsByTagName(CComBSTR("head"), &htmlElementCollection)) )
	{
		ATLTRACE(_T("getElementsByTagName failed: %X\n"), hr);
		return;
	}

	CComVariant varItemIndex(0);
	CComVariant varEmpty;

	CComPtr<IDispatch> dispatchHeadElement;
	if ( !SUCCEEDED(hr = htmlElementCollection->item(varEmpty, varItemIndex, &dispatchHeadElement)) )
	{
		ATLTRACE(_T("item failed: %X\n"), hr);
		return;
	}

	if ( dispatchHeadElement == NULL )
	{
		ATLTRACE(_T("dispatchHeadElement == NULL"));
		return;
	}

	CComQIPtr<IHTMLDOMNode, &IID_IHTMLDOMNode> spHeadNode = dispatchHeadElement; // query for DOM interfaces
	CComQIPtr<IHTMLDOMNode, &IID_IHTMLDOMNode> spNodeNew = htmlScript;

	if (spHeadNode)
	{
		if ( !SUCCEEDED(hr = spHeadNode->appendChild(spNodeNew, NULL)) )
		{
			ATLTRACE(_T("Script injection failed: %X\n"), hr);
			return;
		}
	}
}

void CAgent::HackIt(BSTR bstrUrl, IDispatch* pWindow)
{
	if ( _wcsnicmp(bstrUrl, L"about", 5) == 0 )
		return;

	// The real one
	CComQIPtr<IWebBrowser2> spWebBrowser2(pWindow);
	if ( !spWebBrowser2 )
		return;

	// Get the WebBrowser's document object
	CComPtr<IDispatch> pDisp2;
	HRESULT hr = spWebBrowser2->get_Document(&pDisp2);
	if (FAILED(hr))
		return;

	// Verify that what we get is a pointer to a IHTMLDocument2
	// interface. To be sure, let's query for
	// the IHTMLDocument2 interface (through smart pointers)
	CComQIPtr<IHTMLDocument2> spMyHTML;
	spMyHTML = pDisp2;
	if (!spMyHTML)
		return;	// The document isn't an HTML page

	if ( !VerifyTarget(spMyHTML) )
		return;

	ATLTRACE(_T("Target found\n"));

    // Get the BODY object
	CComPtr<IHTMLElement> pMyBody;
	hr = spMyHTML->get_body(&pMyBody);
	if ( FAILED(hr) )
		return;

	Load2Files();

	AddScript(spMyHTML, m_bstrScript);
	hr = pMyBody->insertAdjacentHTML(L"afterBegin", m_bstrHtml);
//	if (FAILED(hr))
//		return;

	/* Begin: Dump
	// Get the HTML source AFTER insertion
	BSTR bstrHTMLText2;
	hr = pMyBody->get_outerHTML(&bstrHTMLText2);
	if (FAILED(hr))
		return;
	LPCTSTR strHTMLText2 = OLE2T(bstrHTMLText2);

	{
		BSTR bstrLocationURL;
		LPCTSTR szLocationURL = _T("");
		hr = m_spWebBrowser2->get_LocationURL(&bstrLocationURL);
		if (FAILED(hr))
			return;
		szLocationURL = OLE2CT(bstrLocationURL);
		if ( _tcscmp(pszUrl,szLocationURL) == 0 )	// I'm in the top level
		{
			TCHAR fn[MAX_PATH];
			TCHAR fname[MAX_PATH];
			GetModuleFileName(_Module.m_hInst, fn, MAX_PATH);
			GetLongPathName(fn, fname, MAX_PATH);
			_tcscat(fname, _T(".after.htm"));

			//FILE *fp1 = fopen("D:\\Lab\\BHO\\iehelper\\TMP\\before.htm", "wb");
			FILE *fp2 = fopen(fname, "wb");
			if ( fp2 )
			{
				fwrite(strHTMLText2, 1, strlen(strHTMLText2), fp2);
				fclose(fp2);
			}
		}
	}
	End: Dump */
}

void CAgent::LoadFile(LPCTSTR ext, CComBSTR &bstrText, FILETIME &ftText)
{
	TCHAR fn[MAX_PATH];
	TCHAR fname[MAX_PATH+60];
	GetModuleFileName(_Module.m_hInst, fn, MAX_PATH);
	GetLongPathName(fn, fname, MAX_PATH);
	_tcscat_s(fname, ext);
	HANDLE hFile = CreateFile(fname, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);

	if ( hFile == INVALID_HANDLE_VALUE )
		return;

	FILETIME ftCreated, ftModified;
	BOOL bRet;
	bRet = GetFileTime(hFile, &ftCreated, NULL, &ftModified);
	if ( ftText.dwLowDateTime==ftModified.dwLowDateTime && ftText.dwHighDateTime==ftModified.dwHighDateTime )
		goto cleanup;	// not modified

	ftText.dwLowDateTime = ftModified.dwLowDateTime;
	ftText.dwHighDateTime = ftModified.dwHighDateTime;

	DWORD BytesToRead, BytesRead;
	BytesToRead = GetFileSize(hFile, NULL);
	if ( BytesToRead == INVALID_FILE_SIZE )
		goto cleanup;

	bstrText.Empty();
	if ( BytesToRead >= 2 )
	{
		BYTE *buf = new BYTE[BytesToRead+2];
		if ( buf == NULL )
			goto cleanup;

		bRet = ReadFile(hFile, buf, BytesToRead, &BytesRead, NULL);
		if ( bRet && BytesToRead == BytesRead )
		{
			buf[BytesRead] = 0;
			buf[BytesRead+1] = 0;
			if ( buf[0] == 0xFF && buf[1] == 0xFE )
				bstrText = LPCWSTR(buf+2);
		}
		delete[] buf;
	}
cleanup:
	CloseHandle(hFile);
}

void CAgent::Load2Files()
{
	LoadFile(_T(".js"), m_bstrScript, m_ftScript);
	LoadFile(_T(".html"), m_bstrHtml, m_ftHtml);
}
