// Simple Captcha Recognition
// For 2016/5/20 captcha set
//
// imgprocDlg.cpp : implementation file
//

#include "stdafx.h"
#include "imgproc.h"
#include "imgprocDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CImgProcDlg dialog

CImgProcDlg::CImgProcDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CImgProcDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CImgProcDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CImgProcDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


// CImgProcDlg message handlers

BOOL CImgProcDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CImgProcDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CImgProcDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CImgProcDlg::DrawOne(PCWSTR filepath, int startX)
{
	Bitmap *bitmap = Bitmap::FromFile(filepath);
	PixelFormat pxlfmt = bitmap->GetPixelFormat();	// PixelFormat24bppRGB

	Graphics graphics(*GetDC());
	graphics.DrawImage(bitmap, startX, 10);

	UINT width, height;
	width = bitmap->GetWidth();
	height = bitmap->GetHeight();

//	Bitmap *bmp2 = bitmap->Clone(0, 0, width, height, PixelFormatDontCare); // Can not use PixelFormat16bppGrayScale
//	UINT status = bmp2->ConvertFormat(PixelFormat16bppGrayScale, DitherTypeNone, PaletteTypeCustom, NULL, 0);	
	//Bitmap bmp1(width, height, PixelFormat24bppRGB);
	//Bitmap bmp2(width, height, PixelFormat24bppRGB);
	Bitmap bmp3(width, height, PixelFormat24bppRGB);
	Bitmap bmp4(width, height, PixelFormat24bppRGB);
	//Bitmap bmp5(width, height, PixelFormat24bppRGB);
	//Bitmap bmp6(width, height, PixelFormat24bppRGB);
	for( UINT y = 0; y < height; ++y )
	{
		for( UINT x = 0; x < width; ++x )
		{
			// Get the pixel at x,y
			Color PixelColor;
			bitmap->GetPixel( x, y, &PixelColor );

			//UINT GrayValue = 0.3*PixelColor.GetR() + 0.59*PixelColor.GetG() + 0.11*PixelColor.GetB();

			// Convert it to COLORREF
			COLORREF RgbColor = PixelColor.ToCOLORREF();

			// Convert to HLS Color space
			WORD Hue = 0;
			WORD Luminance = 0;
			WORD Saturation = -100;
			ColorRGBToHLS( RgbColor, &Hue, &Luminance, &Saturation );
			//Luminance = GrayValue;

			/*
			if ( Luminance > 0x90 )
				RgbColor = RGB(0xFF, 0xFF, 0xFF);
			else
				RgbColor = RGB(0x00, 0x00, 0x00);
			PixelColor.SetFromCOLORREF( RgbColor );
			bmp1.SetPixel( x, y, PixelColor );

			if ( Luminance > 0xA0 )
				RgbColor = RGB(0xFF, 0xFF, 0xFF);
			else
				RgbColor = RGB(0x00, 0x00, 0x00);
			// Set the saturation to 0 so that the
			// image will be greyscale.
			//Saturation = 1;

			// Now re-generate HLS to RGB
			//RgbColor = ColorHLSToRGB( Hue, Luminance, Saturation );

			// Convert back to Gdi+.
			PixelColor.SetFromCOLORREF( RgbColor );

			// Set it to image.
			bmp2.SetPixel( x, y, PixelColor );
			*/

			if ( Luminance > 0xB0 )
				RgbColor = RGB(0xFF, 0xFF, 0xFF);
			else
				RgbColor = RGB(0x00, 0x00, 0x00);
			PixelColor.SetFromCOLORREF( RgbColor );
			bmp3.SetPixel( x, y, PixelColor );

			if ( Luminance > 0xC0 )
				RgbColor = RGB(0xFF, 0xFF, 0xFF);
			else
				RgbColor = RGB(0x00, 0x00, 0x00);
			PixelColor.SetFromCOLORREF( RgbColor );
			bmp4.SetPixel( x, y, PixelColor );

			/*
			if ( Luminance > 0xD0 )
				RgbColor = RGB(0xFF, 0xFF, 0xFF);
			else
				RgbColor = RGB(0x00, 0x00, 0x00);
			PixelColor.SetFromCOLORREF( RgbColor );
			bmp5.SetPixel( x, y, PixelColor );

			if ( Luminance > 0xE0 )
				RgbColor = RGB(0xFF, 0xFF, 0xFF);
			else
				RgbColor = RGB(0x00, 0x00, 0x00);
			PixelColor.SetFromCOLORREF( RgbColor );
			bmp6.SetPixel( x, y, PixelColor );
			*/
		}
	}
//	graphics.DrawImage(&bmp1, startX, 10+(height+1));
//	graphics.DrawImage(&bmp2, startX, 10+(height+1)*2);
	graphics.DrawImage(&bmp3, startX, 10+(height+1)*1);
	graphics.DrawImage(&bmp4, startX, 10+(height+1)*2);
//	graphics.DrawImage(&bmp5, startX, 10+(height+1)*5);
//	graphics.DrawImage(&bmp6, startX, 10+(height+1)*6);
	
	//delete bitmap;	// needed?
}


// Each digit dimension: 16*20
#define DIGIT_WIDTH 16
#define DIGIT_HEIGHT 20

Bitmap *Cut(Bitmap *bitmap, int index)
{
	Bitmap *bmp = bitmap->Clone(6+index*DIGIT_WIDTH, 5, DIGIT_WIDTH, DIGIT_HEIGHT, PixelFormatDontCare);
	for( UINT y = 0; y < DIGIT_HEIGHT; ++y )
	{
		for( UINT x = 0; x < DIGIT_WIDTH; ++x )
		{
			// Get the pixel at x,y
			Color PixelColor;
			bmp->GetPixel( x, y, &PixelColor );

			// Convert it to COLORREF
			COLORREF RgbColor = PixelColor.ToCOLORREF();

			// Convert to HLS Color space
			WORD Hue = 0;
			WORD Luminance = 0;
			WORD Saturation = -100;
			ColorRGBToHLS( RgbColor, &Hue, &Luminance, &Saturation );

			// Greyscale and threshold
			if ( Luminance > 0xB0 )
				RgbColor = RGB(0xFF, 0xFF, 0xFF);
			else
				RgbColor = RGB(0x00, 0x00, 0x00);
			PixelColor.SetFromCOLORREF( RgbColor );
			bmp->SetPixel( x, y, PixelColor );
		}
	}
	return bmp;
}

int DiffInt(UINT *bmp1, UINT *bmp2)
{
	int diff = 0;
	for (int i=0; i<DIGIT_WIDTH*DIGIT_HEIGHT; i++)
	{
		if ( bmp1[i] != bmp2[i] )
			diff ++;
	}
	return diff;
}

int Recognize1(UINT *dig, UINT *sample[10])
{
	int nearest = DIGIT_WIDTH*DIGIT_HEIGHT+1;
	int which = -1;
	for (int i=0; i<10; i++)
	{
		int diff = DiffInt(dig, sample[i]);
		if ( diff < nearest )
		{
			nearest = diff;
			which = i;
		}
		//TRACE("%3d ", diff);
	}
	return which;
}

void Recognize(Bitmap *bmp, UINT *sample[10], int guess[6])
{
	Rect rc(0, 0, DIGIT_WIDTH, DIGIT_HEIGHT);
	for (int c=0; c<6; c++)
	{
		Bitmap *dig = Cut(bmp, c);
		BitmapData bmpData;
		Status st1 = dig->LockBits(&rc, ImageLockModeRead, PixelFormat32bppARGB, &bmpData);
		guess[c] = Recognize1((UINT*)bmpData.Scan0, sample);
		//TRACE("\n");
		//dig->UnlockBits(&bmpData);	// memory leak?
		//delete dig;
	}
}

const CString szDirInput = L"D:\\Google Drive\\paipai\\captcha\\entrance0520\\";
const CString szDirOutput = L"D:\\pi\\imgproc.root\\out\\";

void RecognizeX(PCWCHAR baseDir, PCWCHAR fn, UINT *sample[])
{
	WCHAR path[MAX_PATH];
	wcscpy(path, baseDir);
	wcscat(path, fn);
	Bitmap capX(path);
	int guess[6];
	Recognize(&capX, sample, guess);
	WCHAR path2[MAX_PATH];
	wcscpy(path2, szDirOutput);
	WCHAR fnOut[MAX_PATH];
	wsprintf(fnOut, L"%d%d%d%d%d%d.png", guess[0], guess[1], guess[2], guess[3], guess[4], guess[5]);
	wcscat(path2, fnOut);
	TRACE(L"%s -> %s\n", path, path2);
	if (!CopyFile(path, path2, TRUE))
	{
		TRACE("WTF!\n");
	}
}

void CImgProcDlg::OnOK()
{
	GetDlgItem(IDOK)->EnableWindow(FALSE);

	// Test grayscale method
	DrawOne(szDirInput+L"869f8c2e-e145-4f4a-ba5d-2ccc344cf9a6.png", 10+(113+4)*0);	// 0
	DrawOne(szDirInput+L"0ba62f2c-e4ef-4185-a42a-e6e0d63a9714.png", 10+(113+4)*1);	// 1
	DrawOne(szDirInput+L"3baa1275-4a2f-4219-ac7e-eafbe19e9885.png", 10+(113+4)*2);	// 2,7
	DrawOne(szDirInput+L"8cb2c696-dcbd-4b24-b829-5425e7c0fae3.png", 10+(113+4)*3);	// 3,5
	DrawOne(szDirInput+L"1cca63c8-069e-4f56-ac75-4f3f89f5a1e1.png", 10+(113+4)*4);	// 4,8
	DrawOne(szDirInput+L"3a5f3568-5089-4b92-9c72-e100cf957fcb.png", 10+(113+4)*5);	// 6
	DrawOne(szDirInput+L"7a0f1c49-0bce-4e01-87eb-a5b909e2462a.png", 10+(113+4)*6);	// 9

	// Grab golden samples
	Bitmap *digit[10];
	Bitmap cap0(szDirInput+L"869f8c2e-e145-4f4a-ba5d-2ccc344cf9a6.png");
	digit[0] = Cut(&cap0, 5);
	Bitmap cap1(szDirInput+L"0ba62f2c-e4ef-4185-a42a-e6e0d63a9714.png");
	digit[1] = Cut(&cap1, 5);
	Bitmap cap27(szDirInput+L"3baa1275-4a2f-4219-ac7e-eafbe19e9885.png");
	digit[2] = Cut(&cap27, 5);
	digit[7] = Cut(&cap27, 3);
	Bitmap cap35(szDirInput+L"8cb2c696-dcbd-4b24-b829-5425e7c0fae3.png");
	digit[3] = Cut(&cap35, 0);
	digit[5] = Cut(&cap35, 3);
	Bitmap cap48(szDirInput+L"1cca63c8-069e-4f56-ac75-4f3f89f5a1e1.png");
	digit[4] = Cut(&cap48, 0);
	digit[8] = Cut(&cap48, 1);
	Bitmap cap6(szDirInput+L"3a5f3568-5089-4b92-9c72-e100cf957fcb.png");
	digit[6] = Cut(&cap6, 5);
	Bitmap cap9(szDirInput+L"7a0f1c49-0bce-4e01-87eb-a5b909e2462a.png");
	digit[9] = Cut(&cap9, 0);

	Graphics graphics(*GetDC());

	for (int i=0; i<10; i++)
	{
		graphics.DrawImage(digit[i], 10+(18)*i, 120);
	}

	UINT *sample[10];
	Rect rc(0, 0, DIGIT_WIDTH, DIGIT_HEIGHT);
	BitmapData bmpData1;
	for (int i=0; i<10; i++)
	{
		Status st1 = digit[i]->LockBits(&rc, ImageLockModeRead, PixelFormat32bppARGB, &bmpData1);
		sample[i] = (UINT*)bmpData1.Scan0;
	}

	WIN32_FIND_DATA fd;
	HANDLE hFind = FindFirstFile(szDirInput+L"*.png", &fd);
	if (hFind != INVALID_HANDLE_VALUE)
	{
		RecognizeX(szDirInput, fd.cFileName, sample);
		while (FindNextFile(hFind, &fd))
		{
			RecognizeX(szDirInput, fd.cFileName, sample);
		}
		FindClose(hFind);
	}

	GetDlgItem(IDOK)->EnableWindow(TRUE);
	//CDialog::OnOK();
}
