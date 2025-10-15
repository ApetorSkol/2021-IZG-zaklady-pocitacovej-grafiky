/******************************************************************************
 * Laborator 01 - Zaklady pocitacove grafiky - IZG
 * ihulik@fit.vutbr.cz
 *
 * $Id: $
 * 
 * Popis: Hlavicky funkci pro funkce studentu
 *
 * Opravy a modifikace:
 * - ibobak@fit.vutbr.cz, orderedDithering
 */

#include "student.h"
#include "globals.h"

#include <time.h>

const int M[] = {
    0, 204, 51, 255,
    68, 136, 187, 119,
    34, 238, 17, 221,
    170, 102, 153, 85
};

const int M_SIDE = 4;

/******************************************************************************
 ******************************************************************************
 Funkce vraci pixel z pozice x, y. Je nutne hlidat frame_bufferu, pokud 
 je dana souradnice mimo hranice, funkce vraci barvu (0, 0, 0).
 Ukol za 0.25 bodu */
S_RGBA getPixel(int x, int y)
{
	if (x<1 || x>width)
	{
		printf("Pixel neexistuje \n");
		return COLOR_BLACK;
	}
	if (y<1 || y>height)
	{
		printf("Pixel neexistuje \n");
		return COLOR_BLACK;
	}
	int offset = x + y*width;
	S_RGBA color;
	color = frame_buffer[offset];
    return color;
}
/******************************************************************************
 ******************************************************************************
 Funkce vlozi pixel na pozici x, y. Je nutne hlidat frame_bufferu, pokud 
 je dana souradnice mimo hranice, funkce neprovadi zadnou zmenu.
 Ukol za 0.25 bodu */
void putPixel(int x, int y, S_RGBA color)
{
	if (x<0 || x>width)
	{
		printf("Pixel neexistuje \n");
		return;
	}
	if (y<0 || y>height)
	{
		printf("Pixel neexistuje \n");
		return;
	}
	int offset = x + y*width;
	frame_buffer[offset] = color;
}
/******************************************************************************
 ******************************************************************************
 Funkce prevadi obrazek na odstiny sedi. Vyuziva funkce GetPixel a PutPixel.
 Ukol za 0.5 bodu */
void grayScale()
{
	int intensity;
	S_RGBA pixel;
	int x, y;
	for (int i = 0; i < width*height; i++)
	{
		y = i%width;
		x = i - y*width;
		pixel = getPixel(x, y);
		intensity = (pixel.red)*0.299 + pixel.green*0.587 + pixel.blue*0.114;
		ROUND(intensity);
		pixel.red = intensity;
		pixel.blue = intensity;
		pixel.green = intensity;
		putPixel(x,y,pixel);
	}
}

/******************************************************************************
 ******************************************************************************
 Funkce prevadi obrazek na cernobily pomoci algoritmu maticoveho rozptyleni.
 Ukol za 1 bod */

void orderedDithering()
{
	int intensity;
	int mat_x,mat_y;
	S_RGBA pixel;
	int x, y;
	for (int i = 0; i < width*height; i++)
	{
		y = i%width;
		x = i - y*width;
		pixel = getPixel(x, y);
		intensity = (pixel.red)*0.299 + pixel.green*0.587 + pixel.blue*0.114;
		ROUND(intensity);
		mat_x = (x%M_SIDE);
		mat_y = (y%M_SIDE);
		if (intensity>M[x + y*M_SIDE])
		{
			pixel = COLOR_WHITE;
		}
		else
		{
			pixel = COLOR_BLACK;
		}
		putPixel(x, y, pixel);
	}
}

/******************************************************************************
 ******************************************************************************
 Funkce prevadi obrazek na cernobily pomoci algoritmu distribuce chyby.
 Ukol za 1 bod */
void errorDistribution()
{   

	int intensity;
	S_RGBA pixel;
	int x, y,error;
	error = 0;
	for (int i = 0; i < width*height; i++)
	{
		y = i%width;
		x = i - y*width;
		pixel = getPixel(x, y);
		intensity = (pixel.red)*0.299 + pixel.green*0.587 + pixel.blue*0.114;
		ROUND(intensity);
		if ((intensity + error)>128)
		{
			pixel = COLOR_WHITE;
		}
		else
		{
			pixel = COLOR_BLACK;
		}
		error = intensity - 128;
		putPixel(x, y, pixel);
	}
}

/******************************************************************************
 ******************************************************************************
 Funkce prevadi obrazek na cernobily pomoci metody prahovani.
 Demonstracni funkce */
void thresholding(int Threshold)
{
	/* Prevedeme obrazek na grayscale */
	grayScale();

	/* Projdeme vsechny pixely obrazku */
	for (int y = 0; y < height; ++y)
		for (int x = 0; x < width; ++x)
		{
			/* Nacteme soucasnou barvu */
			S_RGBA color = getPixel(x, y);

			/* Porovname hodnotu cervene barevne slozky s prahem.
			   Muzeme vyuzit jakoukoli slozku (R, G, B), protoze
			   obrazek je sedotonovy, takze R=G=B */
			if (color.red > Threshold)
				putPixel(x, y, COLOR_WHITE);
			else
				putPixel(x, y, COLOR_BLACK);
		}
}

/******************************************************************************
 ******************************************************************************
 Funkce prevadi obrazek na cernobily pomoci nahodneho rozptyleni. 
 Vyuziva funkce GetPixel, PutPixel a GrayScale.
 Demonstracni funkce. */
void randomDithering()
{
	/* Prevedeme obrazek na grayscale */
	grayScale();

	/* Inicializace generatoru pseudonahodnych cisel */
	srand((unsigned int)time(NULL));

	/* Projdeme vsechny pixely obrazku */
	for (int y = 0; y < height; ++y)
		for (int x = 0; x < width; ++x)
		{
			/* Nacteme soucasnou barvu */
			S_RGBA color = getPixel(x, y);
			
			/* Porovname hodnotu cervene barevne slozky s nahodnym prahem.
			   Muzeme vyuzit jakoukoli slozku (R, G, B), protoze
			   obrazek je sedotonovy, takze R=G=B */
			if (color.red > rand()%255)
			{
				putPixel(x, y, COLOR_WHITE);
			}
			else
				putPixel(x, y, COLOR_BLACK);
		}
}
/*****************************************************************************/
/*****************************************************************************/