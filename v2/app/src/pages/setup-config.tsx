import { useEffect, useState } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Separator } from '@/components/ui/separator'
import {
  getConfig,
  setConfig,
  pickVaultFolder,
  isTauri,
} from '@/lib/config-store'

const KEYS = {
  vaultPath: 'vault.path',
  defaultModel: 'models.default',
  ollamaUrl: 'models.ollamaUrl',
} as const

export function SetupConfigPage() {
  const [vaultPath, setVaultPath] = useState('')
  const [defaultModel, setDefaultModel] = useState('')
  const [ollamaUrl, setOllamaUrl] = useState('')
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    ;(async () => {
      setVaultPath((await getConfig<string>(KEYS.vaultPath)) ?? '')
      setDefaultModel((await getConfig<string>(KEYS.defaultModel)) ?? '')
      setOllamaUrl((await getConfig<string>(KEYS.ollamaUrl)) ?? '')
      setLoaded(true)
    })()
  }, [])

  return (
    <div className="min-h-screen bg-background text-foreground">
      <header className="border-b">
        <div className="mx-auto max-w-3xl px-6 py-5">
          <h1 className="text-xl font-medium tracking-tight">paths v2 · setup</h1>
          <p className="text-sm text-muted-foreground">
            Slice 0. Saves on blur. Running in {isTauri ? 'Tauri desktop' : 'browser (localStorage)'}.
          </p>
        </div>
      </header>

      <main className="mx-auto max-w-3xl px-6 py-6 space-y-6">
        <Section title="Vault" hint="Where your markdown lives. Point at iCloud / Syncthing / a git repo.">
          <div className="space-y-2">
            <Label htmlFor="vault-path">Vault path</Label>
            <div className="flex gap-2">
              <Input
                id="vault-path"
                placeholder="/home/waleed/paths-vault"
                value={vaultPath}
                disabled={!loaded}
                onChange={(e) => setVaultPath(e.target.value)}
                onBlur={() => setConfig(KEYS.vaultPath, vaultPath)}
              />
              <Button
                type="button"
                variant="secondary"
                onClick={async () => {
                  const picked = await pickVaultFolder()
                  if (picked) {
                    setVaultPath(picked)
                    await setConfig(KEYS.vaultPath, picked)
                  }
                }}
              >
                Pick…
              </Button>
            </div>
          </div>
        </Section>

        <Section title="Models" hint="Default model for new chats. Per-persona overrides come in Slice 3.">
          <Field label="Default model" id="default-model">
            <Input
              id="default-model"
              placeholder="claude-opus-4-7"
              value={defaultModel}
              disabled={!loaded}
              onChange={(e) => setDefaultModel(e.target.value)}
              onBlur={() => setConfig(KEYS.defaultModel, defaultModel)}
            />
          </Field>
          <Field label="Local Ollama endpoint" id="ollama-url">
            <Input
              id="ollama-url"
              placeholder="http://localhost:11434"
              value={ollamaUrl}
              disabled={!loaded}
              onChange={(e) => setOllamaUrl(e.target.value)}
              onBlur={() => setConfig(KEYS.ollamaUrl, ollamaUrl)}
            />
          </Field>
        </Section>

        <Section
          title="API keys"
          hint="Disabled here on purpose — proper OS-keychain wiring lands next. Don't paste keys into a plain store."
        >
          <Field label="Anthropic API key" id="anthropic-key">
            <Input id="anthropic-key" type="password" placeholder="sk-ant-…" disabled />
          </Field>
          <Field label="OpenAI API key" id="openai-key">
            <Input id="openai-key" type="password" placeholder="sk-…" disabled />
          </Field>
          <Field label="Google / Gemini API key" id="google-key">
            <Input id="google-key" type="password" placeholder="…" disabled />
          </Field>
        </Section>

        <Section title="Integrations" hint="MCPs, socials, GitHub. Populated in later slices.">
          <p className="text-sm text-muted-foreground">Empty for now.</p>
        </Section>

        <Separator />

        <p className="text-xs text-muted-foreground">
          Fields save on blur. No Save button is a choice — reduces ceremony.
        </p>
      </main>
    </div>
  )
}

function Section({
  title,
  hint,
  children,
}: {
  title: string
  hint?: string
  children: React.ReactNode
}) {
  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-base">{title}</CardTitle>
        {hint && <p className="text-sm text-muted-foreground">{hint}</p>}
      </CardHeader>
      <CardContent className="space-y-4">{children}</CardContent>
    </Card>
  )
}

function Field({
  label,
  id,
  children,
}: {
  label: string
  id: string
  children: React.ReactNode
}) {
  return (
    <div className="space-y-2">
      <Label htmlFor={id}>{label}</Label>
      {children}
    </div>
  )
}
