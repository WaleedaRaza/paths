import { PagePlaceholder } from '@/components/page-placeholder'

export function SocialsPage() {
  return (
    <PagePlaceholder
      title="Socials & Research"
      slice="Slice 5"
      blurb="Plug into your socials. Web-research agent goes out, reads, and writes notes back to the vault. Threads and research sessions are graph nodes — reference them from anywhere."
      surface={[
        'Connected accounts (Twitter/X, Bluesky, LinkedIn, Reddit, …)',
        'Feed / timeline view per account',
        'Research agent: new task → browsing log → note in vault',
      ]}
    />
  )
}
