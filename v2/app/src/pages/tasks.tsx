import { PagePlaceholder } from '@/components/page-placeholder'

export function TasksPage() {
  return (
    <PagePlaceholder
      title="Tasks & Goals"
      slice="Slice 2"
      blurb="MGTST from v1 ported forward: Milestone → Goal → Task → Subtask + MustWin + Energy + point roll-up. Canvas timeline (drag-to-move, drag-handle-to-resize), not discrete hour slots."
      surface={[
        'Today tab: canvas timeline + must-wins + task pool',
        'Backlog tab: MGTST hierarchy with filters',
        'Graph view of dependencies',
      ]}
    />
  )
}
