# NEXUS GATEWAY — Auth Portal

Sito futuristico con login e registrazione collegato a un database **PostgreSQL reale** tramite [Supabase](https://supabase.com), hostato gratuitamente su **GitHub Pages**.

---

## ⚡ Stack

| Layer | Tecnologia |
|-------|-----------|
| Frontend | HTML + CSS + JavaScript (vanilla) |
| Database | PostgreSQL (via Supabase) |
| Auth | Supabase Auth (JWT + bcrypt) |
| Sicurezza | Row Level Security (RLS) |
| Hosting | GitHub Pages (gratis) |

---

## 🚀 Setup in 4 passi

### 1. Crea il database su Supabase (gratis)

1. Vai su [supabase.com](https://supabase.com) → **Start your project** → accedi con GitHub
2. Clicca **New Project**, dai un nome (es. `nexus-auth`), scegli una password, seleziona la region più vicina (Frankfurt o West EU)
3. Aspetta ~2 minuti che il progetto si avvii

### 2. Crea la tabella (copia-incolla SQL)

1. Nel tuo progetto Supabase → **SQL Editor** → **New query**
2. Copia tutto il contenuto di `schema.sql` e incollalo
3. Clicca **Run** (▶)
4. Dovresti vedere: `Success. No rows returned`

### 3. Configura le chiavi API

1. In Supabase → **Project Settings** (icona ingranaggio) → **API**
2. Copia:
   - **Project URL** (es. `https://xyzabcdef.supabase.co`)
   - **anon public** key (quella lunga — è sicura da esporre nel frontend)
3. Apri `config.js` e sostituisci i placeholder:

```js
const NEXUS_CONFIG = {
  supabaseUrl:     'https://xyzabcdef.supabase.co',   // ← la tua URL
  supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI...',  // ← la tua anon key
};
```

### 4. Pubblica su GitHub Pages

```bash
# Clona o crea il repo
git init
git add .
git commit -m "feat: nexus auth portal"

# Crea il repo su github.com, poi:
git remote add origin https://github.com/TUO_USERNAME/nexus-auth.git
git branch -M main
git push -u origin main
```

Poi su GitHub:
- **Settings** → **Pages** → Source: `Deploy from a branch`
- Branch: `main` → Folder: `/ (root)` → **Save**

In ~1 minuto il sito sarà live su:
```
https://TUO_USERNAME.github.io/nexus-auth
```

---

## 📁 Struttura file

```
nexus-auth/
├── index.html     ← Il sito (design + logica)
├── config.js      ← Le tue chiavi Supabase (da compilare)
├── schema.sql     ← SQL da eseguire su Supabase (una volta sola)
└── README.md      ← Questa guida
```

---

## 🔒 Sicurezza

- **Password**: gestita da Supabase Auth con **bcrypt** (mai visibile in chiaro)
- **JWT**: ogni sessione usa un token firmato con scadenza automatica
- **Row Level Security**: ogni utente può leggere/modificare SOLO i propri dati
- **anon key**: è sicura da esporre — può solo leggere dati pubblici e fare auth. La `service_role` key (quella "pericolosa") non va mai nel frontend
- **Conferma email**: Supabase invia un'email di verifica prima di attivare l'account

---

## ⚙️ Configurazione Supabase Auth (opzionale)

Per disabilitare la conferma email (utile per testing):
- Supabase → **Authentication** → **Providers** → **Email**
- Disabilita **Confirm email**

Per personalizzare l'email di conferma:
- Supabase → **Authentication** → **Email Templates**

---

## 🆓 Limiti piano gratuito Supabase

| Feature | Limite gratuito |
|---------|----------------|
| Database | 500 MB |
| Auth utenti | Illimitato |
| Richieste API | 500k/mese |
| Progetti | 2 attivi |

Più che sufficiente per un progetto personale.

---

## 🐛 Troubleshooting

**Il sito mostra "NON CONFIGURATO"**
→ Controlla di aver compilato `config.js` con le chiavi reali

**"Email not confirmed" al login**
→ Controlla la tua email e clicca il link, oppure disabilita la conferma email in Supabase

**"duplicate key value" al profilo**
→ Il trigger `on_auth_user_created` funziona correttamente, il profilo esiste già

**Il sito non si aggiorna su GitHub Pages**
→ Aspetta 1-2 minuti, poi forza il refresh con `Ctrl+Shift+R`