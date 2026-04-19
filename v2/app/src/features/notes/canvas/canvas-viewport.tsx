import {
  forwardRef,
  useCallback,
  useEffect,
  useRef,
  useState,
  type ForwardedRef,
  type ReactNode,
} from 'react'
import type { useWorldTransform } from '@/features/notes/canvas/use-world-transform'

type WorldApi = ReturnType<typeof useWorldTransform>

function assignRef<T>(ref: ForwardedRef<T> | undefined, value: T | null) {
  if (!ref) return
  if (typeof ref === 'function') ref(value)
  else ref.current = value
}

interface Props {
  world: WorldApi
  /** When true, primary button drag pans (hand tool). Otherwise Space/middle-button pan only. */
  panPrimaryButton?: boolean
  children: ReactNode
}

export const CanvasViewport = forwardRef<HTMLDivElement, Props>(function CanvasViewport(
  { world, panPrimaryButton = false, children },
  forwardedRef,
) {
  const rootRef = useRef<HTMLDivElement>(null)
  const [spaceHeld, setSpaceHeld] = useState(false)
  const dragRef = useRef<{ pointerId: number; startX: number; startY: number; panX: number; panY: number } | null>(
    null,
  )

  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (e.code === 'Space' && !e.repeat) {
        setSpaceHeld(true)
      }
    }
    const up = (e: KeyboardEvent) => {
      if (e.code === 'Space') setSpaceHeld(false)
    }
    window.addEventListener('keydown', down)
    window.addEventListener('keyup', up)
    return () => {
      window.removeEventListener('keydown', down)
      window.removeEventListener('keyup', up)
    }
  }, [])

  const onWheel = useCallback(
    (e: React.WheelEvent) => {
      const el = rootRef.current
      if (!el) return
      e.preventDefault()
      const rect = el.getBoundingClientRect()
      world.zoomByWheel(e.clientX, e.clientY, rect, e.deltaY)
    },
    [world],
  )

  const onPointerDown = useCallback(
    (e: React.PointerEvent) => {
      const pan = spaceHeld || e.button === 1 || (panPrimaryButton && e.button === 0)
      if (!pan) return
      e.preventDefault()
      dragRef.current = {
        pointerId: e.pointerId,
        startX: e.clientX,
        startY: e.clientY,
        panX: world.pan.x,
        panY: world.pan.y,
      }
      e.currentTarget.setPointerCapture(e.pointerId)
    },
    [spaceHeld, panPrimaryButton, world.pan.x, world.pan.y],
  )

  const onPointerMove = useCallback(
    (e: React.PointerEvent) => {
      const d = dragRef.current
      if (!d || e.pointerId !== d.pointerId) return
      const dx = e.clientX - d.startX
      const dy = e.clientY - d.startY
      world.setPan({ x: d.panX + dx, y: d.panY + dy })
    },
    [world],
  )

  const onPointerUp = useCallback((e: React.PointerEvent) => {
    const d = dragRef.current
    if (d && e.pointerId === d.pointerId) {
      dragRef.current = null
      try {
        e.currentTarget.releasePointerCapture(e.pointerId)
      } catch {
        /* already released */
      }
    }
  }, [])

  const setRefs = useCallback(
    (el: HTMLDivElement | null) => {
      rootRef.current = el
      assignRef(forwardedRef, el)
    },
    [forwardedRef],
  )

  return (
    <div
      ref={setRefs}
      className={
        'relative flex-1 min-h-0 min-w-0 overflow-hidden bg-muted/30 ' +
        (spaceHeld || panPrimaryButton ? 'cursor-grab active:cursor-grabbing' : '')
      }
      onWheel={onWheel}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onPointerCancel={onPointerUp}
    >
      <div
        className="absolute inset-0 origin-top-left will-change-transform"
        style={{
          transform: `translate(${world.pan.x}px, ${world.pan.y}px) scale(${world.zoom})`,
        }}
      >
        <div
          className="absolute inset-0 opacity-40 pointer-events-none"
          style={{
            backgroundImage: `
              linear-gradient(to right, hsl(var(--border)) 1px, transparent 1px),
              linear-gradient(to bottom, hsl(var(--border)) 1px, transparent 1px)
            `,
            backgroundSize: '24px 24px',
            width: '400%',
            height: '400%',
            left: '-100%',
            top: '-100%',
          }}
        />
        {children}
      </div>
    </div>
  )
})
