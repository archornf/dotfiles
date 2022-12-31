/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */

// https://tools.suckless.org/dmenu/patches/center/dmenu-center-5.2.diff
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int min_width = 500;                    /* minimum width when centered */

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"monospace:size=18",
	"NotoColorEmoji:pixelsize=16:antialias=true:autohint=true"
};
static const unsigned int bgalpha = 0xe0;
static const unsigned int fgalpha = OPAQUE;
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#ebdbb2", "#282828" },
	[SchemeSel] = { "#ebdbb2", "#98971a" },
	[SchemeOut] = { "#ebdbb2", "#8ec07c" },
};
static const unsigned int alphas[SchemeLast][2] = {
	/*		fgalpha		bgalphga	*/
	[SchemeNorm] = { fgalpha, bgalpha },
	[SchemeSel] = { fgalpha, bgalpha },
	[SchemeOut] = { fgalpha, bgalpha },
};

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

// https://tools.suckless.org/dmenu/patches/border/dmenu-border-4.9.diff
/* Size of the window border */
static const unsigned int border_width = 5;
