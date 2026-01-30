# Deploy to GitHub Pages - Complete Guide

This guide will walk you through publishing your Moltbot tutorial website to GitHub Pages.

## 🎯 What You'll Get

After deployment, your tutorial will be live at:
**`https://axvg.github.io/money/kimi/tutorial-site/`**

## 🚀 Deployment Steps

### Step 1: Create GitHub Repository

You have two options:

#### Option A: Using GitHub CLI (Recommended)

```bash
# Install GitHub CLI if not already installed
# https://cli.github.com/

# Login to GitHub
gh auth login

# Create repository
gh repo create money --public --source=. --remote=origin --push
```

#### Option B: Using Git Commands

```bash
# Add remote repository
git remote add origin https://github.com/axvg/money.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 2: Enable GitHub Pages

1. Go to your repository on GitHub: `https://github.com/axvg/money`
2. Click **Settings** tab
3. Scroll down to **Pages** section (left sidebar)
4. Under **Build and deployment**:
   - Source: Select **GitHub Actions**
5. Click **Save**

### Step 3: Wait for Deployment

The GitHub Actions workflow will automatically:
- Build your site
- Deploy to GitHub Pages
- Make it publicly available

This takes about **2-3 minutes**.

### Step 4: Access Your Site

Once deployed, visit:
```
https://axvg.github.io/money/kimi/tutorial-site/
```

## 📁 What's Deployed

Only the `tutorial-site/` directory is deployed, containing:
- `index.html` - The main tutorial page

## 🔄 Automatic Updates

Any time you push changes to the `main` branch:
```bash
git add .
git commit -m "Update tutorial"
git push origin main
```

The site will automatically rebuild and deploy within 2-3 minutes!

## 🛠️ Local Development

To preview locally before deploying:

```bash
# Using Python
python -m http.server 8000 --directory tutorial-site

# Using Node.js
npx serve tutorial-site

# Using PHP
php -S localhost:8000 -t tutorial-site
```

Then open: `http://localhost:8000`

## 🎨 Customization

### Change the URL Path

If you want a different URL, edit `.github/workflows/deploy.yml`:

```yaml
- name: Upload artifact
  uses: actions/upload-pages-artifact@v3
  with:
    path: './tutorial-site'  # Change this to your folder
```

### Use a Custom Domain

1. Add a `CNAME` file to `tutorial-site/`:
   ```
   yourdomain.com
   ```

2. In GitHub Settings > Pages:
   - Enter your custom domain
   - Enable HTTPS

3. Configure DNS:
   - Add CNAME record pointing to `axvg.github.io`

## 🆘 Troubleshooting

### Site Not Showing

1. Check GitHub Actions status:
   - Go to **Actions** tab in your repo
   - Look for green checkmark (✅) on latest workflow

2. Common issues:
   - **404 error**: Wait 2-3 minutes for propagation
   - **Not found**: Check that `tutorial-site/index.html` exists
   - **Build failed**: Check Actions logs for errors

### Workflow Not Running

Make sure:
- Repository is public (or you have GitHub Pro)
- `.github/workflows/deploy.yml` exists
- Push was made to `main` or `master` branch

### Changes Not Appearing

1. Hard refresh: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)
2. Clear browser cache
3. Check deployment status in Actions tab

## 📊 Build Status

You can monitor deployments at:
```
https://github.com/axvg/money/actions
```

## 🎯 Next Steps

Once deployed:

1. **Share the link**: `https://axvg.github.io/money/kimi/tutorial-site/`
2. **Test it**: Open in different browsers and devices
3. **Update it**: Make improvements and push changes
4. **Add analytics**: (Optional) Add Google Analytics tracking

## 📝 Useful Commands

```bash
# Check git status
git status

# View commit history
git log --oneline

# Check remote URL
git remote -v

# Force push (use with caution)
git push origin main --force

# Pull latest changes
git pull origin main
```

## 🎉 Success!

Your tutorial is now live and accessible worldwide! 🌍

---

**Live Site**: https://axvg.github.io/money/kimi/tutorial-site/

**Repository**: https://github.com/axvg/money
