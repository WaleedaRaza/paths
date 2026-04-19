/** LOD bands for mind-map rendering (see NOTES_UI_DEEP_WIRE_AND_AGENT_TASKS.md). */

export type LodBand = 'L3' | 'L2' | 'L1'

export type LodMode = 'auto' | 'galaxy' | 'neighborhood' | 'reading'

export function getLod(zoom: number, mode: LodMode): LodBand {
  if (mode === 'galaxy') return 'L3'
  if (mode === 'neighborhood') return 'L2'
  if (mode === 'reading') return 'L1'
  /** Slightly earlier L2/L3 so zoomed-out views use compact shells (billboard keeps them readable). */
  if (zoom < 0.42) return 'L3'
  if (zoom < 1) return 'L2'
  return 'L1'
}
