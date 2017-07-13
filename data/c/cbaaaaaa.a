
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


Bitmap *Cut(Bitmap *bitmap, int index, int oftX=0, int oftY=0)
{
	// Each digit dimension: 16x19
	Bitmap *bmp = bitmap->Clone(6+index*16+oftX, 6+oftY, 16, 19, PixelFormatDontCare);
	for( UINT y = 0; y < 19; ++y )
	{
		for( UINT x = 0; x < 16; ++x )
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
	for (int i=0; i<16*19; i++)
	{
		if ( bmp1[i] != bmp2[i] )
			diff ++;
	}
	return diff;
}

int Recognize1(UINT *dig, UINT *sample[10])
{
	int nearest = 16*19+1;
	int which = -1;
	for (int i=0; i<10; i++)
	{
		int diff = DiffInt(dig, sample[i]);
		if ( diff < nearest )
		{
			nearest = diff;
			which = i;
		}
		TRACE("%3d ", diff);
	}
	return which;
}

void Recognize(Bitmap *bmp, UINT *sample[10], int guess[6], int oftX=0, int oftY=0)
{
	Rect rc(0, 0, 16, 19);
	for (int c=0; c<6; c++)
	{
		Bitmap *dig = Cut(bmp, c, oftX, oftY);
		BitmapData bmpData;
		Status st1 = dig->LockBits(&rc, ImageLockModeRead, PixelFormat32bppARGB, &bmpData);
		guess[c] = Recognize1((UINT*)bmpData.Scan0, sample);
		TRACE("\n");
		//dig->UnlockBits(&bmpData);	// memory leak?
		delete dig;
	}
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

void CImgProcDlg::OnOK()
{
	DrawOne(L"D:\\paipai\\captcha\\entrance\\01fa74a4-f4d7-44bd-aa45-eec620c0495d.jpg", 10);
	DrawOne(L"D:\\paipai\\captcha\\entrance\\37e9b384-e42f-44b4-849a-19daaa678911.jpg", 10+(113+4)*1);
	DrawOne(L"D:\\paipai\\captcha\\entrance\\9fca6efb-2fee-4d81-a07e-8bded11354c1.jpg", 10+(113+4)*2);
	DrawOne(L"D:\\paipai\\captcha\\entrance\\1c4ed65c-1faa-4ce6-9008-eada99e1facb.jpg", 10+(113+4)*3);
	DrawOne(L"D:\\paipai\\captcha\\entrance\\83789034-8d1f-4172-9a4b-40a295aa6a70.jpg", 10+(113+4)*4);	// 8
	DrawOne(L"D:\\paipai\\captcha\\entrance\\449f08b6-0f87-4e51-8643-e1bbd1876dae.jpg", 10+(113+4)*5);	// 2

	Bitmap *digit[10];
	Bitmap cap3(L"D:\\paipai\\captcha\\entrance\\01fa74a4-f4d7-44bd-aa45-eec620c0495d.jpg");
	digit[3] = Cut(&cap3, 0);
	Bitmap cap1(L"D:\\paipai\\captcha\\entrance\\37e9b384-e42f-44b4-849a-19daaa678911.jpg");
	digit[1] = Cut(&cap1, 0);
	Bitmap cap2(L"D:\\paipai\\captcha\\entrance\\9fca6efb-2fee-4d81-a07e-8bded11354c1.jpg");
	digit[2] = Cut(&cap2, 5);
	Bitmap cap5(L"D:\\paipai\\captcha\\entrance\\1c4ed65c-1faa-4ce6-9008-eada99e1facb.jpg");
	digit[5] = Cut(&cap5, 2);
	Bitmap cap8(L"D:\\paipai\\captcha\\entrance\\83789034-8d1f-4172-9a4b-40a295aa6a70.jpg");
	digit[8] = Cut(&cap8, 0);
	Bitmap cap6(L"D:\\paipai\\captcha\\entrance\\a8998c14-1df8-408d-952d-997f4a78998a.jpg");
	digit[6] = Cut(&cap6, 0);
	Bitmap cap9(L"D:\\paipai\\captcha\\entrance\\d0e36b69-e42d-4581-b5ee-daf87fd7527c.jpg");
	digit[9] = Cut(&cap9, 5);
	Bitmap cap7(L"D:\\paipai\\captcha\\entrance\\d7783306-064a-4e2e-95c7-5516f788f7c1.jpg");
	digit[7] = Cut(&cap7, 4);
	digit[4] = Cut(&cap7, 5);
	Bitmap cap0(L"D:\\paipai\\captcha\\entrance\\f035d512-c5e9-44ac-b583-4125f49adda6.jpg");
	digit[0] = Cut(&cap0, 0);

	Graphics graphics(*GetDC());

	for (int i=0; i<10; i++)
	{
		graphics.DrawImage(digit[i], 10+(18)*i, 120);
	}

	UINT *sample[10];
	Rect rc(0, 0, 16, 19);
	BitmapData bmpData1;
	for (int i=0; i<10; i++)
	{
		Status st1 = digit[i]->LockBits(&rc, ImageLockModeRead, PixelFormat32bppARGB, &bmpData1);
		sample[i] = (UINT*)bmpData1.Scan0;
	}

	Bitmap capX(L"D:\\paipai\\ocr\\entrance\\1121\\3d8a6be5-7ebb-4e39-b830-67ca053138e3.jpg");
	int guess[6];
	Recognize(&capX, sample, guess);
	TRACE("Guess = %d %d %d %d %d %d\n", guess[0], guess[1], guess[2], guess[3], guess[4], guess[5]); 

	//CDialog::OnOK();
}

void CImgProcDlg::OnCancel()
{
	// TODO: Add your specialized code here and/or call the base class

	CDialog::OnCancel();
}
