// Agent.h: Definition of the CAgent class
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_AGENT_H__8226903A_7982_40C4_8747_6D0B52908A9E__INCLUDED_)
#define AFX_AGENT_H__8226903A_7982_40C4_8747_6D0B52908A9E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "resource.h"       // main symbols
#include <ExDisp.h>

/////////////////////////////////////////////////////////////////////////////
// CAgent

class CAgent : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CAgent, &CLSID_Agent>,
	public IObjectWithSiteImpl<CAgent>,
//	public IDispatchImpl<IAgent, &IID_IAgent, &LIBID_ImAgentLib, /*wMajor =*/ 1, /*wMinor =*/ 0>

	public IDispatchImpl<IAgent, &IID_IAgent, &LIBID_EAGENTLib>
//	public ISupportErrorInfo,
//	public CComObjectRoot,
//	public CComCoClass<CAgent,&CLSID_Agent>
{
public:
	CAgent()
	{
		m_ftScript.dwLowDateTime = 0;
		m_ftScript.dwHighDateTime = 0;
		m_ftHtml.dwLowDateTime = 0;
		m_ftHtml.dwHighDateTime = 0;
	}

BEGIN_COM_MAP(CAgent)
	COM_INTERFACE_ENTRY(IDispatch)
	COM_INTERFACE_ENTRY(IAgent)
	COM_INTERFACE_ENTRY(IObjectWithSite)
//	COM_INTERFACE_ENTRY(ISupportErrorInfo)
END_COM_MAP()
//DECLARE_NOT_AGGREGATABLE(CAgent) 
// Remove the comment from the line above if you don't want your object to 
// support aggregation. 

DECLARE_REGISTRY_RESOURCEID(IDR_Agent)
// ISupportsErrorInfo
	//STDMETHOD(InterfaceSupportsErrorInfo)(REFIID riid);

// IAgent
public:
	//
	// IDispatch Methods
	//
	STDMETHOD(Invoke)(DISPID dispidMember,REFIID riid, LCID lcid, WORD wFlags,
					DISPPARAMS * pdispparams, VARIANT * pvarResult,
					EXCEPINFO * pexcepinfo, UINT * puArgErr);

	//
	// IObjectWithSite Methods (IE)
	//
	STDMETHOD(SetSite)(IUnknown *pUnkSite);

private:
	CComQIPtr<IWebBrowser2, &IID_IWebBrowser2> m_spWebBrowser2;

	DWORD m_dwCookie;   // Connection Token - used for Advise and Unadvise

	enum ConnectType { Advise, Unadvise };   // What to do when managing the connection

	BOOL ManageConnection(enum ConnectType eConnectType);

	void HackIt(BSTR bstrUrl, IDispatch* pWindow);

	CComBSTR m_bstrScript;
	CComBSTR m_bstrHtml;
	FILETIME m_ftScript;
	FILETIME m_ftHtml;

	void LoadFile(LPCTSTR ext, CComBSTR &bstrText, FILETIME &ftText);
	void Load2Files();
};

#endif // !defined(AFX_AGENT_H__8226903A_7982_40C4_8747_6D0B52908A9E__INCLUDED_)
