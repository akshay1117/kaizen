---
name: Kinetic Performance
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1b1b1b'
  surface-container: '#1f1f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#bccbb8'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#303030'
  outline: '#869584'
  outline-variant: '#3d4a3c'
  surface-tint: '#53e16f'
  primary: '#56e472'
  on-primary: '#003911'
  primary-container: '#34c759'
  on-primary-container: '#004d1a'
  inverse-primary: '#006e28'
  secondary: '#c8c6c8'
  on-secondary: '#303032'
  secondary-container: '#474649'
  on-secondary-container: '#b6b4b7'
  tertiary: '#cbc8cb'
  on-tertiary: '#303032'
  tertiary-container: '#afadaf'
  on-tertiary-container: '#414143'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#72fe88'
  primary-fixed-dim: '#53e16f'
  on-primary-fixed: '#002107'
  on-primary-fixed-variant: '#00531c'
  secondary-fixed: '#e4e2e4'
  secondary-fixed-dim: '#c8c6c8'
  on-secondary-fixed: '#1b1b1d'
  on-secondary-fixed-variant: '#474649'
  tertiary-fixed: '#e4e2e4'
  tertiary-fixed-dim: '#c8c6c8'
  on-tertiary-fixed: '#1b1b1d'
  on-tertiary-fixed-variant: '#474649'
  background: '#131313'
  on-background: '#e2e2e2'
  surface-variant: '#353535'
typography:
  display-metrics:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  container-padding: 16px
  card-gap: 12px
---

## Brand & Style

The design system is engineered for high-performance athletes and dedicated fitness enthusiasts. It embodies a **Professional/Modern** aesthetic with a heavy lean into **Minimalism** to ensure zero distractions during intense training sessions. 

The emotional goal is "Focused Intensity." By utilizing a true black canvas, we eliminate visual noise and allow the metrics and action items to stand out with high-contrast urgency. The style leverages deep tonal layering to provide structure without the need for light-colored dividers, maintaining a stealth-like, premium environment. 

Key pillars:
- **Athletic Precision:** Every element feels calibrated and purposeful.
- **Stealth Performance:** Dark, immersive interfaces that reduce eye strain in gym lighting.
- **Immediate Action:** The "Vibrant Success Green" acts as a beacon for progress and completion.

## Colors

This design system utilizes a "Pure Dark" palette to maximize OLED efficiency and visual focus.

- **Background (Base):** `#000000` is the absolute foundation for all main views.
- **Surface (Primary):** `#1C1C1E` is used for primary cards, list containers, and the bottom navigation bar.
- **Surface (Secondary):** `#2C2C2E` is used for nested elements, active input fields, and modals.
- **Accent:** `#34C759` (Vibrant Success Green) is reserved exclusively for "Success" states, Primary CTAs, active toggles, and completed set indicators.
- **Typography:** Pure white (`#FFFFFF`) for primary headers and data. Secondary text (`#8E8E93`) is used for labels and descriptions to maintain hierarchy.

## Typography

The typography uses **Hanken Grotesk** to emulate the clean, functional feel of SF Pro while offering a slightly more technical edge. 

- **Weight Strategy:** Use `800` (ExtraBold) for primary metrics (e.g., weight lifted, time remaining). Use `700` (Bold) for page titles.
- **Hierarchy:** Maintain a clear distinction between data and labels. Labels should often use the `label-caps` style in secondary text colors.
- **Readability:** On dark backgrounds, ensure `body-lg` is used for any instructional text to prevent "haloing" or blurring of tight characters.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for mobile-first interaction. 

- **Safe Margins:** A standard `16px` (md) horizontal margin is maintained across all views.
- **Vertical Rhythm:** Elements are grouped in cards with `12px` (sm) internal spacing.
- **Touch Targets:** All interactive elements (list rows, buttons, tabs) must maintain a minimum height of `44px` to ensure accessibility during movement.
- **Bottom Navigation:** The fixed 4-tab bar uses an elevated surface (`#1C1C1E`) with a subtle top border or backdrop blur to separate it from the scrolling content.

## Elevation & Depth

In a pure black environment, traditional shadows are ineffective. Instead, this design system uses **Tonal Layers** and **Low-Contrast Outlines**:

- **Level 0 (Base):** `#000000` — The canvas.
- **Level 1 (Surface):** `#1C1C1E` — Primary cards and navigation bars.
- **Level 2 (Interaction):** `#2C2C2E` — Hover states or secondary modals.
- **Stroke:** For added definition on Level 1 elements, use a 1px solid border of `#2C2C2E`. This creates a "hairline" edge that defines the shape without breaking the dark aesthetic.
- **Modals:** Use a heavy backdrop dim (70% opacity black) to push the background further away.

## Shapes

The shape language is consistently **Rounded**.

- **Cards & Modals:** Use `16px` (rounded-xl) for large containers to create a friendly but modern feel.
- **Buttons & Inputs:** Use `12px` (rounded-lg) for action-oriented components.
- **Selection Indicators:** Use pill-shapes (fully rounded) for tab indicators and chips to provide a distinct contrast against the rectangular grid.

## Components

### Buttons
- **Primary:** Background `#34C759`, Text `#FFFFFF` (Bold). High-visibility for "Start Workout" or "Finish Set."
- **Secondary:** Background `#1C1C1E`, Border `1px solid #2C2C2E`, Text `#FFFFFF`.

### List Rows
- Standardized height of `56px`. 
- Leading icons should be encased in a `32px` rounded square of `#2C2C2E`.
- Trailing elements (arrows or values) use the `text-secondary` color.

### Custom Number Pad
- Designed for rapid data entry. 
- Large, clear digits on a `#1C1C1E` background.
- "Confirm" or "Next" key highlighted in the Primary Green.
- Tactile feedback (simulated via high-contrast active states) when a key is pressed.

### Cards
- Container for workout templates.
- Internal padding of `16px`.
- Title in `headline-md`, subtext in `body-sm`.

### Bottom Navigation
- 4-tab layout: **Sets**, **Sessions**, **Body**, **Today**.
- Active state: Icon and Label tinted to Primary Green.
- Inactive state: Icon and Label in `text-secondary`.