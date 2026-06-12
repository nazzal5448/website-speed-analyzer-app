---
name: Performance Intelligence System
colors:
  surface: '#141218'
  surface-dim: '#141218'
  surface-bright: '#3b383e'
  surface-container-lowest: '#0f0d13'
  surface-container-low: '#1d1b20'
  surface-container: '#211f24'
  surface-container-high: '#2b292f'
  surface-container-highest: '#36343a'
  on-surface: '#e6e0e9'
  on-surface-variant: '#cbc4d2'
  inverse-surface: '#e6e0e9'
  inverse-on-surface: '#322f35'
  outline: '#948e9c'
  outline-variant: '#494551'
  surface-tint: '#cfbcff'
  primary: '#cfbcff'
  on-primary: '#381e72'
  primary-container: '#6750a4'
  on-primary-container: '#e0d2ff'
  inverse-primary: '#6750a4'
  secondary: '#cdc0e9'
  on-secondary: '#342b4b'
  secondary-container: '#4d4465'
  on-secondary-container: '#bfb2da'
  tertiary: '#e7c365'
  on-tertiary: '#3e2e00'
  tertiary-container: '#c9a74d'
  on-tertiary-container: '#503d00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e9ddff'
  primary-fixed-dim: '#cfbcff'
  on-primary-fixed: '#22005d'
  on-primary-fixed-variant: '#4f378a'
  secondary-fixed: '#e9ddff'
  secondary-fixed-dim: '#cdc0e9'
  on-secondary-fixed: '#1f1635'
  on-secondary-fixed-variant: '#4b4263'
  tertiary-fixed: '#ffdf93'
  tertiary-fixed-dim: '#e7c365'
  on-tertiary-fixed: '#241a00'
  on-tertiary-fixed-variant: '#594400'
  background: '#141218'
  on-background: '#e6e0e9'
  surface-variant: '#36343a'
typography:
  display-xl:
    fontFamily: Geist
    fontSize: 64px
    fontWeight: '700'
    lineHeight: 72px
    letterSpacing: -0.04em
  display-xl-mobile:
    fontFamily: Geist
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-mono:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-max: 1280px
  gutter: 24px
  margin-desktop: 40px
  margin-mobile: 20px
  stack-xs: 4px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
  stack-xl: 64px
---

## Brand & Style

The design system is engineered for high-performance data visualization and technical analysis. It targets developers and site reliability engineers who require precision and clarity. The aesthetic merges **Minimalism** with **Glassmorphism**, creating a high-end "command center" feel.

The emotional response should be one of "calm authority"—the interface stays out of the way until a metric requires attention. Visual cues are inspired by aerospace HUDs and modern developer tools like Vercel and Linear, emphasizing depth through translucency, thin 1px borders, and localized luminescence (glows) rather than traditional drop shadows.

## Colors

This design system utilizes a "Void Black" foundation to maximize contrast with neon accents. 

- **Foundation:** Pure black (#000000) for the base canvas to save energy on OLED displays and provide infinite depth.
- **Surfaces:** Dark Gray (#121212) is used for cards and navigation bars, often with a 70% opacity and 20px background blur to create the glass effect.
- **Accents:** A gradient transition between Neon Blue (#00D1FF) and Cyan (#00FFF0) represents active states and primary actions.
- **Semantics:** Performance indicators are strictly mapped to Green (Optimal), Yellow (Needs Improvement), and Red (Poor). These should include a 10px-20px "soft glow" shadow of the same color when representing critical alerts.

## Typography

The typography hierarchy emphasizes readability and technical precision.

- **Headlines:** Use **Geist** for its sharp, geometric terminals and modern technical feel. Large displays use tight letter-spacing for a sophisticated, editorial look.
- **Body:** Use **Inter** for all functional text to ensure maximum legibility across different resolutions.
- **Data/Labels:** Use **JetBrains Mono** for numerical values, latency metrics, and code snippets to reinforce the "developer tool" identity.

All text should default to a high-silver gray (rgba(255, 255, 255, 0.9)) rather than pure white to reduce eye strain against the black background.

## Layout & Spacing

This design system uses a **Fixed Grid** approach for the core dashboard content, centered within the viewport.

- **Grid:** A 12-column grid system with 24px gutters. Content should typically span 3, 4, 6, or 12 columns.
- **Rhythm:** An 8px base unit drives all padding and margin decisions. 
- **Adaptation:** On mobile, the 12-column grid collapses to a single column with 20px side margins. Large data tables reflow into card-based layouts. 
- **Whitespace:** Generous vertical stacking (stack-xl) is encouraged between major sections to maintain a premium, airy feel.

## Elevation & Depth

Depth is communicated through **translucency** and **layering** rather than heavy shadows.

1.  **Level 0 (Base):** Pure Black (#000000).
2.  **Level 1 (Surfaces):** Dark Gray (#121212) with a 1px solid border of rgba(255, 255, 255, 0.08).
3.  **Level 2 (Overlays/Modals):** Glassmorphic surfaces with `backdrop-filter: blur(20px)` and a slightly brighter border (rgba(255, 255, 255, 0.15)).
4.  **Luminescence:** Use "Inner Glow" for buttons and "Outer Glow" (box-shadow: 0 0 20px) for active performance indicators. This mimics light emitting from the screen rather than light falling on a physical object.

## Shapes

The shape language is consistently **Rounded**, creating a soft juxtaposition to the cold, dark color palette.

- **Small Components:** Checkboxes and small tags use 4px (rounded-sm) to maintain precision.
- **Standard Components:** Buttons, Input fields, and List items use 8px (rounded-md).
- **Containers:** Dashboard cards and modal overlays use 16px (rounded-lg) or 24px (rounded-xl) for a friendlier, modern SaaS silhouette.
- **Buttons:** Primary CTAs may use pill-shaping (32px+) when used for "Start Test" or "Analyze" actions to draw attention.

## Components

- **Buttons:** Primary buttons use a linear gradient from Neon Blue to Cyan. Hover states should increase the brightness and add a subtle 15px glow of the same color. Secondary buttons use the 1px border style with a transparent background.
- **Inputs:** Dark Gray (#121212) backgrounds with 1px borders. On focus, the border transitions to Cyan with a subtle inner shadow.
- **Cards:** Must utilize the glassmorphism effect. Borders should be 1px wide, using a linear gradient (top-left to bottom-right) from `rgba(255,255,255,0.1)` to `rgba(255,255,255,0.02)`.
- **Performance Rings:** Circular charts used for PageSpeed scores. Use thick stroke widths (10px+) with rounded caps. The unfilled portion of the ring should be a dark semi-transparent gray.
- **Chips/Status:** Small, high-contrast pills. For performance metrics, the text color should match the indicator color for instant recognition.
- **Data Tables:** Minimalist style. No vertical lines; only subtle horizontal dividers (rgba(255,255,255,0.05)). Header rows should use the Monospace label font.