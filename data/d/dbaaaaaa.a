
// imgprocDlg.h : header file
//

#pragma once


// CImgProcDlg dialog
class CImgProcDlg : public CDialog
{
// Construction
public:
	CImgProcDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_IMGPROC_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;
	void DrawOne(PCWSTR filepath, int x);

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
	virtual void OnOK();
	virtual void OnCancel();
};
