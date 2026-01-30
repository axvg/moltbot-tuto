# Moltbot + Telegram on DigitalOcean

Deploy your own AI assistant with Telegram integration on DigitalOcean.

## Prerequisites

- DigitalOcean account
- Telegram account (for BotFather)
- AI API key (OpenAI, Gemini, or Anthropic)

---

## Step 1: Create Telegram Bot

1. Open Telegram and search for **@BotFather**
2. Start chat and send `/newbot`
3. Name your bot and choose a username (must end in `bot`)
4. **Save the API token** BotFather gives you

---

## Step 2: Deploy on DigitalOcean (1-Click Method)

### Option A: Marketplace 1-Click App (Recommended)

1. Go to [DigitalOcean Marketplace > Moltbot](https://marketplace.digitalocean.com/apps/moltbot)
2. Click **"Create Moltbot Droplet"**
3. Choose a plan:
   - **Basic** ($6-12/month): Good for testing
   - **General Purpose** ($18+/month): Better performance
4. Select a datacenter region near you
5. Choose authentication (SSH key recommended)
6. Click **Create Droplet**
7. Wait 2-3 minutes for deployment

### Option B: Manual Docker Deployment

```bash
# Create a new Droplet with Docker image
# SSH into your droplet
ssh root@YOUR_DROPLET_IP

# Install Docker (if not pre-installed)
curl -fsSL https://get.docker.com | sh

# Run Moltbot container
docker run -d \
  --name moltbot \
  -p 3000:3000 \
  -e TELEGRAM_BOT_TOKEN=YOUR_TELEGRAM_TOKEN \
  -e OPENAI_API_KEY=YOUR_OPENAI_KEY \
  -v moltbot-data:/app/data \
  moltbot/moltbot:latest
```

---

## Step 3: Configure Moltbot

### SSH into your Droplet

```bash
ssh root@YOUR_DROPLET_IP
```

### Edit Configuration

```bash
# Edit config file
nano /etc/moltbot/config.yaml
```

**Required settings:**

```yaml
# Telegram Configuration
telegram:
  enabled: true
  bot_token: "YOUR_TELEGRAM_BOT_TOKEN"
  allowed_users: []  # Leave empty to allow all, or add Telegram user IDs

# AI Provider (choose one)
ai:
  provider: openai  # or 'gemini' or 'anthropic'
  api_key: "YOUR_AI_API_KEY"
  model: "gpt-4"    # or 'gemini-1.5-pro' or 'claude-3-opus'

# Gateway (optional - for web interface)
gateway:
  enabled: true
  port: 3000
```

### Restart Moltbot

```bash
# If using systemd
systemctl restart moltbot

# If using Docker
docker restart moltbot

# Check logs
journalctl -u moltbot -f
# OR for Docker
docker logs -f moltbot
```

---

## Step 4: Connect to Telegram

1. Open Telegram
2. Find your bot by username (from Step 1)
3. Start chatting with `/start`
4. Your AI assistant is now live!

---

## Step 5: Security Best Practices

### Enable Firewall

```bash
# Allow only necessary ports
ufw allow 22/tcp    # SSH
ufw allow 443/tcp   # HTTPS (if using web interface)
ufw enable
```

### Set Up Environment Variables

Instead of hardcoding secrets in config:

```bash
# Create .env file
nano /etc/moltbot/.env
```

```env
TELEGRAM_BOT_TOKEN=your_token_here
OPENAI_API_KEY=your_key_here
```

```bash
# Load env vars in service
systemctl edit moltbot --full
# Add: EnvironmentFile=/etc/moltbot/.env
```

### Restrict Telegram Access

Edit config to only allow specific users:

```yaml
telegram:
  allowed_users:
    - 123456789  # Your Telegram user ID
    - 987654321  # Friend's user ID
```

To find your Telegram user ID: message `@userinfobot`

---

## Step 6: Upgrade & Maintenance

### Update Moltbot

```bash
# For Docker deployment
docker pull moltbot/moltbot:latest
docker stop moltbot
docker rm moltbot
# Re-run docker run command from Step 2

# For 1-Click deployment
apt update && apt upgrade -y
systemctl restart moltbot
```

### Backup Configuration

```bash
# Backup data
tar -czf moltbot-backup-$(date +%Y%m%d).tar.gz /etc/moltbot/ /var/lib/moltbot/

# Download to local machine
scp root@YOUR_DROPLET_IP:~/moltbot-backup-*.tar.gz .
```

---

## Troubleshooting

### Bot not responding

```bash
# Check if running
systemctl status moltbot

# Check logs
journalctl -u moltbot -n 50

# Test Telegram token
curl -s "https://api.telegram.org/botYOUR_TOKEN/getMe"
```

### AI not responding

- Verify API key is valid
- Check AI provider status page
- Review rate limits

### Connection issues

```bash
# Check network
ping api.telegram.org
ping api.openai.com

# Restart networking
systemctl restart systemd-networkd
```

---

## Useful Commands

```bash
# View real-time logs
journalctl -u moltbot -f

# Restart service
systemctl restart moltbot

# Check disk space
df -h

# Monitor resources
htop

# Update packages
apt update && apt upgrade -y
```

---

## Additional Features

### Enable WhatsApp (Optional)

```yaml
whatsapp:
  enabled: true
  session_name: "moltbot-session"
```

### Enable Discord (Optional)

```yaml
discord:
  enabled: true
  bot_token: "YOUR_DISCORD_BOT_TOKEN"
```

### Enable Slack (Optional)

```yaml
slack:
  enabled: true
  bot_token: "YOUR_SLACK_BOT_TOKEN"
  signing_secret: "YOUR_SLACK_SIGNING_SECRET"
```

---

## Step 7: MCP Server Setup (Advanced Capabilities)

MCP (Model Context Protocol) servers give Moltbot "hands" to interact with browsers, code editors, files, and thousands of tools.

### What You Can Do with MCP:
- **Browse the web** with Firefox/Chrome automation
- **Write & execute code** in any language
- **Control your server** via terminal commands
- **Access 8000+ apps** via Zapier MCP
- **Read/write files** on your DigitalOcean droplet

---

### Install Browser MCP (Firefox/Chrome Automation)

```bash
# SSH into your droplet
ssh root@YOUR_DROPLET_IP

# Install Node.js 18+ if not present
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install Playwright MCP Server globally
npm install -g @executeautomation/playwright-mcp-server

# Install browsers (Chromium, Firefox, WebKit)
npx playwright install

# Install Firefox specifically
npx playwright install firefox
```

### Configure Moltbot to Use MCP Servers

Edit the MCP configuration:

```bash
nano /etc/moltbot/mcp.json
```

Add browser automation:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@executeautomation/playwright-mcp-server"],
      "env": {
        "DISPLAY": ":1"
      }
    },
    "firefox": {
      "command": "node",
      "args": ["/path/to/firefox-mcp-server/index.js"],
      "env": {
        "DISPLAY": ":1"
      }
    }
  }
}
```

### Install Additional MCP Servers

**Terminal/Shell MCP:**
```bash
# For direct terminal access
npm install -g @modelcontextprotocol/server-terminal
```

**File System MCP:**
```bash
npm install -g @modelcontextprotocol/server-filesystem
```

**GitHub MCP:**
```bash
npm install -g @modelcontextprotocol/server-github
```

**Zapier MCP (8000+ apps):**
1. Go to [Zapier MCP](https://zapier.com/mcp)
2. Create an account and generate MCP credentials
3. Add to your `mcp.json`:

```json
{
  "mcpServers": {
    "zapier": {
      "command": "npx",
      "args": ["-y", "@zapier/mcp"],
      "env": {
        "ZAPIER_MCP_TOKEN": "your_zapier_token_here"
      }
    }
  }
}
```

---

### Example Telegram Commands with MCP

Once MCP is configured, you can send these commands via Telegram:

**Web Research & Browsing:**
```
Research the latest Python web frameworks and create a comparison table
```

**Code Generation & Execution:**
```
Create a Python script that fetches Bitcoin price from CoinGecko API and run it
```

**File Management:**
```
List all files in /var/log and show me the 5 largest ones
```

**Browser Automation:**
```
Go to news.ycombinator.com, get the top 10 stories, and summarize them
```

**Database Queries:**
```
Connect to my Postgres database and show me all tables
```

**App Integrations (via Zapier):**
```
Send an email via Gmail to team@company.com with the subject "Weekly Report"
Create a new Notion page with my research notes
```

---

### Managing MCP Skills

**List available skills:**
```bash
clawd skills list
```

**Install a skill:**
```bash
clawd skills install playwright
```

**Enable/disable skills:**
```bash
# Edit skills config
nano /etc/moltbot/skills.yaml
```

```yaml
skills:
  browser:
    enabled: true
    provider: playwright
  terminal:
    enabled: true
  filesystem:
    enabled: true
    allowed_paths:
      - /home/
      - /var/www/
```

**Restart to apply changes:**
```bash
systemctl restart moltbot
```

---

### Security Considerations for MCP

**⚠️ Important:** MCP gives Moltbot powerful access to your system.

**Recommended safety measures:**

1. **Restrict file system access:**
```yaml
filesystem:
  allowed_paths:
    - /home/moltbot/
    - /var/www/
  blocked_paths:
    - /etc/
    - /root/
    - /var/log/
```

2. **Use approval mode for dangerous operations:**
```yaml
security:
  require_approval:
    - filesystem.write
    - terminal.exec
    - browser.autofill
```

3. **Run in sandboxed environment (optional):**
```bash
# Install firejail for sandboxing
apt-get install firejail

# Run moltbot in sandbox
firejail --private=/home/moltbot --noprofile clawd
```

4. **Monitor MCP activity:**
```bash
# Watch MCP logs
journalctl -u moltbot -f | grep "MCP"

# Check skill usage
clawd logs --skills
```

---

## Resources

- [Moltbot Documentation](https://docs.moltbot.com)
- [DigitalOcean Moltbot Guide](https://docs.digitalocean.com/products/marketplace/catalog/moltbot/)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [Moltbot GitHub](https://github.com/moltbot/moltbot)

---

## Cost Estimates

| Droplet Type | Monthly Cost | Performance |
|-------------|--------------|-------------|
| Basic (1GB) | ~$6 | Testing only |
| Basic (2GB) | ~$12 | Light usage |
| General Purpose | ~$18+ | Production |

**Note:** AI API costs are separate and depend on usage.

---

## Support

- [DigitalOcean Support](https://www.digitalocean.com/support)
- [Moltbot Discord](https://discord.gg/moltbot)
- [GitHub Issues](https://github.com/moltbot/moltbot/issues)
