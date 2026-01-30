# Moltbot Configuration - Your Personal Freelance Coder

This directory contains all configuration files to transform your Moltbot into a personal freelance developer that lives on DigitalOcean and communicates via Telegram.

## 🎯 What You Get

Your Moltbot will be able to:

### 💻 **Coding Capabilities**
- **Write code** in Python, JavaScript, TypeScript, Go, Rust, and more
- **Debug and fix** code issues
- **Generate tests** automatically
- **Refactor and optimize** existing code
- **Review code** and suggest improvements
- **Create documentation** automatically

### 🌐 **Web & Research**
- **Browse websites** using Firefox/Chrome automation
- **Research topics** and compile reports
- **Scrape data** from websites
- **Search documentation** and Stack Overflow
- **Analyze competitors** and technologies

### 📁 **File & Project Management**
- **Create projects** from templates (Python, React, Node.js, etc.)
- **Manage files** safely in allowed directories
- **Track tasks** and pending work
- **Git workflows** (commit, push, pull, branch)
- **Auto-backup** your work

### 🚀 **DevOps & Deployment**
- **Dockerize applications**
- **Setup CI/CD** pipelines
- **Deploy to** DigitalOcean, Vercel, Heroku
- **Monitor applications**

### 🤖 **Smart Assistance**
- **24/7 availability** on Telegram
- **Daily summaries** of work completed
- **Progress reports** on tasks
- **Code explanations** in plain English
- **Tutorials and guides** generation

---

## 📁 Configuration Files

| File | Purpose | Required |
|------|---------|----------|
| `config.yaml` | Main Moltbot configuration | ✅ Yes |
| `mcp.json` | MCP servers (browser, terminal, etc.) | ✅ Yes |
| `skills.yaml` | Enable/disable specific skills | ✅ Yes |
| `.env.template` | Environment variables template | ✅ Yes (copy to .env) |
| `setup.sh` | Automated setup script | 🔄 Optional |

---

## 🚀 Quick Setup Guide

### Step 1: Prepare Your DigitalOcean Droplet

1. **Create a Droplet** (Recommended: 2GB RAM minimum)
   - OS: Ubuntu 22.04 LTS
   - Size: Basic $12/month (2GB RAM / 1 CPU)
   - Datacenter: Close to your location

2. **SSH into your droplet:**
   ```bash
   ssh root@YOUR_DROPLET_IP
   ```

### Step 2: Run Automated Setup

```bash
# Upload this molt-config directory to your droplet
cd molt-config
chmod +x setup.sh
sudo ./setup.sh
```

This script will:
- ✅ Create `moltbot` user
- ✅ Install Node.js, Python, and dependencies
- ✅ Install Playwright and browsers
- ✅ Install MCP servers
- ✅ Set up directory structure
- ✅ Create systemd service
- ✅ Configure firewall
- ✅ Set up log rotation

### Step 3: Configure Environment Variables

```bash
# Copy the template
cp /path/to/molt-config/.env.template /etc/moltbot/.env

# Edit the file
nano /etc/moltbot/.env
```

**Fill in these required values:**

```bash
# From @BotFather on Telegram
TELEGRAM_BOT_TOKEN=your_actual_bot_token

# From @userinfobot on Telegram
YOUR_TELEGRAM_USER_ID=your_actual_user_id

# From Anthropic (or OpenAI/Google)
ANTHROPIC_API_KEY=your_actual_api_key
```

### Step 4: Copy Configuration Files

```bash
# Copy all config files to /etc/moltbot/
cp config.yaml /etc/moltbot/
cp mcp.json /etc/moltbot/
cp skills.yaml /etc/moltbot/

# Secure the .env file
chmod 600 /etc/moltbot/.env
chown moltbot:moltbot /etc/moltbot/.env
```

### Step 5: Start Moltbot

```bash
# Start the service
sudo systemctl start moltbot

# Enable auto-start on boot
sudo systemctl enable moltbot

# Check status
sudo systemctl status moltbot

# View logs in real-time
sudo journalctl -u moltbot -f
```

### Step 6: Test on Telegram

1. Open Telegram
2. Find your bot (from Step 1)
3. Send: `/start`
4. Try: `Hello! What can you do?`

---

## 💬 Example Telegram Conversations

### Basic Coding
```
You: Create a Python script that fetches weather data from OpenWeatherMap API
Bot: [Creates and saves the script + shows you the code]

You: Run it
Bot: [Executes the script and shows results]
```

### Web Research
```
You: Research the best Python web frameworks in 2025 and create a comparison
Bot: [Browses web, researches, creates comparison table + summary]
```

### Project Management
```
You: Create a new Flask API project called "my-api"
Bot: [Creates project structure with all necessary files]

You: Add user authentication to the API
Bot: [Updates the project with auth middleware]

You: Commit and push to GitHub
Bot: [Commits with message + pushes to remote]
```

### Task Management
```
You: Add task: Fix bug in login system, priority high
Bot: [Adds task to task list]

You: Show my pending tasks
Bot: [Lists all tasks with priorities]

You: Mark task "Fix bug" as complete
Bot: [Updates task status]
```

### Debugging
```
You: Debug this error: [paste error message]
Bot: [Analyzes error, suggests fixes, applies solution]
```

### File Operations
```
You: List all files in my projects directory
Bot: [Shows file tree]

You: Read the content of my-api/app.py
Bot: [Shows file content]

You: Update app.py to add a health check endpoint
Bot: [Edits the file + shows diff]
```

---

## 🔐 Security Features

Your configuration includes:

### ✅ **Safe Defaults**
- **Whitelisted commands** (blocks dangerous ones like `sudo`, `rm -rf /`)
- **Restricted file access** (only `/home/moltbot/` directories)
- **Approval required** for destructive operations
- **Audit logging** of all actions

### ✅ **User Restrictions**
- Only your Telegram user ID can control the bot
- File access limited to specific directories
- No access to system directories

### ✅ **Network Security**
- Firewall enabled (only SSH and Moltbot ports open)
- Rate limiting on requests
- Domain restrictions for web browsing

### ✅ **Backup & Recovery**
- Auto-backup daily
- 7 days of backups kept
- Easy restore process

---

## 🛠️ Customization

### Enable More MCP Servers

Edit `/etc/moltbot/mcp.json` to add more capabilities:

```json
{
  "mcpServers": {
    "zapier": {
      "command": "npx",
      "args": ["-y", "@zapier/mcp"],
      "env": {
        "ZAPIER_MCP_TOKEN": "your_token"
      }
    }
  }
}
```

### Add Custom Skills

Edit `/etc/moltbot/skills.yaml`:

```yaml
skills:
  my_custom_skill:
    enabled: true
    description: "My custom automation"
```

### Change AI Provider

Edit `/etc/moltbot/config.yaml`:

```yaml
ai:
  provider: openai  # or 'gemini'
  api_key: "${OPENAI_API_KEY}"
  model: "gpt-4-turbo"
```

---

## 📊 Monitoring & Maintenance

### Check Bot Health
```bash
# Check if running
sudo systemctl status moltbot

# View logs
sudo journalctl -u moltbot -f

# Check resource usage
htop
```

### Backup Your Work
```bash
# Manual backup
sudo /home/moltbot/scripts/backup.sh

# Download backup to your machine
scp root@YOUR_DROPLET_IP:/home/moltbot/backups/*.tar.gz .
```

### Update Moltbot
```bash
# Run update script
sudo /home/moltbot/scripts/update.sh

# Or manually
sudo systemctl stop moltbot
sudo npm update -g clawdbot
sudo systemctl start moltbot
```

### View Task Progress
```bash
# Check task database
sudo sqlite3 /home/moltbot/data/moltbot.db "SELECT * FROM tasks;"
```

---

## 🆘 Troubleshooting

### Bot Not Responding
```bash
# Check if service is running
sudo systemctl status moltbot

# Restart the service
sudo systemctl restart moltbot

# Check logs for errors
sudo journalctl -u moltbot -n 50 --no-pager
```

### Telegram Token Issues
```bash
# Test your token
curl -s "https://api.telegram.org/botYOUR_TOKEN/getMe"

# Should return your bot info
```

### MCP Servers Not Working
```bash
# Check if MCP servers are installed
which npx
npx -y @executeautomation/playwright-mcp-server --help

# Reinstall if needed
sudo npm install -g @executeautomation/playwright-mcp-server
```

### Permission Errors
```bash
# Fix permissions
sudo chown -R moltbot:moltbot /home/moltbot
sudo chown -R moltbot:moltbot /etc/moltbot
```

---

## 📚 Additional Resources

- [Moltbot Documentation](https://docs.moltbot.com)
- [MCP Servers Registry](https://mcp.use.com)
- [Playwright Documentation](https://playwright.dev)
- [Telegram Bot API](https://core.telegram.org/bots/api)

---

## 💡 Tips for Best Experience

1. **Start small** - Test with simple commands first
2. **Use specific prompts** - "Create a Python function to calculate fibonacci" works better than "Write some code"
3. **Review before applying** - The bot will ask for approval on destructive operations
4. **Keep backups** - Regular backups protect your work
5. **Monitor costs** - AI API usage can add up, set spending limits
6. **Use tasks** - Add tasks to track long-term work
7. **Check daily summaries** - Review what the bot accomplished

---

## 🤝 Support

- [Moltbot Discord](https://discord.gg/moltbot)
- [GitHub Issues](https://github.com/moltbot/moltbot/issues)
- [DigitalOcean Support](https://www.digitalocean.com/support)

---

**🎉 You're ready to have your own 24/7 freelance developer!**

Just send a message on Telegram and start coding together.
