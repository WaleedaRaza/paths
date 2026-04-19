import { useCallback, useState } from 'react'

/** Allow zooming far out; nodes use billboarding so they stay visible on screen. */
const ZOOM_MIN = 0.04
const ZOOM_MAX = 4

function clampZoom(z: number): number {
  return Math.min(ZOOM_MAX, Math.max(ZOOM_MIN, z))
}

export interface Pan {
  x: number
  y: number
}

export function useWorldTransform(initialPan: Pan = { x: 48, y: 48 }, initialZoom = 1) {
  const [pan, setPan] = useState<Pan>(initialPan)
  const [zoom, setZoom] = useState(initialZoom)

  const screenToWorld = useCallback(
    (clientX: number, clientY: number, rect: DOMRect) => {
      const sx = clientX - rect.left
      const sy = clientY - rect.top
      return {
        x: (sx - pan.x) / zoom,
        y: (sy - pan.y) / zoom,
      }
    },
    [pan.x, pan.y, zoom],
  )

  const worldToScreen = useCallback(
    (wx: number, wy: number, rect: DOMRect) => {
      return {
        x: rect.left + pan.x + wx * zoom,
        y: rect.top + pan.y + wy * zoom,
      }
    },
    [pan.x, pan.y, zoom],
  )

  const zoomByWheel = useCallback((clientX: number, clientY: number, rect: DOMRect, deltaY: number) => {
    const sx = clientX - rect.left
    const sy = clientY - rect.top
    const worldX = (sx - pan.x) / zoom
    const worldY = (sy - pan.y) / zoom
    const factor = Math.exp(-deltaY * 0.002)
    const nz = clampZoom(zoom * factor)
    setZoom(nz)
    setPan({
      x: sx - worldX * nz,
      y: sy - worldY * nz,
    })
  }, [pan.x, pan.y, zoom])

  const fitZoom = useCallback((factor: number) => {
    setZoom((z) => clampZoom(z * factor))
  }, [])

  /** Pan/zoom so the world-space rectangle (wx, wy, w × h) fits inside `rect` with padding. */
  const focusWorldRect = useCallback(
    (rect: DOMRect, wx: number, wy: number, w: number, h: number, padding = 56) => {
      const vw = rect.width
      const vh = rect.height
      const bw = Math.max(w, 1)
      const bh = Math.max(h, 1)
      const zx = (vw - padding * 2) / bw
      const zy = (vh - padding * 2) / bh
      const nz = clampZoom(Math.min(zx, zy, 1.35))
      const cx = wx + bw / 2
      const cy = wy + bh / 2
      setZoom(nz)
      setPan({
        x: vw / 2 - cx * nz,
        y: vh / 2 - cy * nz,
      })
    },
    [],
  )

  return {
    pan,
    setPan,
    zoom,
    setZoom,
    clampZoom,
    screenToWorld,
    worldToScreen,
    zoomByWheel,
    fitZoom,
    focusWorldRect,
  }
}
