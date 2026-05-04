.PHONY: help dev prod deploy-dev deploy-prod deploy build-dev build-prod clean status preview-dev preview-prod init-cname

help:
	@echo "================================"
	@echo "🎯 DAARD Viewer - Build & Deploy"
	@echo "================================"
	@echo ""
	@echo "📦 BUILD:"
	@echo "  make build-dev       Build für Staging (geonode-dev)"
	@echo "  make build-prod      Build für Live (geoserver)"
	@echo ""
	@echo "🚀 DEPLOY:"
	@echo "  make deploy-dev      Build + Deploy zu staging repo (/docs)"
	@echo "  make deploy-prod     Build + Deploy zu main repo (/docs)"
	@echo ""
	@echo "🔗 QUICK:"
	@echo "  make dev             dev build nur"
	@echo "  make prod            prod build nur"
	@echo ""
	@echo "📍 URLs:"
	@echo "  Staging: https://daard-viewer-staging.cuprit.net/"
	@echo "  Live:    https://daard-viewer.cuprit.net/"
	@echo ""
	@echo "🧹 UTILS:"
	@echo "  make clean           Löscht dist/ und docs/"
	@echo "  make status          Zeigt Git Status"
	@echo "  make init-cname      Erstellt CNAME Dateien"
	@echo "  make preview-dev     Build + Preview Staging"
	@echo "  make preview-prod    Build + Preview Live"
	@echo ""

# ==================== BUILD ====================
build-dev:
	@echo "🔨 Building for Development (geonode-dev)..."
	npm run build:dev
	@echo "✅ Development build complete"

build-prod:
	@echo "🔨 Building for Production (geoserver)..."
	npm run build:prod
	@echo "✅ Production build complete"

dev: build-dev

prod: build-prod

# ==================== CNAME SETUP ====================

init-cname:
	@echo "🔧 Setting up CNAME files..."
	@mkdir -p public
	@echo "daard-viewer.cuprit.net" > public/CNAME
	@echo "✅ Created public/CNAME for production"
	@echo ""
	@echo "📝 Next step:"
	@echo "  Update vite.config.js and add: publicDir: 'public'"
	@echo "  Then CNAME will automatically be included in builds!"
	@echo ""

# ==================== DEPLOY ====================

deploy-dev: build-dev
	@echo ""
	@echo "📤 Deploying to STAGING (daard-ol-viewer-staging)..."
	@echo "   URL: https://daard-viewer-staging.cuprit.net/"
	@echo ""
	@echo "📝 Preparing /docs folder..."
	@if [ -f docs/CNAME ]; then \
		cp docs/CNAME /tmp/CNAME.staging.bak; \
		echo "✅ Existing CNAME backed up"; \
	else \
		echo "daard-viewer-staging.cuprit.net" > /tmp/CNAME.staging.bak; \
		echo "✅ Created new CNAME for staging"; \
	fi
	@rm -rf docs
	@mkdir -p docs
	@cp -r dist/* docs/
	@echo "✅ Files copied to /docs"
	@if [ -f /tmp/CNAME.staging.bak ]; then \
		cp /tmp/CNAME.staging.bak docs/CNAME; \
		echo "✅ CNAME restored/created: $$(cat docs/CNAME)"; \
	fi
	@echo ""
	@echo "📝 Git operations..."
	@git add docs/
	@git commit -m "🚀 Deploy staging: geonode-dev.dainst.org" || echo "No changes to commit"
	@git push staging main -f
	@echo "✅ Pushed to staging repo (main branch)"
	@echo ""
	@echo "🎉 Staging deployment complete!"
	@echo "   Check: https://daard-viewer-staging.cuprit.net/"
	@echo ""

deploy-prod: build-prod
	@echo ""
	@echo "📤 Deploying to PRODUCTION (daard-ol-viewer)..."
	@echo "   URL: https://daard-viewer.cuprit.net/"
	@echo ""
	@echo "📝 Preparing /docs folder..."
	@if [ -f docs/CNAME ]; then \
		cp docs/CNAME /tmp/CNAME.prod.bak; \
		echo "✅ Existing CNAME backed up"; \
	else \
		echo "daard-viewer.cuprit.net" > /tmp/CNAME.prod.bak; \
		echo "✅ Created new CNAME for production"; \
	fi
	@rm -rf docs
	@mkdir -p docs
	@cp -r dist/* docs/
	@echo "✅ Files copied to /docs"
	@if [ -f /tmp/CNAME.prod.bak ]; then \
		cp /tmp/CNAME.prod.bak docs/CNAME; \
		echo "✅ CNAME restored/created: $$(cat docs/CNAME)"; \
	fi
	@echo ""
	@echo "📝 Git operations..."
	@git add docs/
	@git commit -m "🚀 Deploy production: geoserver.dainst.org" || echo "No changes to commit"
	@git push origin main -f
	@echo "✅ Pushed to main repo (main branch)"
	@echo ""
	@echo "🎉 Production deployment complete!"
	@echo "   Check: https://daard-viewer.cuprit.net/"
	@echo ""

deploy: deploy-prod

# ==================== UTILS ====================

clean:
	@echo "🧹 Cleaning..."
	rm -rf dist/
	rm -rf docs/
	@echo "✅ Cleaned"

status:
	@echo "📊 Repository Status:"
	@echo ""
	@echo "Origin (Production):"
	@git remote get-url origin
	@echo ""
	@echo "Staging:"
	@git remote get-url staging
	@echo ""
	@echo "Current branch: $$(git rev-parse --abbrev-ref HEAD)"
	@echo "Last commit: $$(git log -1 --pretty=format:'%h - %s')"
	@echo ""
	@echo "CNAME Files:"
	@if [ -f docs/CNAME ]; then echo "  ✅ docs/CNAME: $$(cat docs/CNAME)"; else echo "  ❌ docs/CNAME: not found"; fi
	@if [ -f public/CNAME ]; then echo "  ✅ public/CNAME: $$(cat public/CNAME)"; else echo "  ⚠️  public/CNAME: not found (optional)"; fi
	@echo ""

preview-dev: build-dev
	@echo "👀 Preview Development Build..."
	npm run serve:dev

preview-prod: build-prod
	@echo "👀 Preview Production Build..."
	npm run serve:prod