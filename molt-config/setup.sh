#!/bin/bash

# Moltbot Setup Script for DigitalOcean
# This script sets up Moltbot as your personal freelance coder

set -e

echo "🦞 Setting up Moltbot as your personal developer..."
echo "=================================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

# Configuration
MOLTBOT_USER="moltbot"
MOLTBOT_HOME="/home/moltbot"
CONFIG_DIR="/etc/moltbot"
LOG_DIR="/var/log/moltbot"
PROJECTS_DIR="$MOLTBOT_HOME/projects"
NOTES_DIR="$MOLTBOT_HOME/notes"
EXAMPLES_DIR="$MOLTBOT_HOME/examples"
DATA_DIR="$MOLTBOT_HOME/data"
BACKUP_DIR="$MOLTBOT_HOME/backups"
SCREENSHOTS_DIR="$MOLTBOT_HOME/screenshots"

echo -e "${BLUE}Step 1: Creating moltbot user...${NC}"
if ! id "$MOLTBOT_USER" &>/dev/null; then
    useradd -m -s /bin/bash -d $MOLTBOT_HOME $MOLTBOT_USER
    echo "User $MOLTBOT_USER created"
else
    echo "User $MOLTBOT_USER already exists"
fi

echo -e "${BLUE}Step 2: Installing system dependencies...${NC}"
apt-get update
apt-get install -y \
    curl \
    wget \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    libnss3 \
    libatk-bridge2.0-0 \
    libxss1 \
    libgtk-3-0 \
    libgbm-dev \
    libasound2 \
    fonts-liberation \
    libappindicator3-1 \
    xdg-utils \
    unzip \
    jq \
    htop \
    vim \
    nano \
    docker.io \
    firejail \
    sqlite3 \
    redis-tools

echo -e "${BLUE}Step 3: Installing Node.js 18+...${NC}"
if ! command -v node &> /dev/null || [ "$(node -v | cut -d'v' -f2 | cut -d'.' -f1)" -lt 18 ]; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
fi

echo -e "${BLUE}Step 4: Installing Moltbot...${NC}"
if ! command -v clawd &> /dev/null; then
    # Install via official installer
    curl -fsSL https://molt.bot/install.sh | bash
    
    # Or install via npm
    # npm install -g clawdbot
fi

echo -e "${BLUE}Step 5: Creating directory structure...${NC}"
mkdir -p $CONFIG_DIR
mkdir -p $LOG_DIR
mkdir -p $PROJECTS_DIR
mkdir -p $NOTES_DIR
mkdir -p $EXAMPLES_DIR
mkdir -p $DATA_DIR
mkdir -p $BACKUP_DIR
mkdir -p $SCREENSHOTS_DIR
mkdir -p $MOLTBOT_HOME/mcp-servers
mkdir -p $MOLTBOT_HOME/.cache
mkdir -p $MOLTBOT_HOME/venv

echo -e "${BLUE}Step 6: Setting up Python virtual environment...${NC}"
python3 -m venv $MOLTBOT_HOME/venv
source $MOLTBOT_HOME/venv/bin/activate
pip install --upgrade pip
pip install \
    requests \
    beautifulsoup4 \
    selenium \
    playwright \
    pytest \
    black \
    flake8 \
    ruff \
    jupyter \
    pandas \
    numpy

echo -e "${BLUE}Step 7: Installing Playwright browsers...${NC}}
playwright install firefox
playwright install chromium

echo -e "${BLUE}Step 8: Installing MCP servers...${NC}"
# Install Playwright MCP
npm install -g @executeautomation/playwright-mcp-server

# Install other MCP servers
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-terminal
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-sequential-thinking

# Install uv for Python MCP servers
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo -e "${BLUE}Step 9: Setting permissions...${NC}"
chown -R $MOLTBOT_USER:$MOLTBOT_USER $MOLTBOT_HOME
chown -R $MOLTBOT_USER:$MOLTBOT_USER $CONFIG_DIR
chown -R $MOLTBOT_USER:$MOLTBOT_USER $LOG_DIR
chmod 755 $MOLTBOT_HOME
chmod 750 $CONFIG_DIR

echo -e "${BLUE}Step 10: Creating systemd service...${NC}"
cat > /etc/systemd/system/moltbot.service << 'EOF'
[Unit]
Description=Moltbot - Personal AI Developer
After=network.target

[Service]
Type=simple
User=moltbot
Group=moltbot
WorkingDirectory=/home/moltbot
EnvironmentFile=/etc/moltbot/.env
Environment="PATH=/home/moltbot/venv/bin:/usr/local/bin:/usr/bin:/bin"
Environment="HOME=/home/moltbot"
Environment="PYTHONPATH=/home/moltbot/venv/lib/python3.10/site-packages"
ExecStart=/usr/local/bin/clawd
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable moltbot

echo -e "${BLUE}Step 11: Creating log rotation...${NC}"
cat > /etc/logrotate.d/moltbot << 'EOF'
/var/log/moltbot/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 moltbot moltbot
    sharedscripts
    postrotate
        /bin/kill -HUP $(cat /var/run/syslogd.pid 2> /dev/null) 2> /dev/null || true
    endscript
}
EOF

echo -e "${BLUE}Step 12: Setting up firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 22/tcp    # SSH
    ufw allow 3000/tcp  # Moltbot Gateway
    ufw --force enable
fi

echo -e "${BLUE}Step 13: Creating helper scripts...${NC}"

# Create backup script
cat > $MOLTBOT_HOME/scripts/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/moltbot/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="moltbot_backup_$DATE.tar.gz"

tar -czf $BACKUP_DIR/$BACKUP_FILE \
    /home/moltbot/projects \
    /home/moltbot/notes \
    /home/moltbot/data \
    /etc/moltbot \
    2>/dev/null

echo "Backup created: $BACKUP_DIR/$BACKUP_FILE"

# Keep only last 7 backups
ls -t $BACKUP_DIR/*.tar.gz | tail -n +8 | xargs -r rm
EOF
chmod +x $MOLTBOT_HOME/scripts/backup.sh

# Create update script
cat > $MOLTBOT_HOME/scripts/update.sh << 'EOF'
#!/bin/bash
echo "Updating Moltbot..."
systemctl stop moltbot
npm update -g clawdbot
systemctl start moltbot
echo "Update complete!"
EOF
chmod +x $MOLTBOT_HOME/scripts/update.sh

echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Copy .env.template to /etc/moltbot/.env and fill in your tokens"
echo "2. Copy config.yaml to /etc/moltbot/config.yaml"
echo "3. Copy mcp.json to /etc/moltbot/mcp.json"
echo "4. Copy skills.yaml to /etc/moltbot/skills.yaml"
echo "5. Start Moltbot: sudo systemctl start moltbot"
echo "6. Check logs: sudo journalctl -u moltbot -f"
echo ""
echo -e "${BLUE}Your moltbot is ready to be your freelance coder! 🚀${NC}"
