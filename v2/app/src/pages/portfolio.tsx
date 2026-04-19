import { PagePlaceholder } from '@/components/page-placeholder'

export function PortfolioPage() {
  return (
    <PagePlaceholder
      title="Portfolio"
      slice="Slice 5"
      blurb="Direct portfolio editing. Markdown-first, same 3-column shape as Notes — nav / editor / AI actions. PortfolioPiece nodes are first-class in the graph; link projects, tasks, and chats into writeups."
      surface={[
        'Pieces list (published / drafts / ideas)',
        'Live markdown preview',
        'Export to static site / JSON / Cursor context',
      ]}
    />
  )
}
