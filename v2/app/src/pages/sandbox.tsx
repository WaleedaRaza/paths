import { PagePlaceholder } from '@/components/page-placeholder'

export function SandboxPage() {
  return (
    <PagePlaceholder
      title="Sandbox"
      slice="Slice 5"
      blurb='"Kobayashi Maru for code" — sit on top of your existing tools with presets. Not about building new tools. Save a preset (tool + args + model + prompt), run it, inspect, iterate.'
      surface={[
        'Preset list + run history',
        'Preset editor (tool, args, model, prompt)',
        'Run output + diff panel',
      ]}
    />
  )
}
