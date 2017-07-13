
// imgproc.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CImgProcApp:
// See imgproc.cpp for the implementation of this class
//

class CImgProcApp : public CWinAppEx
{
public:
	CImgProcApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation
	ULONG_PTR m_gdiplusToken;

	DECLARE_MESSAGE_MAP()
	virtual int ExitInstance();
};

extern CImgProcApp theApp;