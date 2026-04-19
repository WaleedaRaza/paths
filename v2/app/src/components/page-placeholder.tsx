import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

interface Props {
  title: string
  slice: string
  blurb: string
  surface: string[]
}

export function PagePlaceholder({ title, slice, blurb, surface }: Props) {
  return (
    <div className="min-h-screen">
      <header className="border-b">
        <div className="max-w-3xl px-6 py-5">
          <div className="flex items-baseline gap-3">
            <h1 className="text-xl font-medium tracking-tight">{title}</h1>
            <span className="text-xs font-mono text-muted-foreground">{slice}</span>
          </div>
          <p className="text-sm text-muted-foreground mt-1">{blurb}</p>
        </div>
      </header>

      <main className="max-w-3xl px-6 py-6 space-y-6">
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Planned surface</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-1 text-sm text-muted-foreground list-disc pl-5">
              {surface.map((s) => (
                <li key={s}>{s}</li>
              ))}
            </ul>
          </CardContent>
        </Card>

        <p className="text-xs text-muted-foreground">
          Stub. Functional build lands in {slice}.
        </p>
      </main>
    </div>
  )
}
